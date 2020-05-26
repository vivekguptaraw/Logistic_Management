//
//  LocationMapKitViewController.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 25/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit
import MapKit

class LocationMapKitViewController: UIViewController {
    @IBOutlet weak var closeIcon: UIImageView!
    
    @IBOutlet weak var mapKitView: MKMapView!
    
    var locationManager: LocationManager? = LocationManager.shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeIcon.addTapGesture(onClick: closeClicked)
        mapKitView.delegate = self
        mapKitView.mapType = .standard
        mapKitView.isZoomEnabled = true
        mapKitView.isScrollEnabled = true
        mapKitView.showsUserLocation = true
        locationManager?.checkLocationManager()
        locationManager?.startLocationClosure = {
            self.setPlaceMarks()
        }
        
    }
    
    func setPlaceMarks() {
        if let start = locationManager?.startLocation {
            let sourceLocation = start.coordinate
            if let current = locationManager?.currentLocation {
                let destinationLocation = current.coordinate
                
                //Set Zoom to current location
                 let zoomRegion = MKCoordinateRegion(center: destinationLocation, latitudinalMeters: 10, longitudinalMeters: 10)
                    mapKitView.setRegion(zoomRegion, animated: true)
                
                let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
                let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
                
                let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
                let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                
                let sourceAnnotation = MKPointAnnotation()
                sourceAnnotation.title = "You started here.."
                
                if let location = sourcePlacemark.location {
                    sourceAnnotation.coordinate = location.coordinate
                }
                
                let destinationAnnotation = MKPointAnnotation()
                destinationAnnotation.title = "Currently you are here :)"
                
                if let location = destinationPlacemark.location {
                    destinationAnnotation.coordinate = location.coordinate
                }
                
                self.mapKitView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
                
                let directionRequest = MKDirections.Request()
                directionRequest.source = sourceMapItem
                directionRequest.destination = destinationMapItem
                directionRequest.transportType = .automobile
                
                let directions = MKDirections(request: directionRequest)
                
                
                directions.calculate {
                    (response, error) -> Void in
                    
                    guard let response = response else {
                        if let error = error {
                            print("Error: \(error)")
                        }
                        
                        return
                    }
                    
                    let route = response.routes[0]
                    self.mapKitView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                    
                    let rect = route.polyline.boundingMapRect
                    self.mapKitView.setRegion(MKCoordinateRegion(rect), animated: true)
                }
            }
            
        }
        
    }
    
    func closeClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager?.forceStopMonitoringLocation()
        locationManager = nil
    }
    
    deinit {
        locationManager?.forceStopMonitoringLocation()
    }
}

extension LocationMapKitViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
    
        return renderer
    }
}
