//
//  PasswordShowRectView.h
//  FullLease
//
//  Created by wz on 2020/11/19.
//  Copyright © 2020 kad. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PasswordShowRectView : UIView

@property (nonatomic, strong) NSString *lockTitle;

@property (nonatomic, strong) NSString *passwordNums;

+(instancetype)createPasswordShowRectView:(NSString *)numbers frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
