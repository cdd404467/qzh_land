//
//  TopNavTitleBar.h
//  FullLease
//
//  Created by wz on 2020/7/26.
//  Copyright © 2020 kad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopNavTitleBar;

NS_ASSUME_NONNULL_BEGIN

@protocol TopNavTitleBarDelegate <NSObject>

@optional
-(void)selectTitle:(TopNavTitleBar *)topNavTitleBar index:(NSInteger)index;

@end

@interface TopNavTitleBar : UIView

@property (nonatomic,weak) id<TopNavTitleBarDelegate> delegate;

@property (nonatomic, assign) NSInteger selectedIndex;


-(instancetype)initWithTitles:(NSArray *)titles titleColor:(UIColor *)titleColor selectedColor:(UIColor *)selectedColor titleSize:(CGFloat)titleSize selectIndex:(NSInteger)index lineH:(CGFloat)height frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
