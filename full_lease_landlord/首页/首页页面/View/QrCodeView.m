//
//  QrCodeView.m
//  full_lease_landlord
//
//  Created by apple on 2021/1/27.
//  Copyright © 2021 apple. All rights reserved.
//

#import "QrCodeView.h"

@interface QrCodeView()
@property (nonatomic, strong)UIImageView *imageView;
@end

@implementation QrCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    _imageView = imageView;
}

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
}

@end
