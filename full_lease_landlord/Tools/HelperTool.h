//
//  HelperTool.h
//  FullLease
//
//  Created by apple on 2020/8/7.
//  Copyright © 2020 kad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelperTool : NSObject
// 添加点击手势
+ (void)addTapGesture:(UIView *)view withTarget:(id)target andSEL:(SEL)sel;
+ (UIViewController *)getCurrentVC;
//画uiview绘画圆角
+ (void)drawRound:(UIView * _Nonnull)view;
+ (void)drawRound:(UIView * _Nonnull)view radiu:(CGFloat)radius;
+ (void)drawRound:(UIView * _Nonnull)view corner:(UIRectCorner)corner radiu:(CGFloat)radius;
+ (void)drawRound:(UIView * _Nonnull)view borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (void)drawRound:(UIView * _Nonnull)view radiu:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (void)drawRound:(UIView * _Nonnull)view corner:(UIRectCorner)corner radiu:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor * _Nullable)borderColor;
@end

NS_ASSUME_NONNULL_END
