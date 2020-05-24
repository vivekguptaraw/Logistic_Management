//
//  OrderDTO.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

struct OrderDTO {
    var orderId: Int32
    var name: String
    var orderDescription: String?
    var createdDate: Date?
    var expectedDeliveryDate: Date?
    var deliveredDate: Date?
    var cancellededDate: Date?
    
    var isQueued: Bool = false
    var isInTransit: Bool = false
    var isDelivered: Bool = false
    var isCancelled: Bool = false
    
    var createdByUser: UserDTO?
    var pickedUpByUser: UserDTO?
    var deliveredByUser: UserDTO?
    var cancelledByUser: UserDTO?
    
    init(id: Int32, name: String, desc: String?) {
        self.orderId = id
        self.name = name
        self.orderDescription = desc
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
        model.orderId = self.orderId
        model.name = self.name
        model.orderDescription =  self.orderDescription
        model.createdDate = self.createdDate
        model.expectedDeliveryDate = self.expectedDeliveryDate
        model.deliveredDate = self.deliveredDate
        model.cancellededDate = self.cancellededDate
        model.isQueued = self.isQueued
        model.isInTransit = self.isInTransit
        model.isDelivered = self.isDelivered
        model.isCancelled = self.isCancelled
        model.createdByUser = self.createdByUser?.mapToPersistenceObject()
        model.pickedUpByUser = self.pickedUpByUser?.mapToPersistenceObject()
        model.deliveredByUser = self.deliveredByUser?.mapToPersistenceObject()
        model.cancelledByUser = self.cancelledByUser?.mapToPersistenceObject()
        return model
    }
    
    static func mapFromPersistenceObject(_ object: Order) -> OrderDTO {
        let orderDto = OrderDTO(id: object.orderId, name: object.name, desc: object.orderDescription)
        return orderDto
    }
}
