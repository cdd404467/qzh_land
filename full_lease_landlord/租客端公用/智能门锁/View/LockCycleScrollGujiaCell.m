//
//  LockCycleScrollGujiaCell.m
//  FullLease
//
//  Created by wz on 2020/11/23.
//  Copyright © 2020 kad. All rights reserved.
//

#import "LockCycleScrollGujiaCell.h"
#import "SmartDoorLockTypeView.h"

@implementation LockCycleScrollGujiaCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.smartDoorLockTypeView];
        self.imageView.userInteractionEnabled = YES;
        [self.smartDoorLockTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

-(void)setModel:(DoorLockModel *)model{
    _model = model;
    
}

-(SmartDoorLockTypeView *)smartDoorLockTypeView{
    if (!_smartDoorLockTypeView) {
        _smartDoorLockTypeView = [[SmartDoorLockTypeView alloc] initWithFrame:CGRectZero];
        DDWeakSelf;
        _smartDoorLockTypeView.oneTimePWD = ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(clickOneTimePasswordWithIndex:)]) {
                [weakself.delegate clickOneTimePasswordWithIndex:weakself.index];
            }
        };
        
        _smartDoorLockTypeView.updatePWD = ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(clickUpdatePasswordWithIndex:)]) {
                [weakself.delegate clickUpdatePasswordWithIndex:weakself.index];
            }
        };
    }
    return _smartDoorLockTypeView;
}

-(void)refreshModel:(DoorLockModel *)model index:(NSInteger)index{
    self.model = model;
    self.index = index;
    _smartDoorLockTypeView.model = model;
}


@end
