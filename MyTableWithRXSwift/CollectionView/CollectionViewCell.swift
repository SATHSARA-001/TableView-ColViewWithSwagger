//
//  CollectionViewCell.swift
//  MyTableWithRXSwift
//
//  Created by Sathsara Maduranga on 6/18/20.
//  Copyright © 2020 Sathsara Maduranga. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress : UILabel!
    
func configureCell(with model: ServiceCentre) {
    
    lblName.text = "\(model.name ?? "")"
    lblAddress.text = model.address ?? ""
}

}
