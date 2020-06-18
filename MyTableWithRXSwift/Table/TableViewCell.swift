//
//  TableViewCell.swift
//  MyTableWithRXSwift
//
//  Created by Sathsara Maduranga on 6/18/20.
//  Copyright © 2020 Sathsara Maduranga. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with model: ServiceCentre) {
           
           lblName.text = "\(model.name ?? "")"
           lblAddress.text = model.address ?? ""
       }
    

}
