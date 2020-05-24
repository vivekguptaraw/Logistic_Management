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
}

class LogisticManager: BaseLogisticManager<Storable> {
    
}

extension LogisticManager: LogisticManagerProtocol {
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
