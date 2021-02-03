//
//  ContactManagerVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/27.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ContactManagerVC.h"
#import "ManagerInfoModel.h"

@interface ContactManagerVC ()
@property (nonatomic, strong)ManagerInfoModel *dataSource;
@end

@implementation ContactManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"联系管家";
    [self requestData];
    [self setupUI];
}

- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_Check_ManagerInfo,_conID];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            self.dataSource = [ManagerInfoModel mj_objectWithKeyValues:json[@"data"]];
            [self setupUI];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(KFit_W(16), NAV_HEIGHT + 10, SCREEN_WIDTH - KFit_W(32), KFit_W(175))];
    bgView.layer.cornerRadius = 4.f;
    bgView.layer.borderColor = HEXColor(@"#E9E8E8", 1).CGColor;
    bgView.layer.borderWidth = 0.5f;
    [self.view addSubview:bgView];
    
    UIImageView *headerImg = [[UIImageView alloc] init];
    headerImg.image = [UIImage imageNamed:@"default_user_photo"];
    [headerImg sd_setImageWithURL:[NSURL URLWithString:_dataSource.keeperAvatar] placeholderImage:[UIImage imageNamed:@"default_user_photo"]];
    headerImg.layer.cornerRadius = KFit_W(44) / 2;
    headerImg.clipsToBounds = YES;
    headerImg.layer.borderColor = HEXColor(@"#BBBABB", 1).CGColor;
    headerImg.layer.borderWidth = 0.5f;
    [bgView addSubview:headerImg];
    [headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(20));
        make.top.mas_equalTo(KFit_W(48));
        make.width.height.mas_equalTo(KFit_W(44));
    }];
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.font = kFont(14);
    nameLab.text = _dataSource.realname;
    nameLab.textColor = HEXColor(@"#333333", 1);
    [bgView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerImg.mas_right).offset(10);
        make.top.mas_equalTo(headerImg);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *phoneLab = [[UILabel alloc] init];
    phoneLab.text = _dataSource.mobile;
    phoneLab.font = kFont(13);
    phoneLab.textColor = HEXColor(@"999999", 1);
    [bgView addSubview:phoneLab];
    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(nameLab);
        make.bottom.mas_equalTo(headerImg);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"manager_bg_photo"];
    [bgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-9);
        make.top.mas_equalTo(KFit_W(28));
        make.width.mas_equalTo(KFit_W(129));
        make.height.mas_equalTo(KFit_W(81));
    }];
    
    UIButton *contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contactBtn.backgroundColor = MainColor;
    [contactBtn setTitle:@"联系管家" forState:UIControlStateNormal];
    [contactBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [contactBtn addTarget:self action:@selector(callManager) forControlEvents:UIControlEventTouchUpInside];
    contactBtn.titleLabel.font = kFont(18);
    contactBtn.layer.cornerRadius = 4.f;
    [bgView addSubview:contactBtn];
    [contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
}

- (void)callManager {
    Phone_Call(_dataSource.mobile);
}
@end
