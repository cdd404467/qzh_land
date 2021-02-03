//
//  ZukeModel.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZukeModel : NSObject
//姓名
@property (nonatomic, copy)NSString *name;
//性别 0 未知 1男 2女
@property (nonatomic, assign)NSInteger sex;
//手机号
@property (nonatomic, copy)NSString *phone;
//身份证号
@property (nonatomic, copy)NSString *document;

@end

NS_ASSUME_NONNULL_END
