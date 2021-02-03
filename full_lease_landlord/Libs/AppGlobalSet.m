//
//  AppGlobalSet.m
//  FullLease
//
//  Created by apple on 2020/8/10.
//  Copyright © 2020 kad. All rights reserved.
//

#import "AppGlobalSet.h"
#import <BRPickerStyle.h>


@implementation AppGlobalSet

+ (BRPickerStyle *)pickViewStyle {
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    customStyle.cancelTextColor = MainColor;
    customStyle.cancelBorderStyle = BRBorderStyleSolid;
    customStyle.cancelBorderWidth = 1.f;
    
    customStyle.doneColor = MainColor;
    customStyle.doneTextColor = UIColor.whiteColor;
    customStyle.doneBorderStyle = BRBorderStyleFill;
    return customStyle;
}


@end
