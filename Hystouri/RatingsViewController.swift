//
//  ViewController.swift
//  CosmosRatingTutorial
//
//  Created by Nitya Jaisinghani (student LM) on 2/24/20.
//  Copyright © 2020 Nitya Jaisinghani (student LM). All rights reserved.
//

import UIKit
import Cosmos
import TinyConstraints


class ViewController: UIViewController {

    
    @IBOutlet weak var starOne: UIImageView!
    
    @IBOutlet weak var starTwo: UIImageView!
    
    @IBOutlet weak var starThree: UIImageView!
    
    @IBOutlet weak var starFour: UIImageView!
    
    @IBOutlet weak var starFive: UIImageView!
    
    
    
    lazy var cosmosView: CosmosView = {
        var view = CosmosView()
        
//(doesn't allow user to change star ratings)
//view.settings.updateOnTouch = false
//        view.settings.filledImage = UIImage(named: "starFilled")?.withRenderingMode(.alwaysOriginal)
//        view.settings.emptyImage = UIImage(named: "starEmpty")?.withRenderingMode(.alwaysOriginal)
//
        
        
        view.settings.totalStars = 5
        view.settings.starSize = 40 //17 was old one
        view.settings.starMargin = 3.3
        view.settings.fillMode = .full
        
        view.text = "RATING"
    
        view.settings.textColor = .black
        view.settings.textMargin = 40  //10 was old
        
  
        
        return view
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        view.addSubview(cosmosView)
        cosmosView.centerInSuperview()
        
        cosmosView.didTouchCosmos = { rating in
            print("Rated: \(rating)")
        }

    }


}

