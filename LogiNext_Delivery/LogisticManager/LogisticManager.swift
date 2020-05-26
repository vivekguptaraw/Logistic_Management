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
    func saveUser(user: UserDTO, completion: (UserDTO?) -> Void)
    func createOrder(order: OrderDTO, completion: @escaping (OrderDTO?) -> Void)
    func getCurrentUser(userId: Int32, completion: (UserDTO?) -> Void)
    func getAllOrders(sorted: Sorted?, completion: ([OrderDTO]?) -> Void)
    func updateOrder(order: OrderDTO, completion: @escaping (OrderDTO?) -> Void)
    func getOrdersFor(predicate: NSPredicate?, sorted: Sorted?, completion: ([OrderDTO]?) -> Void)
    func createUserLocationEntry(userLocDTO: UserLocationDTO,  completion: (UserLocationDTO?) -> Void)
    func getActualStartLocationFromDB(userId: Int, completion: (UserLocationDTO?) -> Void)
    func deleteOldUsersLocationFromDb()
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
    
    func getOrdersFor(predicate: NSPredicate?, sorted: Sorted?, completion: ([OrderDTO]?) -> Void) {
        super.fetch(Order.self, predicate: predicate, sorted: sorted) { (array) in
            let dtos = array.map {
                OrderDTO.mapFromPersistenceObject($0)
            }
            completion(dtos)
        }
    }
    
    func getAllOrders(sorted: Sorted?, completion: ([OrderDTO]?) -> Void) {
        super.fetch(Order.self, predicate: nil, sorted: sorted) { (array) in
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
    
    func saveUser(user: UserDTO, completion: (UserDTO?) -> Void) {
        do {
            let realmUser = user.mapToPersistenceObject()
            try super.save(object: realmUser)
            completion(UserDTO.mapFromPersistenceObject(realmUser))
        } catch let error {
            print(error.localizedDescription)
            completion(nil)
        }
    }
    
    func createUserLocationEntry(userLocDTO: UserLocationDTO, completion: (UserLocationDTO?) -> Void) {
        do {
            let realmLoc = userLocDTO.mapToPersistenceObject()
            try super.save(object: realmLoc)
            completion(UserLocationDTO.mapFromPersistenceObject(realmLoc))
        } catch let error {
            print(error.localizedDescription)
            completion(nil)
        }
    }
    
    func getActualStartLocationFromDB(userId: Int, completion: (UserLocationDTO?) -> Void) {
        let predicate = NSPredicate(format: "%K == %@", argumentArray: ["userId", userId])
        super.fetch(UserLocation.self, predicate: predicate, sorted: nil) { (locs) in
            if let first = locs.first {
                let loc = UserLocationDTO.mapFromPersistenceObject(first)
                completion(loc)
            } else {
                completion(nil)
            }
            
        }
    }
    
    func deleteOldUsersLocationFromDb() {
        do {
            try super.deleteAll(UserLocation.self)
        } catch {
            print(error.localizedDescription)
        }
    }
}
