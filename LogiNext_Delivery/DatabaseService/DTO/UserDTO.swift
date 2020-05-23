//
//  UserDTO.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

struct UserDTO {
    var firstName = ""
    var userId = 0
    var orders = [OrderDTO]()
}

extension UserDTO: MappableProtocol {
    
    typealias PersistenceType = User
    
    func mapToPersistenceObject() -> User {
        let model = User()
        model.name = self.firstName
        model.userId = self.userId
        model.assignedOrders.append(objectsIn: self.orders.map {$0.mapToPersistenceObject()})
        return model
    }
    
    static func mapFromPersistenceObject(_ object: User) -> UserDTO {
        var orders = [OrderDTO]()
        object.assignedOrders.forEach { (o) in
            orders.append(OrderDTO.mapFromPersistenceObject(o))
        }
        let userDTO = UserDTO(firstName: object.name, userId: object.userId, orders: orders)
        return userDTO
        
    }
    
    
    
}
