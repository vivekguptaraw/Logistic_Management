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
    var pickUpSuccessBlock: (() -> Void)?
    var orderDTO: OrderDTO?
    var orderStatus = [StatusData]()
    var navigator: IHomeNavigator?
    
    init(logistics: LogisticViewModel, order: OrderDTO?) {
        self.logisiticsMainViewModel = logistics
        self.orderDTO = order
    }
    
    
    func pickUpOrder() {
        guard var order = orderDTO, let usr = self.logisiticsMainViewModel?.currentUser else {return}
        order.pickUp(byUser: usr)
        self.logisiticsMainViewModel?.pickUpOrder(order: order, completion: { (dto) in
            self.orderDTO = dto
            self.pickUpSuccessBlock?()
            self.navigator?.orderUpdated?()
        })
    }
    
    
    func createOrder(name: String, desc: String, date: Date) {
        self.logisiticsMainViewModel?.createOrder(name: name, desc: desc, date: date, completion: { (orderDTO) in
            self.successBlock?()
            self.navigator?.orderUpdated?()
        })
    }
    
    func setOrderStatus() {
        guard let order = self.orderDTO else {return}
        var tuple = [StatusData]()
        for i in 0..<4 {
            switch i {
            case 0:
                tuple.append((.Queued, order.isQueued))
            case 1:
                tuple.append((.InTransit, order.isInTransit))
            case 2:
                tuple.append((.Delivered, order.isDelivered))
            case 3:
                tuple.append((.Cancelled, order.isCancelled))
            default:
                break
            }
        }
        self.orderStatus = tuple
    }
}
