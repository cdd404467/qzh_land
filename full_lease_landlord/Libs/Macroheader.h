//
//  Macroheader.h
//  SH
//
//  Created by i7colors on 2019/9/3.
//  Copyright © 2019 surhoo. All rights reserved.
//

#ifndef Macroheader_h
#define Macroheader_h

#import "UIColor+Hex.h"
#import "UIImage+Color.h"
#import "QuickTool.h"
#import "AppGlobalSet.h"

#define PlaceHolderImg [UIImage imageNamed:@"placeholder_image"]
#define BottomOffset(x)         if (@available(iOS 11.0, *)){make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(x);} else {make.bottom.equalTo(self.view.mas_bottom).offset(x);}

//十六进制颜色转换
#define HEXColor(string,alpha) [UIColor colorWithHexString:(string) andAlpha:(alpha)]
//RGBA
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGBA_F(r, g, b, a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]
//全局主题色
#define MainColor [UIColor colorWithHexString:[PublicPara mainColorStr]]
#define Like_Color HEXColor(@"#ededed", 1)
#define Line_Color RGBA(232, 232, 232, 1)
#define Cell_Line_Color HEXColor(@"#EEEEEE", 1)
#define BannerBgColor HEXColor(@"#f8f8f8", 1)
#define TableColor HEXColor(@"#f5f5f5", 1)
#define MainBgColor HEXColor(@"#F6F6F6", 1)

// 适配宽比例
#define Scale_W [UIScreen mainScreen].bounds.size.width / 375.f
#define KFit_W(variate) ceil(Scale_W * variate)
// 适配高比例
#define Scale_H [UIScreen mainScreen].bounds.size.height / 667.f
#define KFit_H(variate) ceil(Scale_H * variate)

#define kFont(value) [UIFont systemFontOfSize:value * Scale_W]
#define bkFont(value) [UIFont boldSystemFontOfSize:value * Scale_W]

//屏幕大小
#define SCREEN_BOUNDS [PublicPara screen_bounds]
//屏幕的宽
#define SCREEN_WIDTH [PublicPara screen_width]
//屏幕的高
#define SCREEN_HEIGHT [PublicPara screen_height]
//判断是否是iPhoneX系列
#define iPhoneX [PublicPara isIphoneX]
/*** 适配iPhoneX 顶部和底部 ***/
//返回状态栏高度
#define STATEBAR_HEIGHT [PublicPara stateBar_height]
//返回tabbar的高度
#define TABBAR_HEIGHT [PublicPara tabBar_height]
//返回导航栏高度
#define NAV_HEIGHT [PublicPara nav_height]
//顶部高度差
#define Top_Height_Dif [PublicPara top_height_dif]
//底部高度差
#define Bottom_Height_Dif [PublicPara bottom_height_dif]

//系统版本
#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
//json code

#define JsonCode [json[@"code"] integerValue]

#define BR_Appearance [AppGlobalSet pickViewStyle]
#define wxAppID @"wx2a1f65135ba300ff"


//判断后台返回数据是合法的
#define isRightData(object) [QuickTool isRirhtData:object]
#define RightDataSafe(object) [QuickTool RightDataSafe:object]
#define Phone_Call(phoneNum) [QuickTool callPhone:phoneNum]

//转换字符串
#define To_String(code) [NSString stringWithFormat:@"%@", code]

//weakself 和 strongself
#define DDWeakSelf __weak typeof(self) weakself = self;
#define DDStrongSelf __weak typeof(self) strongself = self;


//系统版本
#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#pragma mark - 本地存储
/*********   本地存储   *********/
//NSUserDefaults
#define UserDefault [NSUserDefaults standardUserDefaults]
//用户信息
#define User_Info [UserDefault objectForKey:@"userInfo"]
//存储的手机号
#define User_Phone [User_Info objectForKey:@"userPhone"]
//账户余额
#define User_Money [User_Info objectForKey:@"userMoney"]
//用户名
#define User_Name [User_Info objectForKey:@"userName"]
//用户名
#define User_Id [User_Info objectForKey:@"id"]
//用户是否设置过支付密码
//#define User_IsSetPW ([[User_Info objectForKey:@"isSetPW"] integerValue] == 1 ? YES : NO)
#define User_IsSetPW [QuickTool isSetPassword]
//验证支付密码
#define Check_PayPW(password) [QuickTool checkPassWord:password]
//获取独立门锁token
#define DoorToken [QuickTool getDoorToken]
//联系电话
#define ContactPhone [UserDefault objectForKey:@"contactPhone"]
//小程序扫码地址
#define MiniProgramQrcode [UserDefault objectForKey:@"wxQrCode"]

//取token
#define Get_User_Token [User_Info objectForKey:@"token"]
//判断是否登陆
#define isUserLogin (Get_User_Token ? YES : NO)
//存储的token
#define User_Token (Get_User_Token ? Get_User_Token : @"")
//极光ID
#define JPushID [UserDefault objectForKey:@"jpushID"]

//app角标
#define Icon_BadgeValue [UIApplication sharedApplication].applicationIconBadgeNumber


//#pragma mark - quickTool的快捷结果
////判断是不是模拟器
#define isSimuLator [QuickTool is_SimuLator]
////判断是否是debug模式
#define isDebug [QuickTool is_Debug]
////navBar的高度
//#define NavBarHeight [QuickTool navBarHeight]

#endif /* Macroheader_h */
