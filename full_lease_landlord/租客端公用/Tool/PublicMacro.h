//
//  PublicMacro.h
//  full_lease_landlord
//
//  Created by apple on 2020/12/3.
//  Copyright © 2020 apple. All rights reserved.
//

#ifndef PublicMacro_h
#define PublicMacro_h


#define KlockAppLink @"klockAppLink"
#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
#define JCWIDTH                [UIScreen mainScreen].bounds.size.width
#define JCHEIGHT               [UIScreen mainScreen].bounds.size.height
#define JCBOUNDS               [UIScreen mainScreen].bounds
#define JCSatausbar_H          ((JCHEIGHT == 812.0f) || (JCHEIGHT == 896.0f)? 44 : 20)

#define JCNAVBar_H NAV_HEIGHT
#define JCWidth(x)             ([UIScreen mainScreen].bounds.size.width/375.0f * (CGFloat)x)
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#endif /* PublicMacro_h */
