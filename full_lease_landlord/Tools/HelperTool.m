//
//  HelperTool.m
//  FullLease
//
//  Created by apple on 2020/8/7.
//  Copyright © 2020 kad. All rights reserved.
//

#import "HelperTool.h"

@implementation HelperTool
//  添加点击手势
+ (void)addTapGesture:(UIView *)view withTarget:(id)target andSEL:(SEL)sel {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tap];
}

//获取当前显示的控制器
+ (UIViewController *)getCurrentVC
{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[UIApplication.sharedApplication.windows[0] rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

#pragma mark - 画圆角和边框
+ (void)drawRound:(UIView * _Nonnull)view corner:(UIRectCorner)corner radiu:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    [view.superview layoutIfNeeded];
    //画圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
    if (borderWidth == 0.0)
        return;
    
    //画边框
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = view.bounds;
    borderLayer.path = maskPath.CGPath;
    borderLayer.lineWidth = borderWidth;
    borderLayer.strokeColor = borderColor.CGColor;
    [view.layer addSublayer:borderLayer];
}

//只要圆角
+ (void)drawRound:(UIView * _Nonnull)view corner:(UIRectCorner)corner radiu:(CGFloat)radius {
    [self drawRound:view corner:corner radiu:radius borderWidth:0.0 borderColor:nil];
}

+ (void)drawRound:(UIView * _Nonnull)view radiu:(CGFloat)radius {
    [self drawRound:view corner:UIRectCornerAllCorners radiu:radius];
}

+ (void)drawRound:(UIView * _Nonnull)view {
    [self drawRound:view radiu:view.width / 2];
}


//同时要圆角和border
+ (void)drawRound:(UIView * _Nonnull)view radiu:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    [self drawRound:view corner:UIRectCornerAllCorners radiu:radius borderWidth:borderWidth borderColor:borderColor];
}

+ (void)drawRound:(UIView * _Nonnull)view borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    [self drawRound:view radiu:view.width / 2 borderWidth:borderWidth borderColor:borderColor];
}
@end
