//
//  ViewController.swift
//  FirebaseAuthentication
//
//  Created by Anna Dubnoff (student LM) on 1/27/20.
//  Copyright © 2020 Anna Dubnoff (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = Auth.auth().currentUser{
            self.performSegue(withIdentifier: "toHomeScreen", sender: self)
        }
    }


}

