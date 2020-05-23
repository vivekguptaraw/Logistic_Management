//
//  OrderDTO.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

struct OrderDTO {
    var orderId: Int
    var name: String 
    var createdDate: Date?
    var expectedDeliveryDate: Date?
    var deliveredDate: Date?
    var cancellededDate: Date?
    
    var isQueued: Bool?
    var isInTransit: Bool?
    var isDelivered: Bool?
    var isCancelled: Bool?
    
    var createdByUser: UserDTO?
    var pickedUpByUser: UserDTO?
    var deliveredByUser: UserDTO?
    var cancelledByUser: UserDTO?
    
    init(id: Int, name: String) {
        self.orderId = id
        self.name = name
    }
    
    mutating func created(byUser: UserDTO, date: Date) {
        self.createdByUser = byUser
        self.createdDate = date
        self.isQueued = true
    }
    
    mutating func pickUp(byUser: UserDTO) {
        self.pickedUpByUser = byUser
        self.isInTransit = true
    }
    
    mutating func cancelled(byUser: UserDTO) {
        self.cancelledByUser = byUser
        self.isCancelled = true
    }
    
    mutating func delivered(byUser: UserDTO) {
        self.deliveredByUser = byUser
        self.isDelivered = true
    }
}

extension OrderDTO: MappableProtocol {
    
    typealias PersistenceType = Order
    
    func mapToPersistenceObject() -> Order {
        let model = Order()
        return model
    }
    
    static func mapFromPersistenceObject(_ object: Order) -> OrderDTO {
        let orderDto = OrderDTO(id: object.orderId, name: object.name)
        return orderDto
    }
    
}
