//
//  PublicPara.swift
//  full_lease_landlord
//
//  Created by apple on 2021/1/27.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation


//被OC和swift同时调用的用类方法，只是swift调用的用属性
public class PublicPara: NSObject {
    
    @objc class func screen_bounds() -> CGRect {
        UIScreen.main.bounds
    }
    
    @objc class func screen_width() -> CGFloat {
        UIScreen.main.bounds.width
    }
    
    @objc class func screen_height() -> CGFloat {
        UIScreen.main.bounds.height
    }
    
    @objc class func isIphoneX() -> Bool {
        max(screen_width(), screen_height()) > 736 ? true : false
    }
    
    @objc class func stateBar_height() -> CGFloat {
        isIphoneX() ? 44.0 : 20.0
    }
    
    @objc class func tabBar_height() -> CGFloat {
        isIphoneX() ? 83.0 : 49.0
    }
    
    @objc class func nav_height() -> CGFloat {
        isIphoneX() ? 88.0 : 64.0
    }
    
    @objc class func top_height_dif() -> CGFloat {
        isIphoneX() ? 24.0 : 0
    }
    
    @objc class func bottom_height_dif() -> CGFloat {
        isIphoneX() ? 34.0 : 0
    }
    
    @objc class func kfit_w(_ variate: CGFloat) -> CGFloat {
        return variate * screen_width() / 375
    }
    
    @objc class func kfit_h(_ variate: CGFloat) -> CGFloat {
        return variate * screen_height() / 667
    }
    
    @objc class func mainColorStr() -> String {
        "#28C3CE"
    }
    
    
}
