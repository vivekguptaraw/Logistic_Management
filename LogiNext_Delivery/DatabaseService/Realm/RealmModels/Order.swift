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
    @objc dynamic var orderId: Int32 = 0
    @objc dynamic var name: String = ""
    @objc dynamic var orderDescription: String?
    
    @objc dynamic var createdDate: Date?
    @objc dynamic var pickedUpDate: Date?
    @objc dynamic var expectedDeliveryDate: Date?
    @objc dynamic var deliveredDate: Date?
    @objc dynamic var cancellededDate: Date?
    
    @objc dynamic var isQueued: Bool = false
    @objc dynamic var isInTransit: Bool = false
    @objc dynamic var isDelivered: Bool = false
    @objc dynamic var isCancelled: Bool = false
    
    @objc dynamic var createdByUser: User?
    @objc dynamic var pickedUpByUser: User?
    @objc dynamic var deliveredByUser: User?
    @objc dynamic var cancelledByUser: User?
    
    let ofUser = LinkingObjects(fromType: User.self, property: "assignedOrders")
    
    
    @objc dynamic var currentLocation: String = ""
    
    override static func primaryKey() -> String? {
        return "orderId"
    }
    
    convenience init(_ orderId: Int32, _ name: String, createdDate: Date) {
        self.init()
        self.orderId = orderId
        self.name = name
        self.createdDate = createdDate
    }
    
}
