//
//  SignRefuseView.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignRefuseView : UIView
- (instancetype)initWithCompletion:(void (^)(NSString *text))completion;
- (void)show;
@end

NS_ASSUME_NONNULL_END
