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
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //Listeners - looks out for any changes in the posts section of the Db:-
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            //Breaks out the data into individual objects:-
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                //Returns each individual snap:-
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    //Gets the value in the dictionary:-
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                        
                    }
                }
                
            }
            //Refreshes the table:-
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Refers to the PostCell file to return the data:-
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.configureCell(post: post)
            return cell
            //For safety:-
        } else {
            return PostCell()
        }
        
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
