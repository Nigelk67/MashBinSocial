//
//  FeedVC.swift
//  MashBinSocial
//
//  Created by Nigel Karan on 04/12/16.
//  Copyright © 2016 EatMyGoal. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //Listeners:-
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            print(snapshot.value as Any)
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
    }
    
   
    @IBAction func signInBtnPressed(_ sender: Any) {
        
        //Removes authentication from the Keychain:-
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        // Signs out from Firebase:-
        try! FIRAuth.auth()?.signOut()
        // Moves back to the Sign In VC:-
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
    }
    
}
