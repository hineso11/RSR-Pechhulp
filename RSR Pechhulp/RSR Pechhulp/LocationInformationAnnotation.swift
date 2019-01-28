//
//  LocationInformationAnnotationView.swift
//  RSR Pechhulp
//
//  Created by Oliver Hines on 27/01/2019.
//  Copyright © 2019 Oliver Hines Apps. All rights reserved.
//

import UIKit
import MapKit

class LocationInformationAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    

    // MARK: Variables and Constants
    var subtitle: String? {
        return "Some random location"
    }
    var title: String? {
        
        return "Your Location:"
    }

    init(coordinate: CLLocationCoordinate2D) {
        
        self.coordinate = coordinate
        
        super.init()
    }
}
