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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
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

    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                
                print("NIGE: Unable to authenticate with Firebase - \(error)")
                
            } else {
                
                print("NIGE: Sucessful Firebase authentication")
            }
        })
        
    }
    
}

















