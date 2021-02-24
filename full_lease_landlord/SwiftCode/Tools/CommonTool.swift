//
//  CommonTool.swift
//  full_lease_landlord
//
//  Created by apple on 2021/2/19.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

class Help {
    class func currentVC() -> UIViewController? {
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal{
          let windows = UIApplication.shared.windows
          for  windowTemp in windows{
            if windowTemp.windowLevel == UIWindow.Level.normal{
               window = windowTemp
               break
             }
           }
         }
        let vc = window?.rootViewController
        return currentViewController(vc)
    }
    
    private class func currentViewController(_ vc :UIViewController?) -> UIViewController? {
       if vc == nil {
          return nil
       }
       if let presentVC = vc?.presentedViewController {
          return currentViewController(presentVC)
       }
       else if let tabVC = vc as? UITabBarController {
          if let selectVC = tabVC.selectedViewController {
              return currentViewController(selectVC)
           }
           return nil
        }
        else if let naiVC = vc as? UINavigationController {
           return currentViewController(naiVC.visibleViewController)
        }
        else {
           return vc
        }
     }
}
