//
//  UserCollectionViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 11/7/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "UserCell"

class UserCollectionViewController: UICollectionViewController {

    // TODO: Step 1 Create Firebase Database and Property
    // Create database object
    var databaseRef = FIRDatabase.database().reference()
    
    // Property
    var usersDictionary = [String : AnyObject]()
    var userNameArray = [String]()
    var userImageArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Step 2 OberveEvent is listening to firebase realtime database
        // on path user_profile
        self.databaseRef.child("user_profile").observe(.value, with: { (snapshot) in
            
            // remove all value from array
            self.usersDictionary.removeAll()
            self.userNameArray.removeAll()
            self.userImageArray.removeAll()
            
            // convert snapshot value to dictionary for getting value
            self.usersDictionary = (snapshot.value as? [String : AnyObject])!
           
             // Loop each user in dictionary object
            for (key, value) in self.usersDictionary {
                
                // Get image url and name
                let img = value["profile_pic_small"] as? String
                let name = value["name"] as? String
                
                self.userImageArray.append(img!)
                self.userNameArray.append(name!)
            }
            
            // after loop add all data to array, let reload collectionview data
            self.collectionView?.reloadData()
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.usersDictionary.count
    }

    
    // TODO: Step 3 Configure Cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Create custom cell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserCollectionViewCell
    
        // Configure the cell
        let imageUrl = URL(string: userImageArray[indexPath.row])
        let imageData = try! Data(contentsOf: imageUrl!)
        
        cell.profilePictureImageView.image = UIImage(data: imageData)
        cell.nameLabel.text = userNameArray[indexPath.row]
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
