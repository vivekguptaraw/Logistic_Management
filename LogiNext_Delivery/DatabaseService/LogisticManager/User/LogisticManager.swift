//
//  LogisticManager.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation
import RealmSwift

protocol LogisticManagerProtocol {
    func getAllUser(sorted: Sorted?, completion: ([UserDTO]) -> Void)
    func saveUser(user: UserDTO, completion: (Bool) -> Void)
    func createOrder(order: OrderDTO, completion: @escaping (OrderDTO?) -> Void)
    func getCurrentUser(userId: Int32, completion: (UserDTO?) -> Void)
    func getAllOrders(userId: Int32?, completion: ([OrderDTO]?) -> Void)
    func updateOrder(order: OrderDTO, completion: @escaping (OrderDTO?) -> Void)
    func getOrdersFor(predicate: NSPredicate?, completion: ([OrderDTO]?) -> Void)
}

class LogisticManager: BaseLogisticManager<Storable> {
    
}

extension LogisticManager: LogisticManagerProtocol {
    
    func updateOrder(order: OrderDTO, completion: @escaping (OrderDTO?) -> Void) {
        let realmOrder = order.mapToPersistenceObject()
        do {
            try super.update(object: realmOrder) { (success) in
                let predicate = NSPredicate(format: "%K == %@", argumentArray: ["orderId", order.orderId])
                super.fetch(Order.self, predicate: predicate, sorted: nil) { (array) in
                    if let first = array.first {
                        let dto =
                            OrderDTO.mapFromPersistenceObject(first)
                        completion(dto)
                    }
                }
            }
        } catch {
            completion(nil)
        }
    }
    
    func getOrdersFor(predicate: NSPredicate?, completion: ([OrderDTO]?) -> Void) {
        super.fetch(Order.self, predicate: predicate, sorted: nil) { (array) in
            let dtos = array.map {
                OrderDTO.mapFromPersistenceObject($0)
            }
            completion(dtos)
        }
    }
    
    func getAllOrders(userId: Int32?, completion: ([OrderDTO]?) -> Void) {
        var predicate: NSPredicate?
        if let id = userId {
           predicate = NSPredicate(format: "createdByUser.userId == %@", id)
        }
        super.fetch(Order.self, predicate: predicate ?? nil, sorted: nil) { (array) in
            let dtos = array.map {
                OrderDTO.mapFromPersistenceObject($0)
            }
            completion(dtos)
        }
    }
    
    func getCurrentUser(userId: Int32, completion: (UserDTO?) -> Void) {
        let predicate = NSPredicate(format: "%K == %@", argumentArray: ["userId", userId])
        try super.fetch(User.self, predicate: predicate, sorted: nil, completion: { (array) in
            if let first = array.first {
                let userDTO = UserDTO.mapFromPersistenceObject(first)
                completion(userDTO)
            }
        })
    }
    
    func createOrder(order: OrderDTO, completion: @escaping (OrderDTO?) -> Void) {
        do {
            let realmOrder = order.mapToPersistenceObject()
            try super.save(object: realmOrder)
            completion(OrderDTO.mapFromPersistenceObject(realmOrder))
        } catch let error {
            print(error.localizedDescription)
            completion(nil)
        }
    }
    
    func getAllUser(sorted: Sorted?, completion: ([UserDTO]) -> Void) {
        super.fetch(User.self, predicate: nil, sorted: sorted) { (users) in
            let userDTOs = users.map {UserDTO.mapFromPersistenceObject($0)}
            completion(userDTOs)
        }
    }
    
    func saveUser(user: UserDTO, completion: (Bool) -> Void) {
        do {
            let realmUser = user.mapToPersistenceObject()
            try super.save(object: realmUser)
            completion(true)
        } catch let error {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    
}
