//
//  VCJump.h
//  full_lease_landlord
//
//  Created by apple on 2020/10/16.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCJump : NSObject
+ (void)jumpPageWithType:(NSInteger)type;
+ (void)jumpToWithModel_Apns:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
