//
//  LocationGoogleMapViewController.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 26/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationGoogleMapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    var locationManager: LocationManager? = LocationManager.shared()
    var locationMarker: GMSMarker!
    @IBOutlet weak var closeIcon: UIImageView!
    var viewModel: LocationTrackerViewModel?
    var camera: GMSCameraPosition?
    var isCameraSet: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        closeIcon.addTapGesture(onClick: closeClicked)
        setPosition()
    }
    
    func setPosition() {
        locationManager?.checkLocationManager()
        locationManager?.viewModel = self.viewModel
        locationManager?.newLocationClosure = {[weak self] in
            guard let slf = self else {return}
            slf.setPlaceMarks()
        }
        locationManager?.goToSettingsClosure = {[weak self] in
            guard let slf = self else {return}
            slf.showGoToSettingsAlert()
        }
    }
    
    func setPlaceMarks() {
        if let start = locationManager?.startLocation {
            var zoomLevel: Float = 16.0
            if isCameraSet {
                print("==> camera!.zoom \(camera!.zoom)")
                zoomLevel = mapView.camera.zoom
            }
            camera = GMSCameraPosition.camera(withLatitude: start.coordinate.latitude, longitude: start.coordinate.longitude, zoom: zoomLevel)
            isCameraSet = true
            let sourceCoordinate = start.coordinate
            if let current = locationManager?.currentLocation {
                
                if let cam = camera {
                    mapView.camera = cam
                    mapView.mapType = .normal
                    locationMarker = GMSMarker(position: current.coordinate)
                    locationMarker.title = "Currently you are here.."
                    locationMarker.appearAnimation = .pop
                    locationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
                    locationMarker.opacity = 0.75
                    locationMarker.isFlat = true
                    locationMarker.map = mapView
                }
            
            
                let destinationLocation = current.coordinate
                fetchRoute(from: sourceCoordinate, to: destinationLocation)
            }
        }
    }
        
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {

        let session = URLSession.shared
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=\(Helper.googleApiKey)")!
        print("==>Direction URL \(url.absoluteString)")
        let task = session.dataTask(with: url, completionHandler: {[weak self]
            (data, response, error) in

            guard error == nil else {
                print(error!.localizedDescription)
                return
            }

            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                print("error in JSONSerialization")
                return
            }
            

            guard let routes = jsonResult["routes"] as? [Any], routes.count > 0 else {
                return
            }

            guard let route = routes[0] as? [String: Any] else {
                return
            }

            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                return
            }

            guard let polyLineString = overview_polyline["points"] as? String else {
                return
            }
            DispatchQueue.main.async {
                guard let slf = self else {return}
                slf.drawPath(from: polyLineString)
            }
            
        })
        task.resume()
    }
    
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView
        polyline.strokeColor = .red
    }
    
    func closeClicked() {
        self.dismiss(animated: true, completion: nil)
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
            self.closeClicked()
        })
        alertView.addAction(cancelAction)
        self.present(alertView, animated: true, completion: nil)
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
