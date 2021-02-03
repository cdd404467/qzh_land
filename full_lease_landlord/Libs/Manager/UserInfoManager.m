//
//  UserInfoManager.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import "UserInfoManager.h"


static UserInfoManager *userManger = nil;

@implementation UserInfoManager
+ (UserInfoManager *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManger = [[super allocWithZone:NULL]init];
    });
    
    return userManger;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [UserInfoManager sharedInstance];
}
-(id) copyWithZone:(struct _NSZone *)zone
{
    return [UserInfoManager sharedInstance];
}

-(void)setModel:(UserInfoModel *)model{
    _model = model;
    if(model) {
        self.isLogin = true;
    }
}
@end
