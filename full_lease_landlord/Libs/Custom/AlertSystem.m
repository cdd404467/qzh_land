//
//  AlertSystem.m
//  FullLease
//
//  Created by apple on 2020/8/4.
//  Copyright © 2020 kad. All rights reserved.
//

#import "AlertSystem.h"

@implementation AlertSystem

//中间弹框,一个按钮
+ (void)alertOne:(NSString *)title msg:(nullable NSString *)msg okBtn:(NSString *)okTitle OKCallBack:(nullable void(^)(void))OK {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *alertString = [[NSMutableAttributedString alloc] initWithString:title];
    [alertString addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1) range:NSMakeRange(0, title.length)];
    [alert setValue:alertString forKey:@"attributedTitle"];
    
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (OK) {
            OK();
        }
    }];
    //KVC改变按钮颜色
    if (@available(iOS 9.0, *)){
        [okBtn setValue:MainColor forKey:@"titleTextColor"];
    }
    [alert addAction:okBtn];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication.sharedApplication.windows[0].rootViewController presentViewController:alert animated:YES completion:nil];
        });
    });
}

//中间弹框,两个按钮,取消按钮回调
+ (void)alertTwo:(NSString *)title msg:(nullable NSString *)msg cancelBtn:(NSString *)cancelTitle okBtn:(NSString *)okTitle OKCallBack:(void(^)(void))OK cancelCallBack:(nullable void(^)(void))cancel {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *alertString = [[NSMutableAttributedString alloc] initWithString:title];
    [alertString addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51,1) range:NSMakeRange(0, title.length)];
    [alert setValue:alertString forKey:@"attributedTitle"];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cancel) {
            cancel();
        }
    }];
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (OK) {
            OK();
        }
    }];
    //KVC改变按钮颜色
    if (@available(iOS 9.0, *)){
        [okBtn setValue:MainColor forKey:@"titleTextColor"];
        [cancelBtn setValue:HEXColor(@"333333", 1) forKey:@"titleTextColor"];
    }
    [alert addAction:cancelBtn];
    [alert addAction:okBtn];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication.sharedApplication.windows[0].rootViewController presentViewController:alert animated:YES completion:nil];
        });
    });
}
@end
