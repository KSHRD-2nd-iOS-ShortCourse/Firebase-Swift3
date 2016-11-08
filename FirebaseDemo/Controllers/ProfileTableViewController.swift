//
//  ProfileTableViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 11/3/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ProfileTableViewController: UITableViewController {
    
    // TODO: Step 1 Property
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* ### Load User from firebase then display to control on screen */
        // TODO: Step 2 Check if have user
        if let user = FIRAuth.auth()?.currentUser {
            
            // Get property from object User
            let name = user.displayName
            let email = user.email
            let photoUrl = user.photoURL
            let uid = user.uid;  // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with
            // your backend server, if you have one. Use
            
            
            // TODO: Step 3 Get Facebook Token
            if let accessTokenString = FBSDKAccessToken.current() {
                
                nameLabel.text = name
                profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
                
                
                
                // TODO: Step 4
                // MARK: **** START Firebase Store
                // ### Load high resolution image and if have image don't request to facebook
                
                
                // Firebase Storage
                // Get a reference to the storage service, using the default Firebase App
                let storage = FIRStorage.storage()
                
                // Create a storage reference from our storage service
                let storageRef = storage.reference()
                
                // Get firebase storage path
                let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")
                
                // TODO: Step 5
                // #### Load in mage from firebase
                profilePicRef.data(withMaxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    if error != nil{
                        print("Unable to download image \(error?.localizedDescription)")
                    }else{
                        if data != nil {
                            print("User already has an image, no need to download from facebook")
                            self.profileImageView.image = UIImage(data: data!)
                        }
                    }
                })
                
                // TODO: Step 6
                if self.profileImageView.image == nil {
                    // Get Profile Pic from facebook
                    var profilePicture = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height": "300", "width":"300", "redirect":false], httpMethod: "GET").start(completionHandler: { (connection, result, error) in
                        
                        if error != nil {
                            print(error?.localizedDescription ?? "")
                            return
                        }
                        
                        // Cast to dictionary
                        let dictionary = result as? [String: AnyObject]
                        let data = dictionary?["data"] // get data
                        let url = data?["url"] as! String // get url
                        
                        if let imageData = NSData(contentsOf: NSURL(string: url) as! URL){
                            
                            // Upload the file to the path "images/rivers.jpg"
                            let uploadTask = profilePicRef.put(imageData as Data, metadata: nil) { metadata, error in
                                
                                if (error != nil) {
                                    // Uh-oh, an error occurred!
                                    print("Error in downloading image \(error?.localizedDescription)")
                                } else {
                                    // Metadata contains file metadata such as size, content-type, and download URL.
                                    let downloadURL = metadata!.downloadURL
                                }
                            }
                            self.profileImageView.image = UIImage(data: imageData as Data)
                        }
                    })
                    
                    // MARK:  Start Firebase Store END ****
                }
            }else{
                // TODO: Step 7 Sign in with Firebase Account
                self.nameLabel.text = email!
                self.profileImageView.image = UIImage(named: "default-avatar")
            }
        }else {
            // No user is signed in.
        }
    }
    
    // TODO: Step 8 Sign Out
    @IBAction func signOut(_ sender: Any) {
        
        // signs the user out of the Firebase app
        try! FIRAuth.auth()!.signOut()
        
        // signs the user out of the Facebook app
        FBSDKAccessToken.setCurrent(nil)
        FBSDKLoginManager().logOut()
        self.dismiss(animated: true, completion: nil)
        
    }
}




