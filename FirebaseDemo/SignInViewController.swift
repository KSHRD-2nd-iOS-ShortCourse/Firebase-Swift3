//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 11/1/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBAction func backToSignIn(segue: UIStoryboardSegue) {
        print("backToSignIn")
    }
    
    
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                print("Sign In User: \(user.email)")
                self.performSegue(withIdentifier: "showDetail", sender: nil)
            } else {
                // No user is signed in.
                print("No user is signed in.")
            }
        }
  
    }

    @IBAction func signIn(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: usernameTextField.text! , password: passwordTextField.text!) { (user, error) in
            // ...
            
            if error != nil {
                print("My Error ####\(error?.localizedDescription)")
            }else{
                
                if (user?.isEmailVerified)! == false {
                    print("Sorry your email has not yet been verified.")
                }else{
                    // User is signed in.
                    print("Sign In User: \(user?.email)")
                    self.performSegue(withIdentifier: "showDetail", sender: nil)
                }
            }
        }
    }
 
    @IBAction func forgetPassword(_ sender: Any) {
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: usernameTextField.text!) { error in
            if let error = error {
                // An error happened.
            } else {
                print("Password reset email sent.")
                // Password reset email sent.
            }
        }
        
    }
}





