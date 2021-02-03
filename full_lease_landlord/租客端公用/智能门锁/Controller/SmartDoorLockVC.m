//
//  SmartDoorLockVC.m
//  FullLease
//
//  Created by wz on 2020/11/19.
//  Copyright © 2020 kad. All rights reserved.
//

#import "SmartDoorLockVC.h"
#import "SmartDoorLockView.h"
#import "SmartDoorLockTypeView.h"
#import "LockOnlyOnePasswordViewController.h"
#import "UpdateLockPasswordVC.h"
#import "GKCycleScrollView.h"
#import "LockCycleScrollViewCell.h"
#import "LockCycleScrollGujiaCell.h"
#import "GKPageControl.h"
#import <TTLock/TTLock.h>
#import "UpdateDoorLockVC.h"
#import "SendKeyViewController.h"
#import "KeyManagerVC.h"

@interface SmartDoorLockVC ()<GKCycleScrollViewDataSource,GKCycleScrollViewDelegate,LockCycleScrollViewCellDelegate,LockCycleScrollGujiaCellDelegate>

@property (nonatomic, strong) GKCycleScrollView *cycleScrollView;

@property (nonatomic,strong) NSMutableArray<DoorLockModel *> *models;

@property (nonatomic, strong) DoorLockNumberModel *oneTimeModel;

@property (nonatomic, strong) UIImageView *holdImg;


@end

@implementation SmartDoorLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitle = @"智能门锁";
    self.view.backgroundColor = UIColorFromHex(0xFAFAFA);
    
    [self.models addObject:self.doorLockModel];
    [self createUI];
}

- (NSMutableArray *)models {
    if (!_models) {
        _models = [NSMutableArray arrayWithCapacity:0];
    }
    return _models;
}

-(UIImageView *)holdImg{
    if (!_holdImg) {
        _holdImg = [[UIImageView alloc] init];
        _holdImg.frame = CGRectMake(0, JCNAVBar_H + JCWidth(140), JCWidth(160), JCWidth(124));
        _holdImg.contentMode = UIViewContentModeScaleAspectFit;
        _holdImg.centerX = self.view.centerX;
        _holdImg.image = [UIImage imageNamed:@"no_lock"];
    }
    return _holdImg;
}

-(void)createUI{
    GKCycleScrollView *cycleScrollView = [[GKCycleScrollView alloc] init];
    cycleScrollView.dataSource = self;
    cycleScrollView.delegate = self;
    cycleScrollView.isChangeAlpha = NO;
    cycleScrollView.isAutoScroll = NO;
    cycleScrollView.isInfiniteLoop = NO;
    cycleScrollView.leftRightMargin = 0.0f;
    cycleScrollView.topBottomMargin = 0.0f;
    cycleScrollView.userInteractionEnabled = YES;
    [self.view addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(0);
        make.top.mas_equalTo(JCNAVBar_H);
        make.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(JCWIDTH);
    }];
    [cycleScrollView reloadData];
  
}

-(void)clickOneTimePasswordWithIndex:(NSInteger)index{
    DoorLockModel *model = self.models[index];
    NSDictionary *dic = @{
        @"lockId":model.lockId
    };
    
    DDWeakSelf;
    [CddHud show:self.view];
    NSDictionary *headerDict = @{@"Authorization":DoorToken};
    [NetTool postRequestWithHeader:headerDict requestUrl:@"member/smartDevices/getOneTime" Params:dic Success:^(id  _Nonnull json) {
        [CddHud hideHUD:self.view];
        if (JsonCode == 200) {
            weakself.oneTimeModel = [DoorLockNumberModel mj_objectWithKeyValues:json[@"data"][@"numberData"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                LockOnlyOnePasswordViewController *vc = [[LockOnlyOnePasswordViewController alloc] init];
                vc.oneTimeModel = weakself.oneTimeModel;
                [weakself.navigationController pushViewController:vc animated:YES];
            });
        } 
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}


-(void)clickSendKeyWithIndex:(NSInteger)index{
    DoorLockModel *model = self.models[index];
    
    SendKeyViewController *sendKeyCtr = [[SendKeyViewController alloc] init];
    sendKeyCtr.model = model;
    [self.navigationController pushViewController:sendKeyCtr animated:YES];
    
}

-(void)clickKeyManagerWithIndex:(NSInteger)index{
    DoorLockModel *model = self.models[index];
    
    KeyManagerVC *keyMgrVc = [[KeyManagerVC alloc] init];
    keyMgrVc.lockId = model.lockId;
    [self.navigationController pushViewController:keyMgrVc animated:YES];
}

#pragma mark - GKCycleScrollViewDataSource
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return 1;//self.models.count
}

- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    DoorLockModel *model = self.models[index];
//
    GKCycleScrollViewCell *cell = [cycleScrollView dequeueReusableCell];
    if (cell == nil) {
//
//        if ([model.lockType isEqualToString:@"guojia"]) {
//            cell = [LockCycleScrollGujiaCell new];
//        }else{
            cell = [LockCycleScrollViewCell new];
//        }
    }
//
//    if ([cell isKindOfClass:[LockCycleScrollViewCell class]]) {
        LockCycleScrollViewCell  *lockCell = (LockCycleScrollViewCell *)cell;
        lockCell.delegate = self;
        [lockCell refreshModel:model index:index];
//    }else if([cell isKindOfClass:[LockCycleScrollGujiaCell class]]){
//        LockCycleScrollGujiaCell  *lockCell = (LockCycleScrollGujiaCell *)cell;
//        lockCell.delegate = self;
//        [lockCell refreshModel:model index:index];
//    }
        
    return cell;
}

#pragma mark - GKCycleScrollViewDelegate
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
   
    return CGSizeMake(cycleScrollView.width, cycleScrollView.height);
}

@end
