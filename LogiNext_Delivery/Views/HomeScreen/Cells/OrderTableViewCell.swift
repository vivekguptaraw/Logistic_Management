//
//  OrderTableViewCell.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 24/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell, ConfigurableCell {
    
    typealias T = OrderDTO
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var statusValueLabel: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var lastUpdatedByTitle: UILabel!
    @IBOutlet weak var lastUpdatedByValueLabel: UILabel!
    
    
    var orderDTO: OrderDTO?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    func configure(_ item: OrderDTO, at indexPath: IndexPath) {
        self.orderDTO = item
        titleLabel.text = item.name
        descriptionLabel.text = item.orderDescription
        statusValueLabel.text = item.status.rawValue
        self.dateLabel.text = item.getDateString(date: item.createdDate)
        self.statusValueLabel.textColor = item.getStatusColor()
        self.lastUpdatedByValueLabel.text = item.lastUpdatedByUser?.firstName
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.innerView.layer.cornerRadius = 12
    }
    
}
