//
//  SmartDoorLockView.m
//  FullLease
//
//  Created by wz on 2020/11/19.
//  Copyright © 2020 kad. All rights reserved.
//

#import "SmartDoorLockView.h"
#import "ListInfoBaseCell.h"
#import <TTLock/TTLock.h>
#import "ECAlert.h"
#import "ECPrivacyCheckBluetooth.h"

typedef void(^blueStatusBlock)(bool isCan);

@interface SmartDoorLockView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) UILabel *lockName;
@property (nonatomic, weak) UILabel *electricityLab;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UIImageView *lockImgLoading;
@property (nonatomic, strong) UIButton *doorLockBtn;

@property (nonatomic, strong) ECPrivacyCheckBluetooth *bluetoohTools;

@end

@implementation SmartDoorLockView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}


-(void)setupViews{
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UIImageView *backImg = [[UIImageView alloc] init];
    backImg.image = [UIImage imageNamed:@"lock_back"];
    backImg.userInteractionEnabled = YES;
    [backView addSubview:backImg];
    [backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.top.mas_equalTo(backView);
        make.height.mas_equalTo(JCWidth(245));
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"远洋悦庭58单元1102室";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = UIColorFromHex(0xFFFFFF);
    titleLab.font = kFont(16);
    [backImg addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(backImg);
        make.top.mas_equalTo(backImg).offset(JCWidth(52));
    }];
    self.titleLab = titleLab;
    
    UILabel *lockName = [[UILabel alloc] init];
    lockName.text = @"外门锁";
    lockName.textColor = UIColor.whiteColor;
    lockName.font = kFont(14);
    lockName.textAlignment = NSTextAlignmentCenter;
    [backImg addSubview:lockName];
    [lockName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).offset(14);
        make.left.right.mas_equalTo(backImg);
    }];
    self.lockName = lockName;
    
    UILabel *electricityLab = [[UILabel alloc] init];
    electricityLab.text = @"电量：--";
    electricityLab.textColor = UIColor.whiteColor;
    electricityLab.textAlignment = NSTextAlignmentCenter;
    electricityLab.font = kFont(14);
    [backImg addSubview:electricityLab];
    [electricityLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lockName.mas_bottom).offset(10);
        make.left.right.mas_equalTo(backImg);
    }];
    self.electricityLab = electricityLab;
    
    UIButton *doorLockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doorLockBtn setImage:[UIImage imageNamed:@"lock_un"] forState:UIControlStateNormal];
    [doorLockBtn setImage:[UIImage imageNamed:@"lock_open"] forState:UIControlStateSelected];
    doorLockBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backView addSubview:doorLockBtn];
    [doorLockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(backView);
        make.centerY.mas_equalTo(backImg.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(JCWidth(120), JCWidth(120)));
    }];
    [doorLockBtn addTarget:self action:@selector(clickDoorLock) forControlEvents:UIControlEventTouchUpInside];
    self.doorLockBtn = doorLockBtn;
    
    [doorLockBtn addSubview:self.lockImgLoading];
    [self.lockImgLoading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(doorLockBtn);
        make.size.equalTo(doorLockBtn).sizeOffset(CGSizeMake(-18, -18));
    }];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.toValue = [NSNumber numberWithFloat:0.f];
    animation.fromValue= [NSNumber numberWithFloat: M_PI *2];
    animation.duration = 1.0;
    animation.removedOnCompletion = NO;
//    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeBackwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.lockImgLoading.layer addAnimation:animation forKey:nil];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"ListInfoBaseCell" bundle:nil] forCellReuseIdentifier:@"ListInfoBaseCell"];
    [backView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(doorLockBtn.mas_bottom).offset(JCWidth(38));
        make.left.mas_equalTo(backView);
        make.right.mas_equalTo(backView);
        make.bottom.mas_equalTo(backView.mas_bottom).offset(-JCWidth(48));
    }];
    self.tableView = tableView;
}

-(UIImageView *)lockImgLoading{
    if (!_lockImgLoading) {
        _lockImgLoading = [[UIImageView alloc] init];
        _lockImgLoading.image = [UIImage imageNamed:@"lock_load"];
        _lockImgLoading.hidden = YES;
    }
    return _lockImgLoading;
}

-(void)clickDoorLock{
    DDWeakSelf;
    [self checkBluetooth:^(bool isCan) {
        if (isCan) {
            /*开锁*/
            if (!weakself.lockImgLoading.hidden || weakself.doorLockBtn.selected) {
                return;
            }
            weakself.lockImgLoading.hidden = NO;
            [TTLock controlLockWithControlAction:TTControlActionUnlock lockData:weakself.model.bluetooth.lockData success:^(long long lockTime, NSInteger electricQuantity, long long uniqueId) {
                weakself.lockImgLoading.hidden = YES;
                [weakself.doorLockBtn setSelected:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself uploadRecord];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.doorLockBtn setSelected:NO];
                });
                [CddHud showTextOnly:@"开锁成功" view:self];
                } failure:^(TTError errorCode, NSString *errorMsg) {
                    weakself.lockImgLoading.hidden = YES;
                [CddHud showTextOnly:@"开锁失败" view:self];
            }];
        }
    }];
}

- (void)uploadRecord {
    DDWeakSelf;
    [TTLock getOperationLogWithType:TTOperateLogTypeLatest lockData:self.model.bluetooth.lockData success:^(NSString *operateRecord) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"lockId"] = weakself.model.lockId;
        dic[@"records"] = operateRecord;
        NSString *toke = DoorToken;
        if (toke.length < 2) {
            return;
        }
        NSDictionary *headerDict = @{@"Authorization":toke};
        [NetTool postRequestWithHeader:headerDict requestUrl:@"member/smartDevices/lockRecordUpload" Params:dic Success:^(id  _Nonnull json) {
//            if (JsonCode == 200) {
//            [CddHud showTextOnly:json[@"message"] view:self];
//            }
        } Failure:^(NSError * _Nonnull error) {
            
        }];
    } failure:^(TTError errorCode, NSString *errorMsg) {
        
    }];
}




- (void)checkBluetooth:(blueStatusBlock)block{
    // 这里要用全局属性
    self.bluetoohTools = [[ECPrivacyCheckBluetooth alloc] init];
    
    [self.bluetoohTools requestBluetoothAuthorizationWithCompletionHandler:^(ECCBAuthorizationState state) {
        if (state == ECCBAuthorizationStatePoweredOn) {
            block(YES);
        } else if (state == ECCBAuthorizationStatePoweredOff) {
//            ECAlertShow(@"蓝牙状态", @"关闭", @"确定", nil);
            block(NO);
        } else if (state == ECCBAuthorizationStateUnauthorized) {
//            ECAlertShow(@"蓝牙状态", @"未授权", @"确定", nil);
            block(NO);
        } else if (state == ECCBAuthorizationStateUnsupported) {
//            ECAlertShow(@"蓝牙状态", @"不支持蓝牙", @"确定", nil);
            block(NO);
        } else if (state == ECCBAuthorizationStateResetting) {
//            ECAlertShow(@"蓝牙状态", @"正在重置，与系统服务暂时丢失", @"确定", nil);
            block(NO);
        } else {
//            ECAlertShow(@"蓝牙状态", @"未知状态", @"确定", nil);
            block(NO);
        }
    }];
}

-(void)setModel:(DoorLockModel *)model{
    _model = model;
    
    self.titleLab.text = model.doorAddress;
    self.lockName.text = model.frontDoor == 1?@"外门锁":@"内门锁";
    self.electricityLab.text = [[NSString stringWithFormat:@"电量: %@",model.bluetooth.electricQuantity?:@"--"] stringByAppendingString:@"%"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.model.bluetooth.keyRight isEqualToString:@"1"]?3:1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListInfoBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListInfoBaseCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.showBottomLine = YES;
    ListInfoBaseModel *model = [[ListInfoBaseModel alloc] init];
    model.title = indexPath.row==0?@"获取一次性密码":indexPath.row==1?@"发送钥匙":@"钥匙管理";
    model.type = ListInfoItemArrowType;
    [cell refreshCellWithMode:model andRow:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return JCWidth(58);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        if (self.oneTimePWD) {
            self.oneTimePWD();
        }
    }
    if (indexPath.row == 1) {
        if (self.sendKey) {
            self.sendKey();
        }
    }
    
    if (indexPath.row ==2) {
        if (self.keyManager) {
            self.keyManager();
        }
    }
}

@end
