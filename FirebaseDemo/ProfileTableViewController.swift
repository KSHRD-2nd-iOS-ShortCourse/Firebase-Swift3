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

    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()


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




