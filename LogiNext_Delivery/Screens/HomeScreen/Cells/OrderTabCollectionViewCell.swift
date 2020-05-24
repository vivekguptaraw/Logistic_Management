//
//  OrderTabCollectionViewCell.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 24/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class OrderTabCollectionViewCell: UICollectionViewCell, ConfigurableCell {
    
    typealias T = String
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ item: String, at indexPath: IndexPath) {
        self.titleLabel.text = item
    }

}
