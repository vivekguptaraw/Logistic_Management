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
    private let locationManager = CLLocationManager()
    var startLocation: CLLocation?
    var currentLocation: CLLocation?
    var timer: Timer?
    let trackingInterval: TimeInterval = 2
    var isStartLocationSet = false
    var startLocationClosure: (() -> Void)?
    
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
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
    
    @objc func startMonitoringLocation() {
        if let tmr = self.timer {
            tmr.invalidate()
        }
        self.timer = nil
        print("Location---> startedUpdatingLocation")
        self.locationManager.startUpdatingLocation()
        self.timer = Timer.scheduledTimer(timeInterval: trackingInterval, target: self, selector: #selector(stopMonitoringLocation), userInfo: nil, repeats: false)
    }
    
    @objc func stopMonitoringLocation () {
        self.locationManager.stopUpdatingLocation()
        if let tmr = self.timer {
            tmr.invalidate()
        }
        print("Location---> stoppedUpdatingLocation")
        self.timer = Timer.scheduledTimer(timeInterval: trackingInterval, target: self, selector: #selector(startMonitoringLocation), userInfo: nil, repeats: false)
        
    }
    
    func forceStopMonitoringLocation() {
        self.locationManager.stopUpdatingLocation()
    }
}


extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            self.currentLocation = nil
            self.showGoToSettingsAlert()
        case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
            locationManager.requestLocation()
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
                    isStartLocationSet = true
                }
                self.startLocationClosure?()
            }
        }
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
    
    func showGoToSettingsAlert() {
        let alertView =  UIAlertController(title: "Could not find your location.", message: "Please go to iOS Settings > Privacy > Location to allow access to your location.", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Settings" , style: UIAlertAction.Style.default, handler: { (_) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: { (success) in
                })
            }
        })
        alertView.addAction(action)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (_) in
        })
        alertView.addAction(cancelAction)
        AppDelegate.shared.window?.rootViewController?.present(alertView, animated: true, completion: nil)
    }
}
