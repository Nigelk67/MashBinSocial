//
//  PostCell.swift
//  MashBinSocial
//
//  Created by Nigel Karan on 06/12/16.
//  Copyright © 2016 EatMyGoal. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    

    var post: Post!
    
    //Refers to the LIKES count:-
    var likesRef: FIRDatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Sets a tap gesture recogniser for LIKES:-
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }

    // To add the data from Firebase into the feed (nil is the default value):-
    func configureCell(post: Post, img: UIImage? = nil) {
        
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)" //String to an Int
        //This is now used in cellForRow in the FeedVC.
        
        //This sets the post Image to the cached image:-
        if img != nil {
            self.postImg.image = img
            
        } else { //if the image is not in the cache, this downloads it:-
            
                let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("NIGE: Unable to download image from Firebase storage")
                    } else {
                        print("NIGE: Image downloaded from Firebase storage")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.postImg.image = img
                                FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                            }
                        }
                    }
            })
            
        }
        //Checks to see if the configured cell above is liked by the current user:-
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
        
    }
    //Configures LIkes image if it's been pressed:-
    func likeTapped(sender: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
                
            } else {
                
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }

}








