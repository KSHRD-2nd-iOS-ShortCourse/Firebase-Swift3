//
//  SignUpViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 11/1/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpTableViewController: UITableViewController {

    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var emailVerifySwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func signUp(_ sender: UIButton) {
        // Call firebase create user
        FIRAuth.auth()?.createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            // Create account error
            if error != nil {
                print("My Error ####\(error?.localizedDescription)")
            }else{
                if self.emailVerifySwitch.isOn {
                    print("---> Verification turn on")
                    user?.sendEmailVerification(completion: { (error) in
                        if error != nil {
                            print("My Error ####\(error?.localizedDescription)")
                        }else{
                            // Email sent
                            print("Email sent to \(user!.email!)")
                        }
                    })
                }else{
                    print("---> Verification turn off")
                    // Email sent
                    print("No email sent to \(user!.email!)")
                }
                
                try! FIRAuth.auth()?.signOut()
            }
        }
    }
}





