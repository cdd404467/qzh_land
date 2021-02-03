//
//  CommonlyUsedTools.h
//  FullLease
//
//  Created by wz on 2020/7/26.
//  Copyright © 2020 kad. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CommonlyUsedToolsDelegate <NSObject>

@optional

-(void)clickToolItem:(NSInteger)index;

@end

@interface CommonlyUsedTools : UIView

@property (nonatomic, weak)id<CommonlyUsedToolsDelegate>delegate;


@end

NS_ASSUME_NONNULL_END
