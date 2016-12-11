//
//  Post.swift
//  MashBinSocial
//
//  Created by Nigel Karan on 09/12/16.
//  Copyright © 2016 EatMyGoal. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
  
    //Get computer properties:
    var caption: String {
        return _caption
    }
    var imageUrl: String {
        return _imageUrl
    }
    var likes: Int {
        return _likes
    }
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    //Converts data from Firebase into something useable:-
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        //Initialiser for postRef:-
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
    }
    //To count the likes:-
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = likes + 1
        } else {
            _likes = likes - 1
        }
        //Updates number of likes for post:-
        _postRef.child("likes").setValue(_likes)
    }
    
}
















