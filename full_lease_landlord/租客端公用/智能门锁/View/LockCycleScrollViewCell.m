//
//  LockCycleScrollViewCell.m
//  FullLease
//
//  Created by wz on 2020/11/19.
//  Copyright © 2020 kad. All rights reserved.
//

#import "LockCycleScrollViewCell.h"

@implementation LockCycleScrollViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.smartDoorLockView];
        self.imageView.userInteractionEnabled = YES;
        [self.smartDoorLockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

-(void)setModel:(DoorLockModel *)model{
    _model = model;
    
}

-(SmartDoorLockView *)smartDoorLockView{
    if (!_smartDoorLockView) {
        _smartDoorLockView = [[SmartDoorLockView alloc] initWithFrame:CGRectZero];
        DDWeakSelf;
        _smartDoorLockView.oneTimePWD = ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(clickOneTimePasswordWithIndex:)]) {
                [weakself.delegate clickOneTimePasswordWithIndex:weakself.index];
            }
        };
        
        _smartDoorLockView.sendKey = ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(clickSendKeyWithIndex:)]) {
                [weakself.delegate clickSendKeyWithIndex:weakself.index];
            }
        };
        
        _smartDoorLockView.keyManager = ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(clickKeyManagerWithIndex:)]) {
                [weakself.delegate clickKeyManagerWithIndex:weakself.index];
            }
        };
    }
    return _smartDoorLockView;
}

-(void)refreshModel:(DoorLockModel *)model index:(NSInteger)index{
    self.model = model;
    self.index = index;
    _smartDoorLockView.model = model;
}

@end
