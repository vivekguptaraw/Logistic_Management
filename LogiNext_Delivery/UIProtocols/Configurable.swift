//
//  Configurable.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

protocol ConfigurableCell: NibLoadableProtocol {
    associatedtype T
    func configure(_ item: T, at indexPath: IndexPath)
}
