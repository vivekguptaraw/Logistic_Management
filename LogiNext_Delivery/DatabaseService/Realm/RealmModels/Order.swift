//
//  Order.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation
import RealmSwift

class Order: Object {
    @objc dynamic var orderId: Int = 0
    @objc dynamic var name: String = ""
    
    @objc dynamic var createdDate: Date = Date()
    @objc dynamic var expectedDeliveryDate: Date = Date()
    @objc dynamic var deliveredDate: Date = Date()
    @objc dynamic var cancellededDate: Date = Date()
    
    @objc dynamic var isQueued: Bool = false
    @objc dynamic var isInTransit: Bool = false
    @objc dynamic var isDelivered: Bool = false
    @objc dynamic var isCancelled: Bool = false
    
    @objc dynamic var createdByUser: User?
    @objc dynamic var pickedUpByUser: User?
    @objc dynamic var deliveredByUser: User?
    @objc dynamic var cancelledByUser: User?
    
    //let ofUser = LinkingObjects(fromType: User.self, property: "Order")
    
    
    @objc dynamic var currentLocation: String = ""
    
    override static func primaryKey() -> String? {
        return "orderId"
    }
    
    convenience init(_ orderId: Int, _ name: String, createdDate: Date) {
        self.init()
        self.orderId = orderId
        self.name = name
        self.createdDate = createdDate
    }
    
}
