//
//  LoginViewController.swift
//  FirebaseAuthentication
//
//  Created by Anna Dubnoff (student LM) on 1/29/20.
//  Copyright © 2020 Anna Dubnoff (student LM). All rights reserved.
//
import FirebaseAuth
import UIKit


class LogInViewController: UIViewController {
    

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginOutlet: UIButton!
    @IBAction func loginAction(_ sender: UIButton) {
        guard let email = emailAddress.text else {return}
        guard let password = password.text else {return}

        Auth.auth().signIn(withEmail: email, password: password){ user, error in
            if error == nil && user != nil{
                self.dismiss(animated: false, completion: nil)
            }
            else{
                print(error!.localizedDescription)
            }
        }
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if emailAddress.isFirstResponder {
            password.becomeFirstResponder()
        }
        else{
            password.resignFirstResponder()
            loginOutlet.isEnabled = true
        }
        return true
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailAddress.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

}
