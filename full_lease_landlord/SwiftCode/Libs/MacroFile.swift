//
//  MacroFile.swift
//  full_lease_landlord
//
//  Created by apple on 2020/9/28.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

/*这是一个宏文件*/

var SCREEN_BOUNDS = PublicPara.screen_bounds()
var SCREEN_WIDTH = PublicPara.screen_width()
var SCREEN_HEIGHT = PublicPara.screen_height()
var isIphoneX: Bool = PublicPara.isIphoneX()
var STATEBAR_HEIGHT: CGFloat = PublicPara.stateBar_height()
var TABBAR_HEIGHT: CGFloat = PublicPara.tabBar_height()
var NAV_HEIGHT: CGFloat = PublicPara.nav_height()
var Top_Height_Dif: CGFloat = PublicPara.top_height_dif()
var Bottom_Height_Dif: CGFloat = PublicPara.bottom_height_dif()
var MainColor: UIColor = UIColor.hex(hexString: PublicPara.mainColorStr(), alpha: 1)
var User_Info:[String:String] {
    return UserDefaults.standard.dictionary(forKey: "userInfo") == nil ? [:] : UserDefaults.standard.dictionary(forKey: "userInfo") as! [String : String]
}

var User_Token: String {
    return User_Info["token"] ?? ""
}

var User_Phone: String {
    return User_Info["userPhone"] ?? ""
}

var User_Id: String {
    return User_Info["id"] ?? ""
}

var isUserLogin: Bool {
    return User_Token.isEmpty == true ? false : true
}

var ContactPhone: String {
    if let phone = UserDefaults.standard.object(forKey: "contactPhone") {
        return phone as! String
    }
    return ""
}

func KFit_W(_ variate: CGFloat) -> CGFloat {
    return PublicPara.kfit_w(variate)
}

func KFit_H(_ variate: CGFloat) -> CGFloat {
    return PublicPara.kfit_h(variate)
}

func KFont(_ value: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: PublicPara.kfit_w(value))
}

func RGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
    return UIColor(r: r, g: g, b: b, a: a)
}

func HexColor(_ colorString: String, _ alpha: CGFloat) -> UIColor {
    return UIColor.hex(hexString: colorString, alpha: alpha)
}


let NotificationName_AddBankCardSuccess: String = "NotificationName_AddBankCardSuccess"
