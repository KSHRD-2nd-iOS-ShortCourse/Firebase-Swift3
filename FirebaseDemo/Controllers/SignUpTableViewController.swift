//
//  SignUpViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 11/1/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import Firebase

class SignUpTableViewController: UITableViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var emailVerifySwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // TODO: Step 1 - Firebase Sign Up Action
    @IBAction func signUp(_ sender: UIButton) {
        // TODO: Step 2 Call firebase create user
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
                
                // TODO: Step 5
                /* #### This code is user after create register user screen  #### */
                
                // When the user logs in for the frist time, we'll store the users name and the users email on their profile page.
                // also store the small version of the profile picture in the database and in the storage
                
                if error == nil {
                    let storage = FIRStorage.storage()
                    
                    // TODO: Step 6 Create Firebase Storage, Realtime Database, UserID
                    // create firebase storage reference
                    let storageRef = storage.reference()
                    let profilePicRef = storageRef.child(user!.uid + "/profile_pic_small.jpg")
                    
                    // store the userID
                    let userId = user?.uid
                    
                    // create firebase realtime database reference
                    let databaseRef = FIRDatabase.database().reference()
                    
                    // TODO: Step 7 Get user profile_pic_small
                    databaseRef.child("user_profile").child(userId!).child("profile_pic_small").observe(.value, with: { (snapshot) in
                        
                        let profile_pic = snapshot.value as? String?
                        
                        // if no image
                        if profile_pic == nil {
                            if let imageData = UIImagePNGRepresentation(UIImage(named: "default-avatar")!){
                                
                                // Upload image to firebase storage
                                let uploadTask = profilePicRef.put(imageData, metadata: nil){
                                    metadata, error in
                                    if error == nil {
                                        // get uploaded image url
                                        let dowloadURL = metadata?.downloadURL()
                                        
                                        // save image url to firebase realtime database profile_pic_small
                                        databaseRef.child("user_profile").child("\(user!.uid)/profile_pic_small").setValue(dowloadURL?.absoluteString)
                                        
                                        // store data into the users profile page in firebase realtime
                                        databaseRef.child("user_profile").child("\(user!.uid)/name").setValue(user!.displayName ?? "")
                                        databaseRef.child("user_profile").child("\(user!.uid)/gender").setValue("")
                                        databaseRef.child("user_profile").child("\(user!.uid)/age").setValue("")
                                        databaseRef.child("user_profile").child("\(user!.uid)/email").setValue(user!.email)
                                        databaseRef.child("user_profile").child("\(user!.uid)/website").setValue("")
                                        
                                        // TODO: Step 4 Sign Out after create account
                                        try! FIRAuth.auth()?.signOut()
                                        self.dismiss(animated: true, completion: nil)
                                    }else{
                                        print("error in downloading image")
                                    }
                                }
                            }
                        }else{
                            print("User has logged in earlier")
                        }
                    })
                }
                /* #### This code is user after create register user screen  #### */
                
                
            }
        }
    }
}





