//
//  UserTableViewCell.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell, ConfigurableCell {
    typealias T = UserDTO
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(_ item: UserDTO, at indexPath: IndexPath) {
        label.text = item.firstName
    }
    
}
