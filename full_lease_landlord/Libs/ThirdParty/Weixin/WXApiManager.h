//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

#define WeixinPayResultSuccess @"WeixinPayResultSuccess"
#define WeixinPayResultFailed @"WeixinPayResultFailed"

NS_ASSUME_NONNULL_BEGIN

@protocol WXApiManagerDelegate <NSObject>

@optional
- (void)wxApiManagerLaunchMiniProgram:(BaseResp *)resp;

@end

@interface WXApiManager : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;
- (void)launchMiniProgramWithUserName:(NSString *)userName
                                 path:(nullable NSString *)path
                                 type:(WXMiniProgramType)miniProgramType;
+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
