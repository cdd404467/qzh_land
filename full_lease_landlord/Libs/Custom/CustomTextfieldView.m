//
//  CustomTextfieldView.m
//  FullLease
//
//  Created by wz on 2020/7/23.
//  Copyright © 2020 kad. All rights reserved.
//

#import "CustomTextfieldView.h"

@implementation CustomTextfieldView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}


-(void)setUI{
    CGFloat w = self.width;
    CGFloat h = self.height;
    
    self.KTextfield = [[UITextField alloc]init];
    self.KTextfield.textColor = UIColor.whiteColor;
    self.KTextfield.tintColor = HEXColor(@"#27C3CE", 1);
    self.KTextfield.frame = CGRectMake(0,0, w, h*0.7);
    self.KTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.KTextfield];
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, h*0.7, w, 1)];
    _lineView.backgroundColor = RGBA(238, 238, 238, 1);
    [self addSubview:_lineView];
    self.erroLab = [[UILabel alloc]initWithFrame:CGRectMake(0, h*0.75, w, h*0.25)];
    self.erroLab.textColor = UIColor.redColor;
    self.erroLab.font = kFont(10);
//    [self addSubview:self.erroLab];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self.KTextfield];
}

-(void)textDidEndEditing:(NSNotification*)note
{
    if (![note.object isEqual:self.KTextfield])return;
    [self verifyRegex];
    
}
-(void)verifyRegex
{
//    if (![self.Regex isEqualToString:@""]) {
//        if (![FullLeaseTool.sharedInstance isValidateByRegex:self.Regex withstr:self.KTextfield.text]) {
//            [self addShakeAnimation];
//            return;
//        }
//    }
    if (self.KTextfield.text.length < self.minTextLength) {
        [self addShakeAnimation];
        return;
    }
    
    if (self.KTextfield.text.length > self.maxTextLength) {
        [self addShakeAnimation];
        return;
        
    }
    self.erroLab.text = @"";
}
//添加抖动动画
-(void)addShakeAnimation
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat currentTx = self.transform.tx;

    //    animation.delegate = self;
    animation.duration = 0.5;
    animation.values = @[ @(currentTx), @(currentTx + 10), @(currentTx-8), @(currentTx + 8), @(currentTx -5), @(currentTx + 5), @(currentTx) ];
    animation.keyTimes = @[ @(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:animation forKey:@"kAFViewShakerAnimationKey"];
    self.erroLab.text = self.erroStr;
}
-(void)setViewWidh:(CGFloat)ViewWidh{
    _ViewWidh = ViewWidh;
    self.KTextfield.width = self.width-_ViewWidh;
}
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.KTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:_placeholderColor,NSFontAttributeName:kFont(17)}];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
