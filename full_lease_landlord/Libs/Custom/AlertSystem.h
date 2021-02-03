//
//  AlertSystem.h
//  FullLease
//
//  Created by apple on 2020/8/4.
//  Copyright © 2020 kad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertSystem : NSObject
+ (void)alertOne:(NSString *)title msg:(nullable NSString *)msg okBtn:(NSString *)okTitle OKCallBack:(nullable void(^)(void))OK;
+ (void)alertTwo:(NSString *)title msg:(nullable NSString *)msg cancelBtn:(NSString *)cancelTitle okBtn:(NSString *)okTitle OKCallBack:(void(^)(void))OK cancelCallBack:(nullable void(^)(void))cancel;
@end

NS_ASSUME_NONNULL_END
