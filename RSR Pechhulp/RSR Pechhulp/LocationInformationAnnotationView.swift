//
//  LocationInformationAnnotationView.swift
//  RSR Pechhulp
//
//  Created by Oliver Hines on 28/01/2019.
//  Copyright © 2019 Oliver Hines Apps. All rights reserved.
//

import UIKit
import MapKit

class LocationInformationAnnotationView: MKAnnotationView {

    // MARK: Variables and Constants
    var customCalloutView: LocationInformationView?
    
    // MARK: Initialisers
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit () {
        // Set up the custom information view
        customCalloutView = LocationInformationView(frame: CGRect(x: 0, y: 0, width: 240, height: 280))
        // Adjust the position of the view such that it is above the pin
        customCalloutView?.frame.origin.x -= (customCalloutView?.frame.width)! / 2.0 - (self.frame.width / 2.0)
        customCalloutView?.frame.origin.y -= (customCalloutView?.frame.height)! * 0.7
        self.addSubview(customCalloutView!)
    }
    
    

}
