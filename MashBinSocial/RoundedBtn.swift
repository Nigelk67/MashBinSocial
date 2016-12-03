//
//  RoundedBtn.swift
//  MashBinSocial
//
//  Created by Nigel Karan on 02/12/16.
//  Copyright © 2016 EatMyGoal. All rights reserved.
//

import UIKit

class RoundedBtn: UIButton {

    //Shadowing for the FB button:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        imageView?.contentMode = .scaleAspectFit
        
    }
    // To make the F sign round:-
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
        
    }
    
}
