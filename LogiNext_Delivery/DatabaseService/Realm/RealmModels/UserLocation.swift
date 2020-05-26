//
//  UserLocation.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 26/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation
import RealmSwift

class UserLocation: Object {
    @objc dynamic var userId: Int = 0
    @objc dynamic var name: String?
    let startLongitude = RealmOptional<Double>()
    let startLatitude = RealmOptional<Double>()
    
    let lastLongitude = RealmOptional<Double>()
    let lastLatitude = RealmOptional<Double>()
    
    @objc dynamic var lastUpdatedLocationTimeStamp: Date?
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
    convenience init(_ userId: Int, _ name: String) {
        self.init()
        self.userId = userId
        self.name = name
    }
}
