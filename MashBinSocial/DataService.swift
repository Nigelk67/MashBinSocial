//
//  DataService.swift
//  MashBinSocial
//
//  Created by Nigel Karan on 08/12/16.
//  Copyright © 2016 EatMyGoal. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

//This refers to the top level URL from the Firebase project database (gets from the GoogleService_info.plist:-
let DB_BASE = FIRDatabase.database().reference()

//To retrieve Firebase Storage data:-
let STORAGE_BASE = FIRStorage.storage().reference()

//Makes this class global:-
class DataService {
    
    static let ds = DataService()
    
    //Db references:-
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    //Storage references:-
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    //To get the current user id:-
    var REF_USER_CURRENT: FIRDatabaseReference {
       // let uid = KeychainWrapper.stringForKey(KEY_UID)
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    //This function adds a user id to the Firebase Db:-
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        // This writes to the Firebase Db, passing in the User Id created by Firebase and also passes in the userData (in this case, where they signed in from:-
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
}
