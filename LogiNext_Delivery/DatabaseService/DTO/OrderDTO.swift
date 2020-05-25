//
//  OrderDTO.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

struct OrderDTO {
    var orderId: Int32
    var name: String
    var orderDescription: String?
    var createdDate: Date?
    var pickedUpDate: Date?
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
    
    func getLastUpdatedDate() -> Date? {
        var dt: Date?
        if isQueued {
            dt = createdDate
        }
        if isInTransit {
            dt = pickedUpDate
        }
        if isDelivered {
            dt = deliveredDate
        }
        if isCancelled {
            dt = cancellededDate
        }
        return dt
    }
    
    func getDateString(date: Date?) -> String {
        return Helper.getString(from: date)
    }
    
    mutating func created(byUser: UserDTO, date: Date) {
        self.createdByUser = byUser
        self.createdDate = date
        self.isQueued = true
    }
    
    mutating func pickUp(byUser: UserDTO) {
        self.pickedUpByUser = byUser
        self.isInTransit = true
        self.pickedUpDate = Date()
    }
    
    mutating func cancelled(byUser: UserDTO) {
        self.cancelledByUser = byUser
        self.isCancelled = true
        self.cancellededDate = Date()
    }
    
    mutating func delivered(byUser: UserDTO) {
        self.deliveredByUser = byUser
        self.isDelivered = true
        self.deliveredDate = Date()
    }
    
    func getStatusColor() -> UIColor {
        let color = UIColor(hexString: OrderDTO.OrderStatusColor.color(status: self.status).rawValue)
        return color
        
    }
    
    var status: OrderStatus {
        var st: OrderStatus = .Unknown
        if isQueued {
            st = .Queued
        }
        if isInTransit {
            st = .InTransit
        }
        if isDelivered {
            st = .Delivered
        }
        if isCancelled {
            st = .Cancelled
        }
        return st
    }
    
    enum OrderStatusColor: String {
        case Orange = "#FF8C00"
        case Blue = "#1464F4"
        case Green = "#32CD32"
        case Red = "#FF0000"
        case unknown = "#A9A9A9"
        
        static func color(status: OrderStatus) -> OrderStatusColor {
            switch  status {
            case .Queued:
                return .Orange
            case .InTransit:
                return .Blue
            case .Delivered:
                return .Green
            case .Cancelled:
                return .Red
            case .Unknown:
                return .unknown
            }
        }
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
        model.pickedUpDate = self.pickedUpDate
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
        var orderDto = OrderDTO(id: object.orderId, name: object.name, desc: object.orderDescription)
        orderDto.createdDate = object.createdDate
        orderDto.pickedUpDate = object.pickedUpDate
        orderDto.expectedDeliveryDate = object.expectedDeliveryDate
        orderDto.deliveredDate = object.deliveredDate
        orderDto.cancellededDate = object.cancellededDate
        orderDto.isQueued = object.isQueued
        orderDto.isInTransit = object.isInTransit
        orderDto.isDelivered = object.isDelivered
        orderDto.isCancelled = object.isCancelled
        if let usr = object.createdByUser {
            orderDto.createdByUser = UserDTO.mapFromPersistenceObject(usr)
        }
        if let usr = object.pickedUpByUser {
            orderDto.pickedUpByUser = UserDTO.mapFromPersistenceObject(usr)
        }
        if let usr = object.deliveredByUser {
            orderDto.deliveredByUser = UserDTO.mapFromPersistenceObject(usr)
        }
        if let usr = object.cancelledByUser {
            orderDto.cancelledByUser = UserDTO.mapFromPersistenceObject(usr)
        }
        return orderDto
    }
}

enum OrderStatus: String {
    case Queued = "Queued"
    case InTransit = "In Transit"
    case Delivered = "Delivered"
    case Cancelled = "Cancelled"
    case Unknown = "N/A"
}
