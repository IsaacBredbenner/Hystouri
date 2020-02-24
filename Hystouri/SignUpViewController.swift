//
//  SignUpViewController.swift
//  FirebaseAuthentication
//
//  Created by Anna Dubnoff (student LM) on 1/29/20.
//  Copyright © 2020 Anna Dubnoff (student LM). All rights reserved.
//
import FirebaseAuth
import UIKit

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpOutlet: UIButton!
    
    @IBAction func signUpAction(_ sender: UIButton) {

        guard let userName = userName.text else {return}
        guard let email = emailAddress.text else {return}
        guard let password = password.text else {return}

        Auth.auth().createUser(withEmail: email, password: password){ user, error in
            if let _ = user {
                print("user created")
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = userName
                changeRequest?.commitChanges(completion: { (error) in
                    print("couldn't change name")
                    })
                }
                else{
                    print(error.debugDescription)
                }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if userName.isFirstResponder {
            emailAddress.becomeFirstResponder()
        }
        else if emailAddress.isFirstResponder{
            password.becomeFirstResponder()
        }
        else{
            password.resignFirstResponder()
            signUpOutlet.isEnabled = true
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    

}

