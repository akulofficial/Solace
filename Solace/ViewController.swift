//
//  ViewController.swift
//  Solace
//
//  Created by Akul Gulrajani on 7/29/18.
//  Copyright © 2018 Akul Gulrajani. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        enableBasicLocationServices()
        centerOnUser(location: locationManager.location!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var Map: MKMapView!
    var locationManager: CLLocationManager!
    var lastLocation: CLLocation!
    
    func enableBasicLocationServices() {
        locationManager.delegate = self
        Map.showsUserLocation = true
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            // Disable location features
            disableMyLocationBasedFeatures()
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Enable location features
            enableMyWhenInUseFeatures()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            disableMyLocationBasedFeatures()
            break
            
        case .authorizedWhenInUse:
            enableMyWhenInUseFeatures()
            break
            
        case .notDetermined, .authorizedAlways:
            break
        }
    }
    
    func enableMyWhenInUseFeatures() {
        //nothing yet
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100.0  // In meters.
        locationManager.startUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = true
    }

    func disableMyLocationBasedFeatures() {
        locationManager.stopUpdatingLocation()
        Map.backgroundColor = UIColor.gray
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last!
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            locationManager.stopUpdatingLocation()
            return
        }
        // Notify the user of any errors.
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to initialize GPS: ", error.description)
    }
    
    @IBAction func centerOnUserLocationButton(_ sender: Any) {
        centerOnUser(location: lastLocation)
    }
    
    func centerOnUser(location: CLLocation) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.Map.setRegion(region, animated: true)
    }
}

