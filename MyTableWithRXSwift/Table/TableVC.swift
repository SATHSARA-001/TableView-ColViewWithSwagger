//
//  TableVC.swift
//  MyTableWithRXSwift
//
//  Created by Sathsara Maduranga on 6/18/20.
//  Copyright © 2020 Sathsara Maduranga. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import UIKit
import PullToRefreshKit

class TableVC: UIViewController,LoadingIndicatorDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!{didSet {tableView.rx.setDelegate(self).disposed(by: bag)}}
    
    var vm = TableVM() //VM instance
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addObservers() //setting observers between tableview and model
        
        self.setupRefreshHeader() //this is a paginate kit function to detect and load if tableview is scrolled to footer
        
        self.requestData(isLoadMore: false, page: 1, perPage: 50, keyword: nil) //initisl reload of 1st page
        
        
    }
    
    func addObservers() {
        vm.serviceCentreList.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: TableViewCell.self)) { row, model, cell in
                cell.configureCell(with: model)
        }
        .disposed(by: bag)
    }
    
    func requestData(isLoadMore: Bool, page: Int, perPage: Int, keyword: String?) {
        self.startLoading()
        vm.fetchUsersNetworkRequest(isLoadMore: isLoadMore, page: page, perPage: perPage, completion: { success, statusCode, message in
            self.stopLoading()
            if success {
                print(self.vm.serviceCentreList.value)
                self.setUpRefreshing()
            } else {
                let _action = AlertAction(title: .Dismiss, style: .default)
                AlertProvider(vc: self).showAlert(title: .Warning, message: .UnknownErrorOccured, action: _action)
            }
        })
    }
    
    //MARK: Pull to refresh
    func setupRefreshHeader() {
        
        self.tableView.configRefreshHeader(container:self) { [weak self] in
            self?.delay(1.0, closure: {
                
                self?.tableView.switchRefreshHeader(to: .normal(.success, 0.5))
                
                // Load feed posts again when pull down
                self?.requestData(isLoadMore: false, page: 1, perPage: 50, keyword: nil) //calling request data again and again
            })
        }
    }
    
    //MARK: Setup refreshing (Load more)
    // Set up top pull to refresh using PullToRefreshKit framework
    func setUpRefreshing() {
        let footer = self.configureLoadMoreFooter()//set footer
        
        let currentPage = vm.paginator?.currentPage ?? 0//get curent page
        let lastPage = vm.paginator?.lastPage ?? 0
        
        print("CURRENT PAGE IS: \(currentPage)")
        
        if currentPage < lastPage {
            self.tableView.configRefreshFooter(with: footer, container: self) {
                self.delay(1.0, closure: {
                    self.tableView.switchRefreshFooter(to: .normal)
                    //let _text: String? = self.vm.searchText.value.isEmpty ? nil : self.vm.searchText.value
                    self.requestData(isLoadMore: true, page: Int(currentPage) + 1, perPage: 50, keyword: nil)
                    self.tableView.switchRefreshFooter(to: .removed)
                })
            }
        } else {
            self.tableView.switchRefreshFooter(to: .noMoreData)
        }
    }
    
    func delay(_ delay: Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    //MARK: Configure load more
    func configureLoadMoreFooter() -> DefaultRefreshFooter {
        let footer = DefaultRefreshFooter.footer()
        footer.setText("", mode: .pullToRefresh)
        footer.setText("", mode: .noMoreData)
        footer.setText("Load more...", mode: .refreshing)
        footer.setText("Tap to load more", mode: .tapToRefresh)
        footer.tintColor = .black
        footer.textLabel.textColor  = .black
        footer.refreshMode = .scroll
        return footer
    }
    
    
    
}

extension TableVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

