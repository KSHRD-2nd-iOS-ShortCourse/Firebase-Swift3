//
//  SettingTableViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 11/7/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class SettingTableViewController: UITableViewController {
    
    
    // Outlet
    @IBOutlet var websiteTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var genderTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    
    // TODO: Step 1 Create reference and outlet
    // Create Firebase database and auth object
    var databaseRef = FIRDatabase.database().reference(fromURL: "https://fir-demo-9d15e.firebaseio.com/")
    var user = FIRAuth.auth()?.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Step 3 Load data from firebase realtime storage to control
        databaseRef.child("user_profile/\(user!.uid)").observe(.value, with: { (snapshot) in
            
            // TODO: Step 4 Convert snapshot to Dictionary
            let value = snapshot.value as! [String: AnyObject]
            
            // Set value to textfield
            self.nameTextField.text = value["name"] as! String?
            self.ageTextField.text = value["age"] as! String?
            self.genderTextField.text = value["gender"] as! String?
            self.emailTextField.text = value["email"] as! String?
            self.websiteTextField.text = value["website"] as! String?
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    // TODO: Step 2 Update User Profile
    @IBAction func updateInfo(_ sender: Any) {
        let user = FIRAuth.auth()?.currentUser
        
        // Set value to firebase database
        let userProfile = self.databaseRef.child("user_profile/\(user!.uid)")
        
        
        userProfile.child("name").setValue(nameTextField.text)
        userProfile.child("gender").setValue(genderTextField.text)
        userProfile.child("age").setValue(ageTextField.text)
        userProfile.child("email").setValue(emailTextField.text)
        userProfile.child("website").setValue(websiteTextField.text)
        
    }
    
}








