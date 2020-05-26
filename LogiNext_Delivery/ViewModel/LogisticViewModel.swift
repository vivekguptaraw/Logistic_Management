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
    let userIdKey = "userId"
    var currentUser: UserDTO?
    
    init(db: DataManagerProtocol = RealmDataManager(realm: RealmProvider.default)) {
        self.databaseManager = db
        self.manager = LogisticManager(dbManager: db)
        self.getCurrentUser()
    }
    
    func getCurrentUser() {
        let userDef = UserDefaults.standard
        if let userId = userDef.object(forKey: userIdKey) as? Int32 {
            manager.getCurrentUser(userId: userId) { (userDTO) in
                self.currentUser = userDTO
            }
        }
    }
    
    func setCurrentUser(userDTO: UserDTO) {
        self.currentUser = userDTO
        let userDef = UserDefaults.standard
        userDef.set(currentUser?.userId, forKey: userIdKey)
    }
    
    func saveUser(userDTO: UserDTO, completion: (UserDTO?) -> Void) {
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
        manager.createOrder(order: orderDTO) {(orderDTO) in
            guard let orderdto = orderDTO else {return}
            completion(orderdto)
        }
    }
    
    func getAllOrders(sorted: Sorted?, completion: @escaping ([OrderDTO]?) -> Void) {
        manager.getAllOrders(sorted: sorted) { (orderDTOs) in
            completion(orderDTOs)
        }
    }
    
    func getOrdersFor(predicate: NSPredicate?, sorted: Sorted?, completion: ([OrderDTO]?) -> Void) {
        manager.getOrdersFor(predicate: predicate, sorted: sorted, completion: completion)
    }
    
    func createUserLocation(userLocDTO: UserLocationDTO, completion: @escaping (UserLocationDTO?) -> Void) {
        manager.createUserLocationEntry(userLocDTO: userLocDTO) { (locDTO) in
            print(locDTO)
            completion(locDTO)
        }
    }
}
