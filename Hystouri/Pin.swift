//
//  Pin.swift
//  Hystouri
//
//  Created by Isaac Bredbenner (student LM) on 4/3/20.
//  Copyright © 2020 Isaac Bredbenner (student LM). All rights reserved.
//

import Foundation
import MapKit

class Pin : NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String = "School", subtitle: String = "This is a subtitle"){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
