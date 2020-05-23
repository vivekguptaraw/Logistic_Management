//
//  LogisticManager.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

protocol LogisticManagerProtocol {
    func getAllUser(sorted: Sorted?, completion: ([UserDTO]) -> Void)
    func saveUser(user: UserDTO, completion: (Bool) -> Void)
    func createOrder(order: OrderDTO, completion: (OrderDTO?) -> Void)
}

class LogisticManager: BaseLogisticManager<User> {
    
}

extension LogisticManager: LogisticManagerProtocol {
    func createOrder(order: OrderDTO, completion: (OrderDTO?) -> Void) {
        do {
            let realmOrder = order.mapToPersistenceObject()
            try super.save(object: realmOrder)
            let orderDTO = OrderDTO.mapFromPersistenceObject(realmOrder)
            completion(orderDTO)
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
