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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var captionField: CustomField!
    
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    // Global variable for the images to be downloaded to the cache:-
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    // To stop the default camera image being loaded as the 'image':-
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        //Listeners - looks out for any changes in the posts section of the Db:-
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            self.posts = [] //This line ensures there are no duplicated posts
            
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
            
            //checks to see if you can get an img from the url:-
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                
                cell.configureCell(post: post, img: img)
                } else {
            cell.configureCell(post: post)
            }
            return cell
            //For safety:-
        } else {
            return PostCell()
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Check to make sure the user has selected an image (as opposed to a video):-
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            //choose image:-
            imageAdd.image = image
            imageSelected = true
            
        } else {
            print("NIGE: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addImagePressed(_ sender: Any) {
    
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func postBtnPressed(_ sender: Any) {
        //Forces user to have a caption, using a 'guard' statement:-
        guard let caption = captionField.text, caption != "" else {
            print("NIGE: Caption must be entered")
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            print("NIGE: Image must be selected")
            return
        }
        
        //Converts image to image data to pass into Firebase (as a JPEG) & compressing it:-
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            //This gives the image a unique id:-
            let imgUid = NSUUID().uuidString
            
            //This lets Firebase Storage know what type of image you are passing in (jpeg):-
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            // This passes the unique image into Firebase Storage:-
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("NIGE: UNable to upload image to FB storage")
                } else {
                    print("NIGE: Successful upload to FB Storage")
                    let downloadUrl = metaData?.downloadURL()?.absoluteString
                    //Unwrap it for the function:-
                    if let url = downloadUrl {
                        //Call the function to create the Firebase post:-
                        self.postToFirebase(imgUrl: url)
                    }
                }
                
            }
            
        }
        
    }
    //Create object to post to Firebase:-
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, AnyObject> = [
        "caption": captionField.text! as AnyObject,
        "imageUrl": imgUrl as AnyObject,
        "likes": 0 as AnyObject
        ]
        // Posts object to Firebase, creating a unique post id:-
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        //This clears out the fields (caption and image) ready for a new post:-
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
        tableView.reloadData()
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
