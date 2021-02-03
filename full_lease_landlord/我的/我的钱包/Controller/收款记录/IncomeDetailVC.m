//
//  IncomeDetailVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/27.
//  Copyright © 2020 apple. All rights reserved.
//

#import "IncomeDetailVC.h"
#import "SelectView.h"
#import "IncomeModel.h"

@interface IncomeDetailVC ()
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)IncomeDetailModel *dataSource;
@end

@implementation IncomeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"详情";
    self.view.backgroundColor = HEXColor(@"#f5f5f5", 1);
    self.navBar.titleColor = UIColor.whiteColor;
    self.navBar.backgroundColor = MainColor;
    self.navBar.backBtnTintColor = UIColor.whiteColor;
    [self requestData];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    }
    return _scrollView;
}


- (void)requestData {
    
    NSDictionary *dict = @{@"id":_incomeID,
                           @"tfinanceSource":@2
    };
    [NetTool postRequest:URLPost_Income_Detail Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            self.dataSource = [IncomeDetailModel mj_objectWithKeyValues:json[@"data"]];
            self.dataSource.orderDetailDTOList = [orderDetailDTOListModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [self setupUI];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}


- (void)setupUI {
    [self.view addSubview:self.scrollView];
    CGFloat height = 0;
    UIView *topBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(109))];
    topBg.backgroundColor = MainColor;
    [self.scrollView addSubview:topBg];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(16, KFit_W(12), SCREEN_WIDTH - 32, 400)];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.cornerRadius = 4.f;
    [self.scrollView addSubview:bgView];
    
    UILabel *txtLab = [[UILabel alloc] init];
    txtLab.text = @"交易完成";
    txtLab.textAlignment = NSTextAlignmentCenter;
    txtLab.font = kFont(12);
    txtLab.textColor = HEXColor(@"999999", 1);
    [bgView addSubview:txtLab];
    [txtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(KFit_W(16));
        make.top.mas_equalTo(KFit_W(41));
    }];
    
    UILabel *moneyLab = [[UILabel alloc] init];
    moneyLab.text = self.dataSource.orderAmount;
    moneyLab.textAlignment = NSTextAlignmentCenter;
    moneyLab.textColor = HEXColor(@"333333", 1);
    moneyLab.font = kFont(34);
    [bgView addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(txtLab);
        make.top.mas_equalTo(txtLab.mas_bottom).offset(5);
        make.height.mas_equalTo(KFit_W(47));
    }];
    
    UILabel *numLab = [[UILabel alloc] init];
    numLab.text = self.dataSource.title;
    numLab.textColor = HEXColor(@"333333", 1);
    numLab.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [bgView addSubview:numLab];
    [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.height.mas_equalTo(21);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(moneyLab.mas_bottom).offset(KFit_W(54));
    }];
    
    SelectView *zukeCon = [[SelectView alloc] init];
    zukeCon.textLab.text = @"租客租约";
    [bgView addSubview:zukeCon];
    [zukeCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.width.mas_equalTo(KFit_W(75));
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(numLab.mas_bottom).offset(10);
    }];
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.text = self.dataSource.adress;
    addressLab.textColor = HEXColor(@"333333", 1);
    addressLab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:addressLab];
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(numLab);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(numLab.mas_bottom).offset(10);
        make.right.mas_equalTo(zukeCon.mas_left).offset(-2);
    }];
    
    UIView *line_1 = [[UIView alloc] init];
    line_1.backgroundColor = HEXColor(@"eeeeee", 1);
    [bgView addSubview:line_1];
    [line_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(numLab);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(addressLab.mas_bottom).offset(14);
    }];
    
    [line_1.superview layoutIfNeeded];
    height = line_1.bottom;
    
    if (self.dataSource.orderDetailDTOList.count > 0) {
        UILabel *orderTxtLab = [[UILabel alloc] init];
        orderTxtLab.text = @"账单明细";
        orderTxtLab.textColor = HEXColor(@"333333", 1);
        orderTxtLab.font = numLab.font;
        [bgView addSubview:orderTxtLab];
        [orderTxtLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.mas_equalTo(numLab);
            make.top.mas_equalTo(height + 20);
        }];
        
        for (NSInteger i = 0; i < self.dataSource.orderDetailDTOList.count; i++) {
            orderDetailDTOListModel *model = self.dataSource.orderDetailDTOList[i];
            IncomeDetailTxtView *zujinView = [[IncomeDetailTxtView alloc] init];
            zujinView.leftLab.text = model.costname;
            zujinView.rightLab.text = model.financeAmount;
            [bgView addSubview:zujinView];
            [zujinView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(orderTxtLab);
                make.height.mas_equalTo(20);
                make.top.mas_equalTo(height + 12);
            }];
            [zujinView.superview layoutIfNeeded];
            height = zujinView.bottom;
            
            if (i == self.dataSource.orderDetailDTOList.count - 1) {
                UIView *line_2 = [[UIView alloc] init];
                line_2.backgroundColor = HEXColor(@"eeeeee", 1);
                [bgView addSubview:line_2];
                [line_2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.height.mas_equalTo(line_1);
                    make.top.mas_equalTo(height + 14);
                }];
                [line_2.superview layoutIfNeeded];
                height = line_2.bottom;
            }
        }
    }
    
    UILabel *otherTxtLab = [[UILabel alloc] init];
    otherTxtLab.text = @"其他信息";
    otherTxtLab.textColor = HEXColor(@"333333", 1);
    otherTxtLab.font = numLab.font;
    [bgView addSubview:otherTxtLab];
    [otherTxtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(numLab);
        make.top.mas_equalTo(height + 20);
    }];
    
    IncomeDetailTxtView *payTime = [[IncomeDetailTxtView alloc] init];
    payTime.leftLab.text = @"支付时间";
    payTime.rightLab.text = self.dataSource.paytime;
    [bgView addSubview:payTime];
    [payTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(numLab);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(otherTxtLab.mas_bottom).offset(12);
    }];
    
    IncomeDetailTxtView *payType = [[IncomeDetailTxtView alloc] init];
    payType.leftLab.text = @"支付方式";
    payType.rightLab.text = self.dataSource.paytype;
    [bgView addSubview:payType];
    [payType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(payTime);
        make.top.mas_equalTo(payTime.mas_bottom).offset(12);
    }];
    
    UIView *line_3 = [[UIView alloc] init];
    line_3.backgroundColor = HEXColor(@"eeeeee", 1);
    [bgView addSubview:line_3];
    [line_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(line_1);
        make.top.mas_equalTo(payType.mas_bottom).offset(14);
    }];
    
    [line_3.superview layoutIfNeeded];
    bgView.height = line_3.bottom + TABBAR_HEIGHT;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, bgView.bottom);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}



@end


@implementation IncomeDetailTxtView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *leftLab = [[UILabel alloc] init];
    leftLab.textColor = HEXColor(@"333333", 1);
    leftLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:leftLab];
    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
    }];
    _leftLab = leftLab;
    
    UILabel *rightLab = [[UILabel alloc] init];
    rightLab.textAlignment = NSTextAlignmentRight;
    rightLab.textColor = HEXColor(@"333333", 0.7);
    rightLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:rightLab];
    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
    }];
    _rightLab = rightLab;
    
}
@end
