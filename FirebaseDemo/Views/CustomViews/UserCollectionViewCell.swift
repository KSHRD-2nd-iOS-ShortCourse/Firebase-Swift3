//
//  UserCollectionViewCell.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 11/7/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var profilePictureImageView: UIImageView!
    
    
    // Prepare layout for controls inside UICollectionViewCell
    override func layoutSubviews() {
        super.layoutSubviews()
        
        makeRoundedCell()
    }
    
    func makeRoundedCell() {
        self.profilePictureImageView.layer.masksToBounds = true
        self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2
    }
}










