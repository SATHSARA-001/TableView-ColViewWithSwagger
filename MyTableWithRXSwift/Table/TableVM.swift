//
//  TableVM.swift
//  MyTableWithRXSwift
//
//  Created by Sathsara Maduranga on 6/18/20.
//  Copyright © 2020 Sathsara Maduranga. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

class TableVM :NSObject{
    
    var serviceCentreList = BehaviorRelay<[ServiceCentre]>(value: [])
    var serviceCentres: [ServiceCentre] = []
    var paginator: Paginator?
    
    func fetchUsersNetworkRequest(isLoadMore: Bool, page: Int, perPage: Int, completion: @escaping completionHandler){
        ServiceCentresAPI.serviceCentresPost(page: Double(page)) { (response, error) in
            //print(response,error)
            if error != nil {
                if let errorResponse = error as? ErrorResponse {
                    switch errorResponse {
                    case .error(let statusCode, let data, _):
                        guard let responseData = data else {return}
                        let jsonError = JSON(responseData)
                       
                        completion(false, statusCode, jsonError["message"].stringValue)
                    }
                }
                
            } else {
                guard let _serviceCentreList = response?.payload else {return}
                
                if isLoadMore {
                    self.serviceCentres.append(contentsOf: _serviceCentreList)
                } else {
                    self.serviceCentres = _serviceCentreList
                }
                
                self.serviceCentreList.accept(self.serviceCentres)
                
                self.paginator = response?.paginator
                
                completion(true, 200, "success")
            }
        }
    }
}

