//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 11/1/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class SignInTableViewController: UITableViewController, FBSDKLoginButtonDelegate {
    
    @IBAction func backToSignIn(segue: UIStoryboardSegue) {
        print("backToSignIn")
    }
    
    @IBOutlet var facebookButton: FBSDKLoginButton!
    @IBOutlet var customFacebookButton: UIButton!
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add delegate for Facebook Button
        facebookButton.readPermissions = ["email", "public_profile", "user_friends"]
        facebookButton.delegate = self
        
        // Custom Button Property
        customFacebookButton.backgroundColor = UIColor.blue
        customFacebookButton.setTitleColor(UIColor.white, for: .normal)
        customFacebookButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        loadingIndicator.stopAnimating()
        if let user = FIRAuth.auth()?.currentUser {
            // User is signed in.
            print("Sign In User: \(user.email)")
            self.performSegue(withIdentifier: "showProfile", sender: nil)
        } else {
            // No user is signed in.
            print("No user is signed in.")
        }
    }
    
    
    // MARK: Firebase signin button
    @IBAction func signIn(_ sender: UIButton) {
        FIRAuth.auth()?.signIn(withEmail: usernameTextField.text! , password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print("My Error ####\(error?.localizedDescription)")
            }else{
                if !(user?.isEmailVerified)! {
                    print("Sorry your email has not yet been verified.")
                }else{
                    // User is signed in.
                    print("Sign In User: \(user?.email)")
                    self.performSegue(withIdentifier: "showProfile", sender: nil)
                }
            }
        }
    }
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: usernameTextField.text!) { error in
            if let error = error {
                // An error happened.
            } else {
                print("Password reset email sent.")
                // Password reset email sent.
            }
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        if error != nil {
            print("facebook login error : \(error.localizedDescription)")
            loadingIndicator.stopAnimating()
            return
        }else if result.isCancelled{
            print("Click done or cancel")
            loadingIndicator.stopAnimating()
            return
        }
        
        print("-----> ",result)
        loadingIndicator.startAnimating()
        getProfile()
        firebaseLoginWithCredential()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        print("Log Out")
    }
    
    
    func handleCustomFBLogin() {
        
        let paramaters = ["email", "public_profile", "user_friends"]
        FBSDKLoginManager().logIn(withReadPermissions: paramaters, from: self, handler: {
            (result, error) in
            
            if error != nil {
                // Error occur
                print("facebook login error", error?.localizedDescription ?? "")
                self.loadingIndicator.stopAnimating()
            }else if (result?.isCancelled)!{
                print("Click done or cancel")
                self.loadingIndicator.stopAnimating()
                return
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
    
    
    // Get Profile
    func getProfile()  {
        // Create facebook graph wih field
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id,name,email"]).start { (connection, result, error) in
            if error != nil {
                print("Get profile error ", error?.localizedDescription ?? "")
            }else{
                let dict = result as! [String : AnyObject]
                print(dict["email"] ?? "")
            }
        }
    }
    
    func firebaseLoginWithCredential() {
        // Get Facebok token
        let accessToken = FBSDKAccessToken.current()
        
        if let accessTokenString = accessToken?.tokenString {
            print(accessTokenString)
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
            
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                }else{
                    print(user?.displayName ?? "")
                    print(user?.email)
                    self.performSegue(withIdentifier: "showProfile", sender: nil)
                }
            })
        }
    }
}




















