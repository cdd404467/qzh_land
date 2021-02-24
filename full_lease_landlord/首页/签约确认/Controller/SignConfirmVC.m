//
//  SignConfirmVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "SignConfirmVC.h"
#import "SignRefuseView.h"
#import "ChangePriceView.h"
#import "ContractConfirmVC.h"

@interface SignConfirmVC ()
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UILabel *priceLab;
@property (nonatomic, copy)NSString *reason;
@end

@implementation SignConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"签约确认";
    [self setupUI];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
        _scrollView.backgroundColor = UIColor.whiteColor;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    
    UIView *header = [self headerView];
    [self.scrollView addSubview:header];
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(16, header.bottom + KFit_W(15), 15, 15)];
    iconImg.image = [UIImage imageNamed:@"address_icon"];
    [self.scrollView addSubview:iconImg];
    
    UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(iconImg.right + 5, 30, 100, 21)];
    addressLab.centerY = iconImg.centerY;
    addressLab.width = _scrollView.width - addressLab.left - 12;
    addressLab.text = _model.contract.adress;
    addressLab.textColor = HEXColor(@"#1C1C1C", 1);
    addressLab.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [self.scrollView addSubview:addressLab];
    
    NSArray *dataArr = @[[NSString stringWithFormat:@"%@至%@",_model.contract.begintime,_model.contract.endtime],
                         _model.contract.recent,
                         [NSString stringWithFormat:@"%@%@",_model.contract.deposittypeStr,_model.contract.pinlvStr],
                         _model.tenant.name,
                         _model.tenant.sex == 1 ? @"男" : @"女",
                         _model.tenant.phone
    ];
    
    NSArray *titleArr = @[@"合同周期",@"月租金",@"付款周期",@"租客姓名",@"租客性别",@"租客电话"];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(iconImg.left, addressLab.bottom + 20 + (20 + 28) * i, KFit_W(70), 20)];
        lab.text = titleArr[i];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = HEXColor(@"#1C1C1C", 1);
        [self.scrollView addSubview:lab];
        
        UILabel *rightLab = [[UILabel alloc] init];
        rightLab.text = dataArr[i];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.font = [UIFont systemFontOfSize:14];
        rightLab.textColor = HEXColor(@"333333", 1);
        [self.scrollView addSubview:rightLab];
        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.mas_equalTo(lab);
            make.left.mas_equalTo(lab.mas_right).offset(5);
        }];
        
        if (i == 1) {
            _priceLab = rightLab;
            UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            changeBtn.backgroundColor = MainColor;
            [changeBtn setTitle:@"修改租金" forState:UIControlStateNormal];
            [changeBtn addTarget:self action:@selector(changePrice) forControlEvents:UIControlEventTouchUpInside];
            [changeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            changeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            changeBtn.layer.cornerRadius = 5.f;
            [self.scrollView addSubview:changeBtn];
            [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(addressLab);
                make.height.mas_equalTo(20);
                make.width.mas_equalTo(73);
                make.centerY.mas_equalTo(lab);
            }];

            [rightLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(changeBtn.mas_left).offset(-12);
            }];
        } else if (i == 5) {
            UIButton *phontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [phontBtn setImage:[UIImage imageNamed:@"phone_icon"] forState:UIControlStateNormal];
            [self.scrollView addSubview:phontBtn];
            [phontBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(addressLab);
                make.width.height.mas_equalTo(17);
                make.centerY.mas_equalTo(lab);
            }];
            
            [rightLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(phontBtn.mas_left).offset(-12);
            }];
        } else {
            [rightLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(addressLab);
            }];
        }
    }
    
    UIButton *jectBtn = [[UIButton alloc] init];
    jectBtn.tag = 12;
    [jectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [jectBtn setTitleColor:MainColor forState:UIControlStateNormal];
    jectBtn.layer.borderWidth = 1;
    jectBtn.layer.borderColor = MainColor.CGColor;
    jectBtn.layer.cornerRadius = 4;
    [self.scrollView addSubview:jectBtn];
    [jectBtn addTarget:self action:@selector(refuse:) forControlEvents:UIControlEventTouchUpInside];
    [jectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-Bottom_Height_Dif - 30);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo((SCREEN_WIDTH - 16 * 2 - 20) / 2);
        make.left.mas_equalTo(self.view.mas_left).offset(16);
    }];
    
    UIButton *agreeBtn = [[UIButton alloc] init];
    agreeBtn.tag = 11;
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    agreeBtn.backgroundColor = MainColor;
    agreeBtn.layer.cornerRadius = 4;
    [self.scrollView addSubview:agreeBtn];
    [agreeBtn addTarget:self action:@selector(agreeOrRefuse:) forControlEvents:UIControlEventTouchUpInside];
    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.width.height.centerY.mas_equalTo(jectBtn);
    }];
    
    [agreeBtn.superview layoutIfNeeded];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, agreeBtn.bottom + 30);
}

//拒绝
- (void)refuse:(UIButton *)sender {
    DDWeakSelf;
    SignRefuseView *view = [[SignRefuseView alloc] initWithCompletion:^(NSString * _Nonnull text) {
        weakself.reason = text;
        [weakself agreeOrRefuse:sender];
    }];
    [view show];
}
//修改租金
- (void)changePrice {
    DDWeakSelf;
    ChangePriceView *view = [[ChangePriceView alloc] initWithMaxPrice:@"月租金不超过当前房源租金" completion:^(NSString * _Nonnull text) {
        [weakself changeMoney:text];
//        weakself.priceLab.text = text;
    }];
    view.zujinTF.text = self.priceLab.text;
    [view show];
}

- (void)changeMoney:(NSString *)price {
    NSDictionary *dict = @{@"id":_model.contract.conID,
                           @"recent":price
    };
    [NetTool postRequest:URLPost_ChangeMoney_SignOnline Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            [CddHud showTextOnly:@"修改成功" view:self.view];
            self.priceLab.text = price;
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)agreeOrRefuse:(UIButton *)sender {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mDict setObject:_model.contract.conID forKey:@"id"];
    [mDict setObject:@(sender.tag) forKey:@"status"];
    if (sender.tag == 12) {
        [mDict setObject:_reason forKey:@"result"];
    }
    
    if (_model.contract.recent.integerValue != _priceLab.text.integerValue) {
        [mDict setObject:_priceLab.text forKey:@"price"];
    }
    [CddHud show:self.view];
    DDWeakSelf;
    [NetTool postRequest:URLPost_Land_AgreeOrRefuse Params:mDict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:self.view];
        if (JsonCode == 200) {
            if (sender.tag == 11) {
                ContractConfirmVC *vc = [[ContractConfirmVC alloc] init];
                vc.conID = self.model.contract.conID;
                [self.navigationController pushViewController:vc animated:YES];
            } else if (sender.tag == 12) {
                if (self.refuseSuccess) {
                    self.refuseSuccess();
                }
                [CddHud showTextOnly:@"已拒绝签约" view:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.navigationController popViewControllerAnimated:YES];
                });
            }
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (UIView *)headerView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(100))];
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 4.f;
    bgView.backgroundColor = MainColor;
    [view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(16));
        make.right.mas_equalTo(KFit_W(-16));
        make.height.mas_equalTo(KFit_W(55));
        make.centerY.mas_equalTo(view);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign_confirm_image"]];
    [bgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.width.mas_equalTo(KFit_W(82));
        make.height.mas_equalTo(KFit_W(80));
        make.centerY.mas_equalTo(bgView.mas_centerY).offset(-10);
    }];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.textColor = UIColor.whiteColor;
    lab.numberOfLines = 2;
    lab.font = kFont(13);
    lab.text = @"租客发起了入住签约申请，请您尽快签约确认";
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).offset(2);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(bgView);
    }];
    
    return view;
}
@end
