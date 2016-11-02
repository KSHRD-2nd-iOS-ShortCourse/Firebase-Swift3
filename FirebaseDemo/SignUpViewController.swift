//
//  SignUpViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 11/1/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func signUp(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            // Create account error
            if error != nil {
                print("My Error ####\(error?.localizedDescription)")
            }else{
                if let user = FIRAuth.auth()?.currentUser {
                    // User is signed in.
                    print("Sign In User: \(user.email)")
                } else {
                    // No user is signed in.
                }
                
                try! FIRAuth.auth()?.signOut()
            }
        }
        
        
        
        
        
    }
    
    @IBAction func signUpWithVerification(_ sender: Any) {
        
        FIRAuth.auth()?.createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            // Create account error
            if error != nil {
                print("My Error ####\(error?.localizedDescription)")
            }else{
                user?.sendEmailVerification() { error in
                    if let error = error {
                        // An error happened.
                        print(error.localizedDescription)
                    } else {
                        // Email sent.
                        print("Email sent to \(user?.email)")
                    }
                }
                
                try! FIRAuth.auth()?.signOut()

            }
        }
        
        
        
        
    }
  
}





