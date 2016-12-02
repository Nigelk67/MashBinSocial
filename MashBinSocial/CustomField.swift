//
//  CustomField.swift
//  MashBinSocial
//
//  Created by Nigel Karan on 02/12/16.
//  Copyright © 2016 EatMyGoal. All rights reserved.
//

import UIKit

class CustomField: UITextField {

    //Border design for text fields (email and password):-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
        
        
    }
    
    //Insets the placeholder text in the text fields:-
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    //Insets the edited text fields:-
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    
    
}
