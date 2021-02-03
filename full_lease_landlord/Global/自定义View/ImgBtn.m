//
//  ImgBtn.m
//  YiChen
//
//  Created by TiDing on 2018/4/12.
//  Copyright © 2018年 Rui Hu. All rights reserved.
//

#import "ImgBtn.h"

@implementation ImgBtn

+(instancetype)ImgBtn{
    return [[self alloc] init];
}
- (id)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if (self) {
        // 高亮的时候不要自动调整图标
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imgW = contentRect.size.width;
    
    return CGRectMake(imgW*0.38,0,KFit_W(24),KFit_W(24));
   // CGFloat imgH = contentRect.size.height;
//    return CGRectMake(imgW*0.16,0,JCWidth(24),JCWidth(24));
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(0,titleW*0.5,titleW,titleH-(titleW*0.6));
}

@end
