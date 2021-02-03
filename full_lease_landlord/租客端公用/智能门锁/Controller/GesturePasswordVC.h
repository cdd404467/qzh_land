//
//  GesturePasswordVC.h
//  FullLease
//
//  Created by apple on 2020/11/19.
//  Copyright © 2020 kad. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GesturePasswordVC : BaseViewController
/**
 1-设置新密码
 2-验证密码
 3-忘记密码

 **/
@property (nonatomic, assign)NSInteger type;

@property (nonatomic, strong)NSString  *contactId;

@end

NS_ASSUME_NONNULL_END
