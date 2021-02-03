//
//  MsgModel.h
//  full_lease_landlord
//
//  Created by apple on 2020/9/1.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MsgModel : NSObject
//消息id
@property (nonatomic, copy)NSString *s_id;
//消息标题
@property (nonatomic, copy)NSString *title;
//消息正文
@property (nonatomic, copy)NSString *content;
//创建时间
@property (nonatomic, copy)NSString *createTimeStr;
//
@property (nonatomic, assign)NSInteger type;

@end

NS_ASSUME_NONNULL_END
