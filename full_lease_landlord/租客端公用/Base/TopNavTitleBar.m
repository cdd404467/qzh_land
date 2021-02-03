//
//  TopNavTitleBar.m
//  FullLease
//
//  Created by wz on 2020/7/26.
//  Copyright © 2020 kad. All rights reserved.
//

#import "TopNavTitleBar.h"

@interface TopNavTitleBar ()

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, assign) CGFloat titleSize;

@property (nonatomic, strong) NSMutableArray <UIButton *>*btns;

@property (nonatomic, weak) UIView *bottomLine;

@property (nonatomic, assign) CGFloat lineH;

@property (nonatomic, assign)  CGFloat itemW;

@end

@implementation TopNavTitleBar

-(instancetype)initWithTitles:(NSArray *)titles titleColor:(UIColor *)titleColor selectedColor:(UIColor *)selectedColor titleSize:(CGFloat)titleSize selectIndex:(NSInteger)index lineH:(CGFloat)height  frame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleColor = titleColor;
        self.selectedColor = selectedColor;
        self.titleSize = titleSize;
        self.selectedIndex = index;
        self.lineH = height;
        
        [self buildSubviews:titles frame:frame];
    }
    return self;
}

-(void)buildSubviews:(NSArray *)titles frame:(CGRect)frame{
    CGFloat viewH = frame.size.height;
    CGFloat viewW = frame.size.width;
    
    CGFloat itemH = viewH;
    CGFloat itemW = viewW / titles.count;
    self.itemW = itemW;
    CGFloat textW = 0;
    self.btns = [NSMutableArray array];
    for (int i = 0; i<titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * itemW, 0, itemW, itemH)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectedColor forState:UIControlStateSelected];
        [btn setTitleColor:self.titleColor forState:UIControlStateHighlighted];
        btn.titleLabel.font = kFont(self.titleSize);
        [btn setSelected:(i == self.selectedIndex)];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.btns addObject:btn];
        [self addSubview:btn];
        
        if (textW == 0) {
            NSDictionary *btAtt = @{NSFontAttributeName : kFont(self.titleSize)};
            CGSize btSize = [btn.titleLabel.text sizeWithAttributes:btAtt];
            textW = btSize.width;
        }
    }
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,viewH -self.lineH, textW, self.lineH)];
    bottomLine.backgroundColor = self.selectedColor;
    bottomLine.centerX = itemW * (self.selectedIndex + 0.5);
    [self addSubview:bottomLine];
    self.bottomLine = bottomLine;
    
}

-(void)clickBtn:(UIButton *)sender{
    [self.btns[self.selectedIndex] setSelected:NO];
    self.selectedIndex = sender.tag;
    [sender setSelected:YES];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.bottomLine.centerX = self.itemW * (self.selectedIndex + 0.5);
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectTitle:index:)]) {
        [self.delegate selectTitle:self index:self.selectedIndex];
    }
}

@end

