//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 11/1/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class SignInTableViewController: UITableViewController, FBSDKLoginButtonDelegate {
    // TODO: Step 2 Back to Sign In Screen
    @IBAction func backToSignIn(segue: UIStoryboardSegue) {
        print("backToSignIn")
    }
    
    // TODO: Step 1 Create Property
    var email = ""
    @IBOutlet var facebookButton: FBSDKLoginButton!
    @IBOutlet var customFacebookButton: UIButton!
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Step 7 Facebook button configure
        // Add delegate for FacebookButton
        facebookButton.readPermissions = ["email", "public_profile", "user_friends"]
        facebookButton.delegate = self
        
        // Custom Button Property
        customFacebookButton.backgroundColor = UIColor.blue
        customFacebookButton.setTitleColor(UIColor.white, for: .normal)
        customFacebookButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadingIndicator.stopAnimating()
        
        // TODO: Step 6 Check Firebase current user
        if let user = FIRAuth.auth()?.currentUser{
            // User is signed in.
            print("Sign In User: \(user.email)")
            self.performSegue(withIdentifier: "showProfile", sender: nil)
        }else{
            // No user is signed in.
            print("viewDidAppear : NO user sign in")
        }
    }
    
    // TODO: Step 3 - Firebase SignIn
    @IBAction func signIn(_ sender: UIButton) {
        // Firebase SignIn with Email
        FIRAuth.auth()?.signIn(withEmail: usernameTextField.text! , password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print("My Error ####\(error?.localizedDescription)")
            }else{
                // If no error, get signed in user
                // Check email verified
                if !(user!.isEmailVerified) {
                    let alertVC = UIAlertController(title: "Verify Email", message: "Sorry. Your email address has not yet been verified. Please verify your email!", preferredStyle: .alert)
                    let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                        (_) in
                        user!.sendEmailVerification(completion: nil)
                    }
                    let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    
                    alertVC.addAction(alertActionOkay)
                    alertVC.addAction(alertActionCancel)
                    self.present(alertVC, animated: true, completion: nil)
                } else {
                    // User is signed in.
                    print ("Email verified. Signing in...\(user!.email!)")
                    self.performSegue(withIdentifier: "showProfile", sender: nil)
                }
            }
        }
    }
    
    // TODO: Step 4 - Firebase Reset Password
    @IBAction func forgetPassword(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Reset Password", message: "Please enter your email. we will send reset password link to your email.", preferredStyle: .alert)
        
        // Add the text field for text entry.
        alertVC.addTextField { textField in
            // If you need to customize the text field, you can do so here.
            /*
             Listen for changes to the text field's text so that we can toggle the current
             action's enabled property based on whether the user has entered a sufficiently
             secure entry.
             */
            NotificationCenter.default.addObserver(self, selector: #selector(self.handleTextFieldTextDidChangeNotification), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
        }
        
        // Alert action Ok
        let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
            (_) in
            
            // When user click Ok, Request to firebase to send password reset to user email
            FIRAuth.auth()?.sendPasswordReset(withEmail: self.email) { error in
                if let error = error {
                    // An error happened.
                    print(error)
                } else {
                    // Password reset email sent.
                    print("Password reset email sent. \(self.email)")
                }
            }
        }
        
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertVC.addAction(alertActionOkay)
        alertVC.addAction(alertActionCancel)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // TODO: Step 5 - UITextFieldTextDidChangeNotification
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! UITextField
        
        email = textField.text!
        print("TextDidChangeNotification \(email)")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        
        loadingIndicator.startAnimating()
        // Check if error occur
        if error != nil {
            // error happen
            loadingIndicator.stopAnimating()
            print("facebook login error :", error.localizedDescription)
            return
        }else if (result.isCancelled){
            loadingIndicator.stopAnimating()
            print("Cancelled")
            return
        }else{
            getProfile()
            firebaseLoginWithCredential()
            print("Successfull login in with facebook...")
        }
    }
    
    // TODO: Step 9 Facebook Button Logout
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Log Out")
    }
    
    // TODO: Step 10 Facebook Custom Method
    // Custom method for custom fb login button
    func handleCustomFBLogin() {
        
        let paramaters = ["email", "public_profile", "user_friends"]
        FBSDKLoginManager().logIn(withReadPermissions: paramaters, from: self, handler: {
            (result, error) in
            // Check if error occur
            if error != nil {
                // Error occur
                print("facebook login error", error?.localizedDescription ?? "")
                self.loadingIndicator.stopAnimating()
            }else if (result?.isCancelled)!{
                print("Click done or cancel")
                self.loadingIndicator.stopAnimating()
            }else{
                self.loadingIndicator.startAnimating()
                // No error sign in success
                if (result?.grantedPermissions.contains("public_profile"))!{
                    if let token = FBSDKAccessToken.current(){
                        print("Facebook token", token)
                        self.firebaseLoginWithCredential()
                        self.getProfile()
                    }
                }
            }
        })
    }
    
    
    // TODO: Step 11 Facebook Get Profile
    func getProfile()  {
        // Create facebook graph wih field
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id,name,email"]).start { (connection, result, error) in
            if error != nil {
                print("Get profile error ", error?.localizedDescription ?? "")
            }else{
                let dict = result as! [String : AnyObject]
                print("Facebook graph :", dict)
            }
        }
    }
    
    // TODO: Step 12 Firebase Login With Credential
    func firebaseLoginWithCredential() {
        // Get Facebok token
        let accessToken = FBSDKAccessToken.current()
        
        // Check token string have don't have -> return
        if let accessTokenString = accessToken?.tokenString {
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
            
            // TODO: Step 13 Sign in with Credential
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                // Check if error occur
                if error != nil {
                    // error happen
                    print("Something went wrong with our FB user", error ?? "")
                }else{
                    self.loadingIndicator.stopAnimating()
                    print("Successfully logged in with our user", user ?? "")
                    
                    
                    
                    // TODO: Step 14 Save facebook image to Firebase Storage and url to Firebase Realtime
                    /* #### This code is user after create register user screen  #### */
                    
                    // When the user logs in for the frist time, we'll store the users name and the users email on their profile page.
                    // also store the small version of the profile picture in the database and in the storage
                    
                    //Create firebase reference object
                    let storageRef = FIRStorage.storage().reference()
                    let profilePicRef = storageRef.child(user!.uid+"/profile_pic_small.jpg")
                    
                    let databaseRef = FIRDatabase.database().reference()
                    
                    databaseRef.child("user_profile/\(user!.uid)/profile_pic_small").observe(.value, with: { (snapshot) in
                        
                        let profile_pic = snapshot.value as? String?
                        
                        if profile_pic == nil{
                            if let imageData = try? Data(contentsOf: user!.photoURL!){
                                
                                // upload image to firebase storage
                                let uploadTask = profilePicRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                                    
                                    if error != nil{
                                        print("upload image error", error?.localizedDescription ?? "")
                                    }else{
                                        // get upload image url
                                        let downloadURL = metadata?.downloadURL()
                                        
                                        // Set value to firebase database
                                        let userProfile = databaseRef.child("user_profile/\(user!.uid)")
                                        
                                        
                                        userProfile.child("name").setValue(user!.displayName)
                                        userProfile.child("gender").setValue("Male")
                                        userProfile.child("age").setValue("20")
                                        userProfile.child("email").setValue(user!.email)
                                        userProfile.child("website").setValue("unknown")
                                        userProfile.child("profile_pic_small").setValue(downloadURL!.absoluteString)
                                        
                                    }
                                })
                            }else{
                                print("error in downloading image")
                            }
                        }else{
                            print("User has logged in earlier")
                        }
                        
                    })
                    /* #### This code is user after create register user screen  #### */
                    self.performSegue(withIdentifier: "showProfile", sender: nil)
                }
            })
        }
    }
}
