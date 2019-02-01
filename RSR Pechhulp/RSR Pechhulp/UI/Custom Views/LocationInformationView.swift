//
//  LocationInformationView.swift
//  RSR Pechhulp
//
//  Created by Oliver Hines on 27/01/2019.
//  Copyright © 2019 Oliver Hines Apps. All rights reserved.
//

import UIKit
import MapKit

class LocationInformationView: UIView {

    // MARK: Outlets
    @IBOutlet var contentView: LocationInformationView!
    @IBOutlet weak var informationTextView: UITextView!
    
    // MARK: Variables and Constants
    let geocoder = CLGeocoder()
    
    // MARK: Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCustomView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        setupCustomView()
    }

    // MARK: Custom functions
    
    // Function to setup the view from the nib file and reposition accordingly
    func setupCustomView () {
        
        // Load view from nib
        Bundle.main.loadNibNamed("LocationInformationView", owner: self, options: nil)
        addSubview(contentView)
        
        // Adjust frame and resizing
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // Adjust position of view so it is above current location
        frame.origin.x -= (frame.width) / 2.0
        frame.origin.y -= (frame.height)
    }
    
    // Function to update the information displayed based on a new location
    func updateLocationInformation (location: CLLocation) {
        
        // Perform reverse lookup on location to obtain information
        geocoder.reverseGeocodeLocation(location, completionHandler: {
            (placemarks, error) in
            
            if error == nil {
                // Extract information from first placemark and pass to function
                let placemark = placemarks?.first
                self.updateInformationLabel(streetNumber: (placemark?.subThoroughfare)!, street: (placemark?.thoroughfare)!, city: (placemark?.locality)!, postcode: (placemark?.postalCode)!)
            }
        })
    }
    
    // Function to update the UI with new location
    private func updateInformationLabel (streetNumber: String, street: String, city: String, postcode: String) {
        
        let addressString = streetNumber + " " + street + ",\n" + city + ",\n" + postcode
        informationTextView.text = addressString
    }
}
