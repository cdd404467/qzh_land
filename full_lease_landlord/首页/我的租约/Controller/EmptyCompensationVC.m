//
//  EmptyCompensationVC.m
//  FullLease
//
//  Created by apple on 2020/8/24.
//  Copyright © 2020 kad. All rights reserved.
//

#import "EmptyCompensationVC.h"
#import "EmptyCompensateModel.h"

@interface EmptyCompensationVC ()
@property (nonatomic, strong)EmptyCompensateModel *dataSource;
@end

@implementation EmptyCompensationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"空置赔偿金";
    self.navBar.backBtnTintColor = UIColor.whiteColor;
    self.navBar.titleColor = UIColor.whiteColor;
    self.navBar.backgroundColor = MainColor;
    [self requestData];
}


- (void)requestData {
    NSDictionary *dict = @{@"id":_conID};
    [NetTool postRequest:URLPost_Empty_Compensate Params:dict Success:^(id  _Nonnull json) {
        if ([json[@"code"] integerValue] == 200) {
            self.dataSource = [EmptyCompensateModel mj_objectWithKeyValues:json[@"data"]];
            [self setupUI];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}


- (void)setupUI {
    UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, KFit_W(115))];
    topBgView.backgroundColor = MainColor;
    [self.view addSubview:topBgView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"房源空置进行无条件赔付";
    titleLab.font = kFont(16);
    titleLab.textColor = UIColor.whiteColor;
    [topBgView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(26));
        make.top.mas_equalTo(KFit_W(25));
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(KFit_W(22));
    }];
    
    UILabel *desLab = [[UILabel alloc] init];
    desLab.text = _dataSource.explain;
    desLab.numberOfLines = 0;
    desLab.font = kFont(13);
    desLab.textColor = UIColor.whiteColor;
    [topBgView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(titleLab);
        make.top.mas_equalTo(titleLab.mas_bottom).offset(KFit_W(10));
    }];
    [desLab.superview layoutIfNeeded];
    topBgView.height = desLab.bottom + KFit_W(18);
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(KFit_W(16),topBgView.bottom + KFit_W(16), SCREEN_WIDTH - KFit_W(32), KFit_W(120))];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.cornerRadius = 5.f;
    bgView.layer.borderColor = RGBA(0, 0, 0, 0.11).CGColor;
    bgView.layer.borderWidth = 1;
    [self.view addSubview:bgView];
    
    NSArray *titleArr = @[@"空置时长",@"应赔付金额",@"赔付状态"];
    NSArray *subtitleArr = @[[NSString stringWithFormat:@"%@天",_dataSource.saleDay],
                             [NSString stringWithFormat:@"%@元",_dataSource.amount],
                             _dataSource.statusStr
    ];
    for (NSInteger i = 0; i < 3;i++) {
        UILabel *lab = [[UILabel alloc] init];
        lab.textColor = HEXColor(@"#333333", 1);
        lab.font = kFont(13);
        lab.text = titleArr[i];
        [bgView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(KFit_W(16) * (i + 1) + KFit_W(19) * i);
            make.height.mas_equalTo(KFit_W(19));
            make.width.mas_equalTo(KFit_W(100));
        }];
        
        UILabel *rightLab = [[UILabel alloc] init];
        rightLab.textColor = HEXColor(@"#333333", 1);
        rightLab.font = kFont(13);
        rightLab.text = subtitleArr[i];
        rightLab.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:rightLab];
        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(lab);
            make.left.mas_equalTo(lab.mas_right);
        }];
    }
    
    if (_dataSource.status == 1) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = HEXColor(@"#EEEEEE", 1);
        [bgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(KFit_W(120));
            make.height.mas_equalTo(0.5);
        }];
        
        bgView.height = bgView.height + 49;
        
        UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        detailBtn.titleLabel.font = kFont(13);
        [detailBtn setTitleColor:MainColor forState:UIControlStateNormal];
        [bgView addSubview:detailBtn];
        [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KFit_W(70));
            make.height.mas_equalTo(48);
            make.centerX.mas_equalTo(bgView);
            make.bottom.mas_equalTo(0);
        }];
        
    }
}


//修改statesBar颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}
@end
