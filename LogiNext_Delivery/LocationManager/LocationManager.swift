//
//  LocationManager.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 25/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import CoreLocation
import UIKit

class LocationManager: NSObject {
    private var locationManager: CLLocationManager?
    var startLocation: CLLocation?
    var currentLocation: CLLocation?
    var timer: Timer?
    let trackingInterval: TimeInterval = 2
    var isStartLocationSet = false
    var newLocationClosure: (() -> Void)?
    var goToSettingsClosure: (() -> Void)?
    var viewModel: LocationTrackerViewModel?
    
    private static var instance: LocationManager = {
        let inst = LocationManager()
        return inst
    }()
    
    class func shared() -> LocationManager {
        return instance
    }
    
    private override init() {
        super.init()
        self.initializeLocation()
    }
    
    func initializeLocation() {
        if self.locationManager == nil {
            locationManager = CLLocationManager()
        }
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestLocation()
    }
    
    @objc func startMonitoringLocation() {
        if let tmr = self.timer {
            tmr.invalidate()
        }
        self.timer = nil
        print("Location---> startedUpdatingLocation")
        self.locationManager?.startUpdatingLocation()
        self.timer = Timer.scheduledTimer(timeInterval: trackingInterval, target: self, selector: #selector(stopMonitoringLocation), userInfo: nil, repeats: false)
    }
    
    @objc func stopMonitoringLocation () {
        self.locationManager?.stopUpdatingLocation()
        if let tmr = self.timer {
            tmr.invalidate()
        }
        print("Location---> stoppedUpdatingLocation")
        if self.locationManager != nil {
            self.timer = Timer.scheduledTimer(timeInterval: trackingInterval, target: self, selector: #selector(startMonitoringLocation), userInfo: nil, repeats: false)
        }
    }
    
    func checkLocationManager() {
        if self.locationManager == nil {
            self.initializeLocation()
        }
    }
    
    func forceStopMonitoringLocation() {
        self.locationManager?.stopUpdatingLocation()
        self.isStartLocationSet = false
        self.locationManager = nil
        self.currentLocation = nil
        self.startLocation = nil
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            self.currentLocation = nil
            self.goToSettingsClosure?()
        case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
            locationManager?.requestLocation()
            self.startMonitoringLocation()
        @unknown default:
            print("Unknown status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last{
            print("==>(\(newLocation.coordinate.latitude), \(newLocation.coordinate.latitude))")
        }
        for location in locations {
            let coordinate  = location.coordinate
            let accurecy    = location.horizontalAccuracy
            print(accurecy)
            if accurecy > 0 && accurecy < 100 {
                if let current = self.currentLocation {
                    if coordinate.latitude == current.coordinate.latitude && coordinate.longitude == current.coordinate.longitude {
                        //User is at same place
                        print("Location---> User is at same place")
                        self.stopMonitoringLocation()
                        return
                    }
                }
                print("Location---> New User location \(currentLocation?.coordinate.longitude)  \(currentLocation?.coordinate.longitude)")
                self.currentLocation = location
                if !isStartLocationSet {
                    self.startLocation = location
                    
                    // MARK: - Set old start location from DB
                    self.viewModel?.getActualStartLocationFromDB(completion: { (oldStartLoc) in
                        if let old = oldStartLoc, let stlt = old.startLatitude, let stlg = old.startLongitude {
                            self.startLocation = CLLocation(latitude: stlt, longitude: stlg)
                        } else {
                            self.createStartLocationEntryIntoDB(coordinate: location.coordinate)
                        }
                    })
                    
                    self.isStartLocationSet = true
                    
                }
                self.newLocationClosure?()
            }
        }
    }
    
    func createStartLocationEntryIntoDB(coordinate: CLLocationCoordinate2D) {
        guard let user = viewModel?.logisiticsViewModel.currentUser else {return}
        viewModel?.createUserLocationEntryIntoDB(userId: user.userId, name: user.firstName, latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Location---> didEnterRegion \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Location---> didExitRegion \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
