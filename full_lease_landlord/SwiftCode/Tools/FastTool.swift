//
//  FastTool.swift
//  full_lease_landlord
//
//  Created by apple on 2020/12/28.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

class FastTool {
    //打电话
    class func phoneCall(_ phoneNum: String) {
        let phoneStr = "telprompt://" + phoneNum
        let url = URL.init(string: phoneStr)!
        DispatchQueue.global(qos: .default).async {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    //判断模拟器
    class func isSimuLator() -> Bool {
        if TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1 {
            return true
        } else {
            return false
        }
    }
    
    //判断是否debug
    class func isDebug() -> Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
    
    //数据是否有效
    class func isRightData(object: Any) -> Bool {
        if object is String {
            let str: String = object as! String
            if str == "null" || str == "<null>" || str == "" {
                return false
            }
            return true
        } else {
            if object is NSNull {
                return false
            }
            return true
        }
    }
    
}
