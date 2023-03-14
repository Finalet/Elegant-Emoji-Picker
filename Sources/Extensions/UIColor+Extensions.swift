//
//  UIColor+Extensions.swift
//  Demo
//
//  Created by Grant Oganyan on 3/10/23.
//

import Foundation
import UIKit

extension UIColor {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
    
    func lerp (second: UIColor, percentage: CGFloat) -> UIColor {
        return UIColor(red: (1-percentage)*self.components.red + percentage*second.components.red, green: (1-percentage)*self.components.green + percentage*second.components.green, blue: (1-percentage)*self.components.blue + percentage*second.components.blue, alpha: (1-percentage)*self.components.alpha + percentage*second.components.alpha)
    }
}
