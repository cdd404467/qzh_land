//
//  BannerModel.h
//  FullLease
//
//  Created by wz on 2020/8/4.
//  Copyright © 2020 kad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerModel : NSObject

@property (nonatomic, copy) NSString *bannerId;
@property (nonatomic, copy) NSString *bannerstate;
@property (nonatomic, copy) NSString *fileaddress;
@property (nonatomic, copy) NSString *burl;
//跳转标识 0不跳转，1跳转到超链接
@property (nonatomic, assign)NSInteger jumpWay;
@property (nonatomic, copy)NSString *title;
@end

NS_ASSUME_NONNULL_END
