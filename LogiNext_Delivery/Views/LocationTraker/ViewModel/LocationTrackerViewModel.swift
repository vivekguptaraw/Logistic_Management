//
//  LocationTrackerViewModel.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 26/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

class LocationTrackerViewModel {
    
    let logisiticsViewModel: LogisticViewModel
    
    init(logistics: LogisticViewModel) {
        self.logisiticsViewModel = logistics
    }
    
    func createUserLocationEntryIntoDB(userId: Int, name: String, latitude: Double, longitude: Double) {
        var userLocDTO = UserLocationDTO(name: name, id: userId)
        userLocDTO.setStartCoordinates(stlt: latitude, stlg: longitude)
        self.logisiticsViewModel.createUserLocation(userLocDTO: userLocDTO) { (loc) in
            print(loc)
        }
    }
    
    func getActualStartLocationFromDB(completion: @escaping ((UserLocationDTO?) -> Void)) {
        guard let uid = logisiticsViewModel.currentUser?.userId else {return}
        self.logisiticsViewModel.manager.getActualStartLocationFromDB(userId: uid) { (userLoc) in
            completion(userLoc)
        }
    }
    
    func saveUserUpdatedLocationIntoDB() {
        
    }
    
    func userSpentThisAmountOfTimeInThisLocation() {
        
    }
}
