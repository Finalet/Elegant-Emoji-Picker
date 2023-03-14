//
//  UIView+Extensions.swift
//  Demo
//
//  Created by Grant Oganyan on 3/13/23.
//

import Foundation
import UIKit


extension UIView {
    
    func PopupShadow () {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 8
    }
    
}
