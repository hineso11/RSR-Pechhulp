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
    
    // MARK: Actions
    @IBAction func calloutButtonPressed(_ sender: Any) {
        // Show alert to tell user to remember their location for the call
        let alert = UIAlertController(title: "Attention", message: "Remember your location for the call", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            // If the user clicks OK instead of cancel then start call to customer service
            let url:NSURL = NSURL(string: "telprompt://+319007788990")!
            UIApplication.shared.openURL(url as URL)
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Variables and Constants
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var locationInformationView: LocationInformationView?
    
    // MARK: ViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate for the map to this class
        mapView.delegate = self
        // Set delegate for location manager to this class
        locationManager.delegate = self

        // Get the current auth status for location retrieval
        let status = CLLocationManager.authorizationStatus()
        // Take action based on the auth state for location
        handleAuthorisationStatus(status: status)
    }
    
    // MARK: Location functions
    
    // Function handles changes in location auth
    func handleAuthorisationStatus (status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedWhenInUse:
            // GPS permission has already been authorised, so start requesting location information
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
    
    // Function to show alert for error message and return to previous VC
    func showError (title: String, message: String) {
        
        // Send alert to inform user of error
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        handleAuthorisationStatus(status: status)
    }
    
    // Function handles errors in getting location
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
    
    // Function to handle an update in the user's location
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
        
        // If the custom location information view has been set up
        if (locationInformationView != nil) {
            // Update the location information
            updateLocationInformation()
        }
    }
    
    // MARK: MapKit functions

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            
            // Find the user location pin
            let userLocationPin = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            // Add the custom view to show location information on
            locationInformationView = LocationInformationView(frame: CGRect(x: 0, y: 0, width: 240, height: 200))
            userLocationPin.addSubview(locationInformationView!)
            // Update the information displayed to the user
            updateLocationInformation()
            
            return userLocationPin
        }
        return nil
    }
    
    func updateLocationInformation () {
        // Use current location to display information to user about their location
        locationInformationView?.updateLocationInformation(location: currentLocation!)
    }
}
