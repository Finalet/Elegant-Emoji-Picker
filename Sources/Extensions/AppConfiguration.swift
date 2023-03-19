//
//  File.swift
//  
//
//  Created by Grant Oganyan on 3/19/23.
//

import Foundation
import UIKit

class AppConfiguration {
    
    static var deviceType: UIUserInterfaceIdiom { return UIDevice.current.userInterfaceIdiom }
        
    static var isIPad: Bool { return deviceType == .pad }
    static var isIPhone: Bool { return deviceType == .phone }
    static var isMacCatalyst: Bool {
#if targetEnvironment(macCatalyst)
        return true
#else
        return false
#endif
    }
    
    static var windowFrame: CGRect { return UIApplication.shared.keyWindow?.frame ?? UIScreen.main.bounds }

}

extension UIApplication {
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
    
}
