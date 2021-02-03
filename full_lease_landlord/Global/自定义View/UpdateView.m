//
//  UpdateView.m
//  FullLease
//
//  Created by apple on 2020/8/20.
//  Copyright © 2020 kad. All rights reserved.
//

#import "UpdateView.h"
#import "UIView+Border.h"
#import <YYText.h>

static CGFloat aniTime = 0.4;


@interface UpdateView()
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)YYLabel *contentLab;
@property (nonatomic, strong)UILabel *versionLab;
@property (nonatomic, strong)UIButton *jumpBtn;
@property (nonatomic, strong)UIButton *updateBtn;
@property (nonatomic, strong)UIImageView *bgImageView;
@end

@implementation UpdateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    self.frame = SCREEN_BOUNDS;
    
    CGFloat imageWidth = KFit_W(280);
    CGFloat imageHeight = KFit_W(310);
    
    CGFloat bgViewHeight = imageHeight + 65;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = RGBA(0, 0, 0, 0);
    bgView.frame = CGRectMake((SCREEN_WIDTH - imageWidth) / 2, SCREEN_HEIGHT + bgViewHeight, imageWidth, bgViewHeight);
    [self addSubview:bgView];
    
    //背景图
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
    bgImageView.userInteractionEnabled = YES;
    bgImageView.image = [UIImage imageNamed:@"update_bgImage"];
    [bgView addSubview:bgImageView];
    _bgImageView = bgImageView;
    
    //版本
    UILabel *versionLab = [[UILabel alloc] init];
    versionLab.font = kFont(20);
    versionLab.textColor = UIColor.whiteColor;
//    versionLab.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:versionLab];
    [versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(20));
        make.width.mas_equalTo(KFit_W(185));
        make.top.mas_equalTo(KFit_W(60));
        make.height.mas_equalTo(KFit_W(28));
    }];
    _versionLab = versionLab;
    
    //scrollView
    [bgImageView addSubview:self.scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(16));
        make.right.mas_equalTo(KFit_W(-16));
        make.top.mas_equalTo(KFit_W(135));
        make.bottom.mas_equalTo(-50);
    }];
    
    YYLabel *contentLab = [[YYLabel alloc] init];
    contentLab.frame = CGRectMake(0, 10, imageWidth - KFit_W(34), 100);
    contentLab.numberOfLines = 0;
    [_scrollView addSubview:contentLab];
    _contentLab = contentLab;
    
    //跳过
    UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [jumpBtn setImage:[UIImage imageNamed:@"update_close"] forState:UIControlStateNormal];
    [jumpBtn addTarget:self action:@selector(removeSignView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:jumpBtn];
    [jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgImageView.mas_bottom).offset(42);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerX.mas_equalTo(bgView);
    }];
    _jumpBtn = jumpBtn;
    
    //更新
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    [updateBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    updateBtn.titleLabel.font = kFont(15);
    updateBtn.layer.cornerRadius = 15;
    updateBtn.backgroundColor = HEXColor(@"#2F67C7", 1);
    [updateBtn addTarget:self action:@selector(checkVersionUpdata) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:updateBtn];
    [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KFit_W(180));
        make.height.mas_equalTo(35);
        make.bottom.mas_equalTo(-12);
        make.centerX.mas_equalTo(bgImageView);
    }];
    _updateBtn = updateBtn;
    
    
    
    [UIView animateWithDuration:aniTime animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.6);
        bgView.center = self.center;
    }];
}

- (void)setVersion:(NSString *)version {
    _version = version;
    _versionLab.text = [NSString stringWithFormat:@"V %@",version];
}

- (void)setUpdateType:(NSInteger)updateType {
    _updateType = updateType;
    if (updateType == 2) {
        _jumpBtn.hidden = YES;
    }
}

- (void)setContent:(NSString *)content {
    _content = content;
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:content];
    attText.yy_font = [UIFont systemFontOfSize:12];
    attText.yy_lineSpacing = 5;
    attText.yy_color = HEXColor(@"666666", 1);
    _contentLab.attributedText = attText;
    CGSize introSize = CGSizeMake(_contentLab.width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:attText];
    _contentLab.textLayout = layout;
    CGFloat introHeight = layout.textBoundingSize.height;
    _contentLab.height = introHeight + 5;
    _scrollView.contentSize = CGSizeMake(KFit_W(265) - KFit_W(32), _contentLab.bottom);
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.scrollEnabled = YES;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (void)checkVersionUpdata {
    if (!_url || _url.length < 20) {
        _url = @"https://apps.apple.com/cn/app/%E5%85%A8%E4%BD%8F%E4%BC%9A%E4%B8%9A%E4%B8%BB/id1535423835";
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url] options:@{} completionHandler:nil];
}

//移除视图
- (void)removeSignView {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
//    if (self.closeClickBlock) {
//        self.closeClickBlock();
//    }
}
@end
