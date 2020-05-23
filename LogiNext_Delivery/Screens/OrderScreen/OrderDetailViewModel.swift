//
//  OrderDetailViewModel.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

class OrderDetailViewModel {
    
    var logisiticsMainViewModel: LogisticViewModel?
    var successBlock: (() -> Void)?
    
    init(logistics: LogisticViewModel) {
        self.logisiticsMainViewModel = logistics
    }
    
    func createOrder(name: String, date: Date) {
        self.logisiticsMainViewModel?.createOrder(name: name, date: date, completion: { (orderDTO) in
            self.successBlock?()
        })
    }
}
