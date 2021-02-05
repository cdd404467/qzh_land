//
//  LeaseContractDetailVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/29.
//  Copyright © 2020 apple. All rights reserved.
//

#import "LeaseContractDetailVC.h"
#import "ContractModel.h"
#import "ContactManagerVC.h"
#import "OwnerIfonVC.h"
#import "LeaseBillVC.h"
#import "PreviewConVC.h"

@interface LeaseContractDetailVC ()
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation LeaseContractDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXColor(@"#f8f8f8", 1);
    self.navTitle = @"租客详情";
    [self requestData];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    }
    return _scrollView;
}

- (void)jumpIndex:(NSInteger)index {
    if (index == 0) {
        OwnerIfonVC *vc = [[OwnerIfonVC alloc] init];
        vc.conID = _conID;
        vc.type = 2;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 1) {
        LeaseBillVC *vc = [[LeaseBillVC alloc] init];
        vc.conID = _conID;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        PreviewConVC *vc = [[PreviewConVC alloc] init];
        vc.conID = _conID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_ZuKeCon_Detail,_conID];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            ContractModel *model = [ContractModel mj_objectWithKeyValues:json[@"data"]];
            model.totherfeeDTOSOneList = [OtherChargeModel mj_objectArrayWithKeyValuesArray:model.totherfeeDTOSOneList];
            model.totherfeeDTOSTwoList = [OtherChargeModel mj_objectArrayWithKeyValuesArray:model.totherfeeDTOSTwoList];
            [self setupUI:model];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}
 
- (void)setupUI:(ContractModel *)model {
    [self.view addSubview:self.scrollView];
    CGFloat height = 0;
    LeaseConDetailTopView *topView = [[LeaseConDetailTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(116))];
    topView.backgroundColor = HEXColor(@"#F5F5F5", 1);
    DDWeakSelf;
    topView.tapClick = ^(NSInteger index) {
        [weakself jumpIndex:index];
    };
    [self.scrollView addSubview:topView];
    
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom + KFit_W(16), SCREEN_WIDTH, 200)];
    bottomBgView.backgroundColor = topView.backgroundColor;
    [self.scrollView addSubview:bottomBgView];
    
    NSArray *titleArr = @[RightDataSafe(model.adress),@"合同周期",@"月租金",@"付款频率",@"常规押金"];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UILabel *lab = [[UILabel alloc] init];
        lab.font = kFont(14);
        lab.text = titleArr[i];
        lab.textColor = HEXColor(@"#1C1C1C", 1);
        [bottomBgView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KFit_W(22));
            make.top.mas_equalTo(KFit_W(12) + KFit_W(20 + 25) * i);
            make.height.mas_equalTo(KFit_W(20));
            if (i == 0) {
                make.right.mas_equalTo(KFit_H(-80));
            }
        }];

        UILabel *rightLab = [[UILabel alloc] init];
        rightLab.font = kFont(14);
        rightLab.textColor = HEXColor(@"#333333", 1);
        rightLab.textAlignment = NSTextAlignmentRight;
        [bottomBgView addSubview:rightLab];
        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.mas_equalTo(lab);
            make.right.mas_equalTo(KFit_W(-22));
        }];
        if (i == 0) {
            [self configState:rightLab model:model];
        } else if (i == 1) {
            rightLab.text = [NSString stringWithFormat:@"%@到%@",model.begintime,model.endtime];
        } else if (i == 2){
            rightLab.text = model.recent;
        } else if (i == 3){
            rightLab.text = [NSString stringWithFormat:@"%@%@",model.deposittypeStr,model.pinlvStr];
        } else {
            rightLab.text = model.deposit;
            [rightLab.superview layoutIfNeeded];
            height = rightLab.bottom;
        }
    }
    
    //其他押金
    if (model.totherfeeDTOSOneList.count > 0) {
        UILabel *otherYajin = [[UILabel alloc] init];
        otherYajin.font = kFont(16);
        otherYajin.text = @"其他押金";
        otherYajin.textColor = HEXColor(@"#262626", 1);
        [bottomBgView addSubview:otherYajin];
        [otherYajin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KFit_W(22));
            make.height.mas_equalTo(KFit_W(22));
            make.top.mas_equalTo(height + KFit_W(32));
        }];
        [otherYajin.superview layoutIfNeeded];
        for (NSInteger i = 0; i < model.totherfeeDTOSOneList.count;i++) {
            OtherChargeModel *model_1 = model.totherfeeDTOSOneList[i];
            UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(otherYajin.left, otherYajin.bottom + 10 * (i + 1) + 20 * i, KFit_W(100), 20)];
            leftLab.textColor = HEXColor(@"333333", 0.8);
            leftLab.font = kFont(14);
            leftLab.text = model_1.name;
            [bottomBgView addSubview:leftLab];
            
            UILabel *rightLab = [[UILabel alloc] init];
            rightLab.text = model_1.amount;
            rightLab.textColor = HEXColor(@"333333", 1);
            rightLab.textAlignment = NSTextAlignmentRight;
            rightLab.font = kFont(14);
            [bottomBgView addSubview:rightLab];
            [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(leftLab);
                make.right.mas_equalTo(KFit_W(-22));
            }];
            
            if (i == model.totherfeeDTOSOneList.count - 1) {
                height = leftLab.bottom;
            }
        }
    }

    //加收费用
    if (model.totherfeeDTOSTwoList.count > 0) {
        UILabel *addCharge = [[UILabel alloc] init];
        addCharge.font = kFont(16);
        addCharge.text = @"加收费用";
        addCharge.textColor = HEXColor(@"#262626", 1);
        [bottomBgView addSubview:addCharge];
        [addCharge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KFit_W(22));
            make.height.mas_equalTo(KFit_W(22));
            make.top.mas_equalTo(height + KFit_W(32));
        }];
        [addCharge.superview layoutIfNeeded];
        for (NSInteger i = 0; i < model.totherfeeDTOSTwoList.count;i++) {
            OtherChargeModel *model_2 = model.totherfeeDTOSTwoList[i];
            UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(addCharge.left, addCharge.bottom + 10 * (i + 1) + 20 * i, KFit_W(100), 20)];
            leftLab.textColor = HEXColor(@"333333", 0.8);
            leftLab.font = kFont(14);
            leftLab.text = model_2.name;
            [bottomBgView addSubview:leftLab];
            
            UILabel *rightLab = [[UILabel alloc] init];
            rightLab.text = model_2.amount;
            rightLab.textColor = HEXColor(@"333333", 1);
            rightLab.textAlignment = NSTextAlignmentRight;
            rightLab.font = kFont(14);
            [bottomBgView addSubview:rightLab];
            [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(leftLab);
                make.right.mas_equalTo(KFit_W(-22));
            }];
            
            if (i == model.totherfeeDTOSTwoList.count - 1) {
                height = leftLab.bottom;
            }
        }
    }
    
   
    
    UIButton *contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contactBtn.layer.cornerRadius = 5.f;
    contactBtn.backgroundColor = MainColor;
    [contactBtn setTitle:@"联系管家" forState:UIControlStateNormal];
    [contactBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [contactBtn addTarget:self action:@selector(jumpToContactManager) forControlEvents:UIControlEventTouchUpInside];
    contactBtn.titleLabel.font = kFont(14);
    [bottomBgView addSubview:contactBtn];
    [contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KFit_W(-16));
        make.left.mas_equalTo(KFit_W(16));
        make.height.mas_equalTo(KFit_W(44));
        make.top.mas_equalTo(height + 85);
    }];
    
    [contactBtn.superview layoutIfNeeded];
    height = contactBtn.bottom;
    
    bottomBgView.height = height + 30;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, bottomBgView.bottom + TABBAR_HEIGHT);
}

- (void)jumpToContactManager {
    ContactManagerVC *vc = [[ContactManagerVC alloc] init];
    vc.conID = _conID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configState:(UILabel *)lab model:(ContractModel *)model {
    //1-待签约 4-待搬入5在租 6逾期 7已退租8 作废 9 退租审批中 10 退租未结账 2-续租在租
    NSString *title = [NSString string];
    UIColor *color = MainColor;
    if (model.status == 1) {
        title = @"待签约";
        color = HEXColor(@"#FFA200", 1);
    } else if (model.status == 2) {
        title = @"续租在租";
    } else if (model.status == 4) {
        title = @"待搬入";
    } else if (model.status == 5) {
        title = @"在租中";
    } else if (model.status == 6) {
        title = @"逾期";
    } else if (model.status == 7) {
        title = @"已退租";
        color = HEXColor(@"#BBBABB", 1);
    } else if (model.status == 8) {
        title = @"作废";
    } else if (model.status == 13) {
        title = @"退租审核中";
    } else if (model.status == 10) {
        title = @"退租未结账";
    } else {
        title = @"- -!";
        color = MainColor;
    }
    lab.text = title;
    lab.textColor = color;
}

@end


@implementation LeaseConDetailTopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    
    //,@"退租信息"
    NSArray *titleArr = @[@"租客信息",@"账单信息",@"下载电子合同"];
    NSArray *iconArr = @[@"zuyue_icon_download_con",@"zuyue_icon_info",@"zuyue_icon_order"];
    //,@"zuyue_icon_empty"
    CGFloat width = KFit_W(48);
    CGFloat leftGap = KFit_W(40);
    CGFloat centerGap = (SCREEN_WIDTH - leftGap * 2 - width * titleArr.count) / (titleArr.count - 1);
    for (NSInteger i = 0;i < titleArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.cornerRadius = width / 2;
        imageView.clipsToBounds = YES;
        imageView.image = [UIImage imageNamed:iconArr[i]];
        imageView.tag = i;
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftGap + i * (width + centerGap));
            make.width.height.mas_equalTo(width);
            make.top.mas_equalTo(22);
        }];
        [HelperTool addTapGesture:imageView withTarget:self andSEL:@selector(tapView:)];
        
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.text = titleArr[i];
        nameLab.textColor = HEXColor(@"#262626", 1);
        nameLab.font = kFont(13);
        nameLab.numberOfLines = 2;
        nameLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:nameLab];
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imageView);
            make.top.mas_equalTo(imageView.mas_bottom).offset(9);
        }];
        
        
    }
}

- (void)tapView:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIImageView *tapView = (UIImageView *)tap.view;
    if (self.tapClick) {
        self.tapClick(tapView.tag);
    }
}

@end


