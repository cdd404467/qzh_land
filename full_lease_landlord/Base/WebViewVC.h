//
//  WebViewVC.h
//  full_lease_landlord
//
//  Created by apple on 2020/10/29.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewVC : BaseViewController
@property (nonatomic, copy)NSString *webUrl;
@property (nonatomic, copy)NSString *webTitle;
@property (nonatomic, assign)BOOL needBottom;
@end

NS_ASSUME_NONNULL_END
