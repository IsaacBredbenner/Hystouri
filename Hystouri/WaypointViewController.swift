//
//  WaypointViewController.swift
//  Hystouri
//
//  Created by Isaac Bredbenner (student LM) on 4/3/20.
//  Copyright © 2020 Isaac Bredbenner (student LM). All rights reserved.
//

import UIKit

class WaypointViewController: UIViewController {
    var waypoint : Waypoint?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    
     // need to find a way to deal w/ how some of the Waypoints have too much information, probably add a scrollable text field later
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let wpt = waypoint{
            self.waypoint = wpt
            
            if let name = waypoint?.name{
                nameLabel.numberOfLines = 0
                nameLabel.text = name
                nameLabel.sizeToFit()
                nameLabel.textAlignment = .center
            }
            else{
                print("Could not find a valid name for the Waypoint")
            }
            
            if let comment = waypoint?.comment{
                commentLabel.numberOfLines = 0
                commentLabel.text = "   \(comment)"
                commentLabel.sizeToFit()
            }
            else{
                print("Could not find a valid comment for the Waypoint")
            }
            
            if let description = waypoint?.desc{
                descriptionLabel.numberOfLines = 0
                descriptionLabel.text = "   \(description)"
                descriptionLabel.sizeToFit()
            }
            else{
                print("Could not find a valid name for the Waypoint")
            }
            
            if let link = waypoint?.link{
                linkLabel.numberOfLines = 0
                linkLabel.text = link
                linkLabel.sizeToFit()
            }
            else{
                print("Could not find a valid link for the Waypoint")
            }
        }
    }

}
