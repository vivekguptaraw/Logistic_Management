//
//  UserTableViewCell.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

protocol UserSelected: class {
    func selectedUser(model: UserDTO)
}

class UserTableViewCell: UITableViewCell, ConfigurableCell {
    typealias T = UserDTO
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    var user: UserDTO?
    weak var selectedDelegate: UserSelected?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(_ item: UserDTO, at indexPath: IndexPath) {
        label.text = item.firstName
        user = item
    }
    @IBAction func selectClicked(_ sender: Any) {
        guard let usr = self.user else {return}
        selectedDelegate?.selectedUser(model: usr)
    }
    
}
