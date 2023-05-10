//
//  Ext_View.swift
//  LiveJoke
//
//  Created by Prakash Raj on 10/05/23.
//

import UIKit


extension UIView {
    func circular(border: CGFloat, color: UIColor?) {
        self.roundWith(border: border, color: color, rad: self.bounds.size.height/2.0)
    }
    
    func roundWith(border: CGFloat, color: UIColor?, rad: CGFloat) {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = rad
        self.clipsToBounds = true
        
        self.layer.borderWidth = border
        if color != nil {
            self.layer.borderColor = color!.cgColor
        }
    }
}
