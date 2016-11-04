//
//  ProfileTableViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 11/3/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FBSDKLoginKit

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = FIRAuth.auth()?.currentUser{
            if let accessTokenString = FBSDKAccessToken.current() {
                nameLabel.text = user.displayName
                
                //                let data = NSData(contentsOf: user.photoURL!)
                //                profileImageView.image = UIImage(data: data as! Data)
                
                
                // Firebase Storage
                // Get a reference to the storage service, using the default Firebase App
                let storage = FIRStorage.storage()
                
                // Create a storage reference from our storage service
                let storageRef = storage.reference(forURL: "gs://fir-demo-9d15e.appspot.com")
                
                storageRef.data(withMaxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("Unable to download image ", error?.localizedDescription ?? "")
                        return
                    }
                    
                    print("User already has an image, no need to download from facebook")
                    self.profileImageView.image = UIImage(data: data!)
                })
                
                
                if self.profileImageView.image == nil {
                    print("Facebook image")
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
                            
                            // Get firebase storage path
                            let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")
                            
                            // Upload the file to the path "images/rivers.jpg"
                            let uploadTask = profilePicRef.put(imageData as Data, metadata: nil) { metadata, error in
                                if (error != nil) {
                                    // Uh-oh, an error occurred!
                                } else {
                                    // Metadata contains file metadata such as size, content-type, and download URL.
                                    let downloadURL = metadata!.downloadURL
                                }
                            }
                            self.profileImageView.image = UIImage(data: imageData as Data)
                        }
                    })
                }
            }
        }
        
        
        
    }
    @IBAction func signOut(_ sender: Any) {
        
        // signs the user out of the Firebase app
        try! FIRAuth.auth()!.signOut()
        
        // signs the user out of the Facebook app
        FBSDKAccessToken.setCurrent(nil)
        FBSDKLoginManager().logOut()
        self.dismiss(animated: true, completion: nil)
        
    }
}




