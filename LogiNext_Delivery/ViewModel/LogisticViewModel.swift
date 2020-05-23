//
//  LogisticViewModel.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation
import RealmSwift

class LogisticViewModel {
    let databaseManager: DataManagerProtocol
    let manager: LogisticManagerProtocol
    
    init(db: DataManagerProtocol = RealmDataManager(realm: RealmProvider.default)) {
        self.databaseManager = db
        self.manager = LogisticManager(dbManager: db)
    }
    
    func saveUser(name: String, date: Date, completion: (Bool) -> Void) {
        let userDTO = UserDTO(name: name, id: Int(date.timeIntervalSince1970))
        manager.saveUser(user: userDTO, completion: completion)
    }
    
    func getAllUsers(completion: ([UserDTO]) -> Void) {
        manager.getAllUser(sorted: Sorted(key: "name", ascending: true), completion: completion)
    }
    
    func createOrder(name: String, date: Date, completion: (OrderDTO) -> Void) {
        let orderDTO = OrderDTO(id: Int(date.timeIntervalSince1970), name: name)
        manager.createOrder(order: orderDTO) {[weak self] (orderDTO) in
            guard let slf = self, let orderdto = orderDTO else {return}
            completion(orderdto)
        }
    }
    
    
}
