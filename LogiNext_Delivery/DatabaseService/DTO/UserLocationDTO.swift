//
//  UserLocationDTO.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 26/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

struct UserLocationDTO {
    var userId: Int = 0
    var name: String?
    var startLongitude: Double?
    var startLatitude: Double?
    var lastLongitude: Double?
    var lastLatitude: Double?
    var lastUpdatedLocationTimeStamp: Date?
    
    init(name: String?, id: Int) {
        self.name = name
        self.userId = id
    }
    
    mutating func setStartCoordinates(stlt: Double, stlg: Double) {
        self.startLatitude = stlt
        self.startLongitude = stlg
        self.lastUpdatedLocationTimeStamp = Date()
    }
}

extension UserLocationDTO: MappableProtocol {
    typealias PersistenceType = UserLocation
    
    func mapToPersistenceObject() -> UserLocation {
        let model = UserLocation()
        model.userId = self.userId
        model.name = self.name
        model.startLongitude.value = self.startLongitude
        model.startLatitude.value = self.startLatitude
        model.lastLongitude.value = self.lastLongitude
        model.lastLatitude.value = self.lastLatitude
        model.lastUpdatedLocationTimeStamp = self.lastUpdatedLocationTimeStamp
        return model
    }
    
    static func mapFromPersistenceObject(_ object: UserLocation) -> UserLocationDTO {
        var model = UserLocationDTO(name: object.name, id: object.userId)
        model.startLongitude = object.startLongitude.value
        model.startLatitude = object.startLatitude.value
        model.lastLongitude = object.lastLongitude.value
        model.lastLatitude = object.lastLatitude.value
        model.lastUpdatedLocationTimeStamp = object.lastUpdatedLocationTimeStamp
        return model
    }
}
