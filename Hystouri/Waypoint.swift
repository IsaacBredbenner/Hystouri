//
//  Waypoint.swift
//  Hystouri
//
//  Created by Isaac Bredbenner (student LM) on 4/3/20.
//  Copyright © 2020 Isaac Bredbenner (student LM). All rights reserved.
//

import Foundation
import MapKit

// basically a pin but w/ more information
class Waypoint : NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var name : String?
    var comment : String?
    var desc : String?
    var link : String?
    
    init(coordinate: CLLocationCoordinate2D, name: String = " ", comment: String = " ", desc: String = " ", link: String = " "){
        self.coordinate = coordinate
        self.name = name
        self.comment = comment
        self.desc = desc
        self.link = link
    }
    
}
