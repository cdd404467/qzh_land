//
//  UIColor+Extension.swift
//  full_lease_landlord
//
//  Created by apple on 2020/12/28.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation


extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
          self.init(red: r/255.0 ,green: g/255.0 ,blue: b/255.0 ,alpha:a)
    }
    
    class func hex(hexString: String, alpha: CGFloat) -> UIColor {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.count < 6 { return UIColor.black }
        
        let index = cString.index(cString.endIndex, offsetBy: -6)
        let subString = cString[index...]
        if cString.hasPrefix("0X") { cString = String(subString) }
        if cString.hasPrefix("#") { cString = String(subString) }
        
        if cString.count != 6 { return UIColor.black }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        var a = alpha
        if (a > 1.0 || a < 1.0) {
            a = 1.0
        }
        
        return UIColor.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b), a: alpha)
    }
}

