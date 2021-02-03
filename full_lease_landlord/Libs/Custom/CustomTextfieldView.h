//
//  CustomTextfieldView.h
//  FullLease
//
//  Created by wz on 2020/7/23.
//  Copyright © 2020 kad. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTextfieldView : UIView
@property(nonatomic,copy)UIColor *placeholderColor;
@property(nonatomic,assign)int maxTextLength;
@property(nonatomic,copy) NSString* Regex;
@property(nonatomic,assign) CGFloat ViewWidh;
@property(nonatomic,strong) UITextField* KTextfield;
@property(nonatomic,copy) NSString* placeholder;
@property(nonatomic,strong) UIView* lineView;
@property(nonatomic,copy) NSString* erroStr;
@property(nonatomic,strong) UILabel* erroLab;
@property(nonatomic,assign)int minTextLength;
-(void)verifyRegex;
@end

NS_ASSUME_NONNULL_END
