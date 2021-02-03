//
//  UIImage+Extension.swift
//  full_lease_landlord
//
//  Created by apple on 2021/1/29.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

public extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        if size.width <= 0 || size.height <= 0 {
            return UIImage()
        }
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func imageWithColor(color: UIColor) -> UIImage {
        imageWithColor(color: color, size: CGSize.init(width: 1, height: 1))
    }
}
