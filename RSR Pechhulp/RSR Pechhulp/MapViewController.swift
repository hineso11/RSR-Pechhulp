//
//  MapViewController.swift
//  RSR Pechhulp
//
//  Created by Oliver Hines on 20/01/2019.
//  Copyright © 2019 Oliver Hines Apps. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Variables and Constants
    let locationManager = CLLocationManager()
    var userLocationAnnotation: MKAnnotation?
    var locationInformationAnnotation: LocationInformationAnnotation?
    var currentLocation: CLLocation?
    
    // MARK: ViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate for the map to this class
        mapView.delegate = self

        // Check that finding the user's location is possible
        let locationStatus = CLLocationManager.authorizationStatus()
        
        switch locationStatus {
        case .authorizedWhenInUse:
            // GPS permission has already been authorised, so start requesting location information
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            
        case .denied, .restricted:
            // GPS permission denied or restricted, so ask user to change setting
            
            showError(title: "Location Services Disabled", message: "Please enable location services in settings")
            
        case .notDetermined:
            // User hasn't been asked for GPS permission yet, so ask for it
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func showError (title: String, message: String) {
        
        // Send alert to inform user
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (alert: UIAlertAction!) in
            
            // When user clicks ok action, send them back to the menu view controller
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    // MARK: CL Functions
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        let title: String
        let message: String
        
        if let clError = error as? CLError {
            
            switch clError {
            case CLError.denied:
                title = "Location Services Disabled"
                message = "Please enable location services in settings"
            default:
                title = "Could Not Find Current Location"
                message = "There was a problem, please check the connectivity of your device"
            }
            
            showError(title: title, message: message)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // If this is first time user location has been found, then zoom to it
        if (currentLocation == nil) {
            // Get the current location of the user
            currentLocation = locations.last!
            // Create, set view region based on the user's current location
            let viewRegion = MKCoordinateRegion(center: currentLocation!.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: true)
            // Show user location pin on the map
            mapView.showsUserLocation = true
        } else {
            currentLocation = locations.last!
        }
        
        // If the location information annotation is set up, then update its location
        if (locationInformationAnnotation != nil) {
            
            locationInformationAnnotation?.coordinate = (userLocationAnnotation?.coordinate)!
        }
    }
    
    // MARK: MapKit functions
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            
            // If this is the first time function has been called, save user location annotation
            if userLocationAnnotation == nil {
                userLocationAnnotation = annotation
                
                // Set up information annotation for user's location
                locationInformationAnnotation = LocationInformationAnnotation(coordinate: annotation.coordinate)
                mapView.addAnnotation(locationInformationAnnotation!)
                
            }
            
            // Find the user location pin
            let userLocationPin = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            // Set custom image for pin
            userLocationPin.image = UIImage(named: "MapMarker")
            
            return userLocationPin
        } else {
            // Create the location information annotation view
            let locationInforamtionPin = LocationInformationAnnotationView(annotation: annotation, reuseIdentifier: nil)
            // Save the annotation object
            locationInformationAnnotation = annotation as! LocationInformationAnnotation
            
            return locationInforamtionPin
        }
    }
    
    
}
