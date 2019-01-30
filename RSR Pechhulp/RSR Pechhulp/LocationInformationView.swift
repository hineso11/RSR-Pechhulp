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
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        commonInit()
    }

    func commonInit () {
        
        Bundle.main.loadNibNamed("LocationInformationView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        //frame = CGRect(x: 0, y: 0, width: 240, height: 280)
        frame.origin.x -= (frame.width) / 2.0
        frame.origin.y -= (frame.height)
    }
    
    func updateLocationInformation (location: CLLocation) {
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {
            (placemarks, error) in
            
            if error == nil {
                
                let placemark = placemarks?.first
                self.updateInformationLabel(streetNumber: (placemark?.subThoroughfare)!, street: (placemark?.thoroughfare)!, city: (placemark?.locality)!, postcode: (placemark?.postalCode)!)
            }
        })
    }
    
    private func updateInformationLabel (streetNumber: String, street: String, city: String, postcode: String) {
        
        let addressString = streetNumber + " " + street + ",\n" + city + ",\n" + postcode
        informationTextView.text = addressString
    }
}
