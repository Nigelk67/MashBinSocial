//
//  SignInVC.swift
//  MashBinSocial
//
//  Created by Nigel Karan on 01/12/16.
//  Copyright © 2016 EatMyGoal. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper


class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailField: CustomField!
    @IBOutlet weak var passwordField: CustomField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Checks to see if user has 'account':-
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            //If so, the Feed VC opens:-
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    //This authenticates with Facebook:-
    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                
                print("NIGE: Unable to authenticate with Facebook - \(error)")
                
            } else if result?.isCancelled == true {
                
                print("NIGE: User cancelled Facebook authentication")
                
            } else {
                
                print("NIGE: Successful Facebook authentication")
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
                
            }
        }
        
    }
    //This authenticates with Firebase for the FAcebook signin:-
    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                
                print("NIGE: Unable to authenticate with Firebase - \(error)")
                
            } else {
                
                print("NIGE: Sucessful Firebase authentication")
                //This to save the user details for future:-
                
                if let user = user {
                    
                    //This saves userdata (see DataServices.swift file) into the FirebaseDb, and completes the sign in prcocess based on function at tne end:-
                    let userData = ["provider": credential.provider]
                    
                    self.completeSignIn(id: user.uid, userData: userData)
                    
                }
                
            }
        })
        
    }
    
    // Sign In via email/ password using Firebase. There's a lot more to do here, all the different error scenarios and also need pop up boxes to advise user:-
    @IBAction func signinBtnPressed(_ sender: Any) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    
                    print("NIGE: Email User authenticated with Firebase")
                    
                    if let user = user {
                        
                        //This saves userdata (see DataServices.swift file) into the FirebaseDb, and completes the sign in prcocess based on function at tne end:-
                         let userData = ["provider": user.providerID]
                        
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                    
                } else {
                    //This creates a new user and logs in Firebase:-
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("NIGE: Unable to authenticate with Firebase using email")
                        } else {
                            print("NIGE: Successfully authenticated with Firebase")
                        
                            
                            if let user = user {
                                //This saves userdata (see DataServices.swift file) into the FirebaseDb, and completes the sign in prcocess based on function at tne end:-
                                let userData = ["provider": user.providerID]
                                
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                            
                        }
                    })
                }
            })
            
        }
    }
    
    //This creates the Keychain authentication for auto signin, adding a value to the Keychain, and then opens up the new FeedVC:-
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
            DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
            
            KeychainWrapper.standard.set(id, forKey: KEY_UID)
            
            performSegue(withIdentifier: "goToFeed", sender: nil)
            
        }
        
}

















