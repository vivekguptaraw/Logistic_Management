//
//  StatusCollectionViewCell.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 24/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

typealias StatusData = (OrderStatus, Bool)

class StatusCollectionViewCell: UICollectionViewCell, ConfigurableCell {
    
    typealias T = StatusData
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var radioView: VGRadio!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configure(_ item: StatusData, at indexPath: IndexPath) {
        self.titleLabel.text = item.0.rawValue
        
    }
    
    func setRadioColor(color: UIColor?, shouldShowColor: Bool) {
        if shouldShowColor {
            self.radioView.outerView.backgroundColor = color
            self.radioView.centerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        } else {
            self.radioView.outerView.backgroundColor = .clear
            self.radioView.centerView.backgroundColor = .clear
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.gestureRecognizers?.removeAll()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.radioView.centerView.layer.cornerRadius = self.radioView.centerView.frame.width / 2
        self.radioView.outerView.layer.cornerRadius = self.radioView.outerView.frame.width / 2
    }
}
