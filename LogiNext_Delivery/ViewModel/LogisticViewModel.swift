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
    var currentUser: UserDTO? {
        didSet {
            setCurrentUser()
        }
    }
    
    init(db: DataManagerProtocol = RealmDataManager(realm: RealmProvider.default)) {
        self.databaseManager = db
        self.manager = LogisticManager(dbManager: db)
        self.getCurrentUser()
    }
    
    func getCurrentUser() {
        let userDef = UserDefaults.standard
        if let userId = userDef.object(forKey: "userId") as? Int32 {
            manager.getCurrentUser(userId: userId) { (userDTO) in
                self.currentUser = userDTO
            }
        }
    }
    
    func setCurrentUser() {
        let userDef = UserDefaults.standard
        userDef.set(currentUser?.userId, forKey: "userId")
    }
    
    func saveUser(name: String, date: Date, completion: (Bool) -> Void) {
        let userDTO = UserDTO(name: name, id: Int(date.timeIntervalSince1970))
        manager.saveUser(user: userDTO, completion: completion)
    }
    
    func getAllUsers(completion: ([UserDTO]) -> Void) {
        manager.getAllUser(sorted: Sorted(key: "name", ascending: true), completion: completion)
    }
    
    func upadateOrder(order: OrderDTO, completion: @escaping (OrderDTO) -> Void) {
        manager.updateOrder(order: order) { (dto) in
            if let dt = dto {
                completion(dt)
            }
        }
    }
    
    func createOrder(name: String, desc: String, date: Date, completion: @escaping (OrderDTO) -> Void) {
        var orderDTO = OrderDTO(id: Int32(date.timeIntervalSince1970), name: name, desc: desc)
        if let user = self.currentUser {
            orderDTO.created(byUser: user, date: Date())
        }
        manager.createOrder(order: orderDTO) {[weak self] (orderDTO) in
            guard let slf = self, let orderdto = orderDTO else {return}
            completion(orderdto)
        }
    }
    
    func getAllOrders(completion: @escaping ([OrderDTO]?) -> Void) {
        manager.getAllOrders(userId: nil) { (orderDTOs) in
            completion(orderDTOs)
        }
    }
    
    func getOrdersFor(predicate: NSPredicate?, completion: ([OrderDTO]?) -> Void) {
        manager.getOrdersFor(predicate: predicate, completion: completion)
    }
    
    
}
