//
//  LocationInformationView.swift
//  RSR Pechhulp
//
//  Created by Oliver Hines on 27/01/2019.
//  Copyright © 2019 Oliver Hines Apps. All rights reserved.
//

import UIKit

class LocationInformationView: UIView {

    @IBOutlet var contentView: LocationInformationView!
    
    
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
        
    }
}
