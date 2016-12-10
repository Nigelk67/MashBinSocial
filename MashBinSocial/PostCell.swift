//
//  PostCell.swift
//  MashBinSocial
//
//  Created by Nigel Karan on 06/12/16.
//  Copyright © 2016 EatMyGoal. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    

    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // To add the data from Firebase into the feed:-
    func configureCell(post: Post) {
        
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        //This is now used in cellForRow in the FeedVC.
    }

}
