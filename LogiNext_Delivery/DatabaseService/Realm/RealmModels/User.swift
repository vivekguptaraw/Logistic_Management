//
//  User.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var userId: Int = 0
    @objc dynamic var name: String = ""
    let assignedOrders = List<Order>()
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
    convenience init(_ userId: Int, _ name: String) {
        self.init()
        self.userId = userId
        self.name = name
    }
    
}
