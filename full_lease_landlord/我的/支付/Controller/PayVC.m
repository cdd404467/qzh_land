//
//  PayVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/9/22.
//  Copyright © 2020 apple. All rights reserved.
//

#import "PayVC.h"
#import "PayCell.h"
#import "PayWebVC.h"
#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UITextField+Limit.h"
#import "PayStateVC.h"

@interface PayVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSArray<PayModel *> *dataSource;
@property (nonatomic, copy)PayTableHeader *tableHeader;
@property (nonatomic, assign)NSInteger selectPayType;
@property (nonatomic, strong)PayResultModel *resultData;
@property (nonatomic, strong)UIButton *payNowBtn;
@property (nonatomic, assign)BOOL isPay;
@end

@implementation PayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"支付";
    [self.view addSubview:self.tableView];
    [self setupUI];
    self.selectPayType = 0;
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkPayState) name:NotificationName_ApplicationDidBecomeActive object:nil];
}

- (PayTableHeader *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [[PayTableHeader alloc] init];
        _tableHeader.moneyTF.text = self.recent;
    }
    return _tableHeader;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = TableColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.tableHeader;
    }
    return _tableView;
}

- (void)checkPayState {
    if (!_isPay) {
        return;
    }
    NSMutableArray *newArr = [self.navigationController.viewControllers mutableCopy];
    NSInteger start = [self.navigationController.viewControllers indexOfObject:self] + 1;
    [newArr removeObjectsInRange:NSMakeRange(start, self.navigationController.viewControllers.count - start)];
    self.navigationController.viewControllers = [newArr copy];
    
    PayStateVC *vc = [[PayStateVC alloc] init];
    vc.billID = self.billID;
    vc.orderID = self.resultData.orderid;
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)requestData {
    NSDictionary *dict = @{@"id":self.billID,
                           @"recent":self.recent
    };
    
    [NetTool postRequest:URLPost_Pay_RateSet Params:dict Success:^(id  _Nonnull json) {
        NSLog(@"------ %@",json);
        if (JsonCode == 200) {
            self.payNowBtn.hidden = NO;
            self.dataSource = [PayModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [self.tableView reloadData];
            //点击切换时默认选中第一个
            NSIndexPath *ip = [NSIndexPath indexPathForRow:self.selectPayType inSection:0];
            [self.tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setupUI {
    UIButton *payNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payNowBtn.hidden = YES;
    payNowBtn.layer.cornerRadius = 4.f;
    [payNowBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    payNowBtn.titleLabel.font = kFont(18);
    [payNowBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    payNowBtn.backgroundColor = HEXColor(@"28C3CE", 1);
    [payNowBtn addTarget:self action:@selector(payNow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payNowBtn];
    [payNowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(TABBAR_HEIGHT + KFit_W(57)));
        make.left.mas_equalTo(KFit_W(16));
        make.right.mas_equalTo(KFit_W(-16));
        make.height.mas_equalTo(49);
    }];
    _payNowBtn = payNowBtn;
}

//立即支付
- (void)payNow {
    _isPay = YES;
    self.recent = self.tableHeader.moneyTF.text;
    if (self.recent.doubleValue == 0) {
        [CddHud showTextOnly:@"支付金额不能为0" view:self.view];
        return;
    }
    NSString *payType = self.dataSource[self.selectPayType].payFrom;
    NSDictionary *dict = @{@"billIds":@[self.billID],
                           @"amount":self.recent,
                           @"payFrom":payType,
                           @"appId":wxAppID
    };
    NSLog(@"===== %@",dict);
    [NetTool postRequest:URLPost_Pay_Online Params:dict Success:^(id  _Nonnull json) {
        NSLog(@"------ %@",json);
        if (JsonCode == 200) {
            self.resultData = [PayResultModel mj_objectWithKeyValues:json[@"data"]];
            if ([payType isEqualToString:@"Original_AliApp"]) {
                [self payWithAliPay];
            } else if ([payType isEqualToString:@"Original_WxAPP"]) {
                [self weixinPay];
            } else {
                [self payWithWeb];
            }
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}


//网页支付
- (void)payWithWeb {
    PayWebVC *vc = [[PayWebVC alloc] init];
    vc.urlString = self.resultData.pay_info;
    vc.orderID = self.resultData.orderid;
    vc.billID = self.billID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)weixinPay {
    if (![WXApi isWXAppInstalled]) {
        [CddHud showTextOnly:@"未安装微信app" view:self.view];
        return;
    }
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = _resultData.partnerid;
    req.prepayId = _resultData.prepay_id;
    req.nonceStr = _resultData.noncestr;
    req.timeStamp = _resultData.timestamp;
    req.package = _resultData.packagestr;
    req.sign = _resultData.sign;
    
    [WXApi sendReq:req completion:^(BOOL success) {
        if (success) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:WeixinPayResultSuccess object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFail) name:WeixinPayResultFailed object:nil];
        }
    }];
}

- (void)payWithAliPay {
    NSString *scheme = @"yzhyezhu";
    NSString *order = _resultData.pay_info;
    [[AlipaySDK defaultService] payOrder:order fromScheme:scheme callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] integerValue] == 9000) {
            NSLog(@"支付成功");
        } else {
            NSLog(@"支付失败");
        }
    }];
}

- (void)paySuccess {
    NSLog(@"成功---");
}

- (void)payFail {
    NSLog(@"失败---");
}

#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectPayType = indexPath.row;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PayCell *cell = [tableView cddDequeueReusableCell:PayCell.class];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
@end

@interface PayTableHeader()<UITextFieldDelegate>

@end

@implementation PayTableHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 197);
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(16, 12, SCREEN_WIDTH - 16 * 2, 185)];
    bgView.backgroundColor = UIColor.whiteColor;
    [self addSubview:bgView];
    [HelperTool drawRound:bgView corner:UIRectCornerTopLeft | UIRectCornerTopRight radiu:5];
    
    UITextField *moneyTF = [[UITextField alloc] init];
    moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    moneyTF.delegate = self;
    moneyTF.maxLength = 11;
    moneyTF.font = [UIFont systemFontOfSize:26];
    moneyTF.textColor = HEXColor(@"#3E3E40", 1);
    moneyTF.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:moneyTF];
    [moneyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView);
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(33);
    }];
    _moneyTF = moneyTF;
    
    UIImageView *changeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"change_icon"]];
    [bgView addSubview:changeIcon];
    [changeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(moneyTF.mas_right).offset(14);
        make.centerY.mas_equalTo(moneyTF);
        make.size.mas_equalTo(CGSizeMake(KFit_W(11), KFit_W(11)));
    }];
    
    
    UILabel *iconLab = [[UILabel alloc] init];
    iconLab.text = @"¥";
    iconLab.font = [UIFont systemFontOfSize:20];
    iconLab.textColor = HEXColor(@"#3E3E40", 1);
    iconLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:iconLab];
    [iconLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(moneyTF.mas_left).offset(-2);
        make.height.centerY.mas_equalTo(moneyTF);
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.text = @"请于支付日前支付本期账单，逾期将会产生滞纳金";
    tipLab.font = [UIFont systemFontOfSize:13];
    tipLab.textColor = HEXColor(@"#818181", 1);
    tipLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(moneyTF);
        make.top.mas_equalTo(moneyTF.mas_bottom).offset(6);
        make.height.mas_equalTo(15);
    }];
    _tipLab = tipLab;
    
    UILabel *txtLab = [[UILabel alloc] init];
    txtLab.text = @"选择支付方式";
    txtLab.font = [UIFont systemFontOfSize:12];
    txtLab.textColor = HEXColor(@"#8D8D8D", 1);
    [bgView addSubview:txtLab];
    [txtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL isHaveDian;
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        isHaveDian = YES;
    } else{
        isHaveDian = NO;
    }
    
    if (string.length > 0) {
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.')) {
            return NO;
        }
        // 只能有一个小数点
        if (isHaveDian && single == '.') {
            //            [MBProgressHUD bwm_showTitle:@"最多只能输入一个小数点" toView:self hideAfter:1.0];
            return NO;
        }
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    return NO;
                }
            } else{
                if (![string isEqualToString:@"."]) {
                    return NO;
                }
            }
        }
        // 小数点后最多能输入两位
        if (isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length >= 2) {
                    return NO;
                }
            }
        }
    }
    
    return YES;
}

@end
