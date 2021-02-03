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
#import "CountDown.h"

@interface PayVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSArray<PayModel *> *dataSource;
@property (nonatomic, copy)PayTableHeader *tableHeader;
@property (nonatomic, assign)NSInteger selectPayType;
@property (nonatomic, strong)PayResultModel *resultData;
@end

@implementation PayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"支付";
    self.selectPayType = 0;
    [self requestData];
}

- (PayTableHeader *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [[PayTableHeader alloc] init];
        _tableHeader.payMoneyLab.text = [NSString stringWithFormat:@"¥%@",self.recent];
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
        //点击切换时默认选中第一个
        NSIndexPath *ip = [NSIndexPath indexPathForRow:self.selectPayType inSection:0];
        [_tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    return _tableView;
}

#pragma mark 倒计时
-(void)countDown {
   DDWeakSelf;
   NSTimeInterval aMinutes = 60 * 20;
   NSDate *finishDate = [NSDate dateWithTimeIntervalSinceNow:aMinutes];
   CountDown *countDown = [[CountDown alloc] init];
   [countDown countDownWithStratDate:[NSDate date] finishDate:finishDate completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
       if (second == 0) {
           
       }else{
           weakself.tableHeader.timeLab.text = [NSString stringWithFormat:@"支付剩余时间：%ld:%ld",(long)minute,(long)second];
       }
   }];
}

- (void)requestData {
    NSDictionary *dict = @{@"id":self.billID,
                           @"recent":self.recent
    };
    
    [NetTool postRequest:URLPost_Pay_RateSet Params:dict Success:^(id  _Nonnull json) {
//        NSLog(@"------ %@",json);
        if (JsonCode == 200) {
            self.dataSource = [PayModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [self.view addSubview:self.tableView];
            [self setupUI];
            [self countDown];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setupUI {
    UIButton *payNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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
}

//立即支付
- (void)payNow {
    NSDictionary *dict = @{@"billIds":@[self.billID],
                           @"amount":self.recent,
                           @"payFrom":self.dataSource[self.selectPayType].payFrom
    };
    
    [NetTool postRequest:URLPost_Pay_Online Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            self.resultData = [PayResultModel mj_objectWithKeyValues:json[@"data"]];
            PayWebVC *vc = [[PayWebVC alloc] init];
            vc.urlString = self.resultData.pay_info;
            vc.orderID = self.resultData.orderid;
            vc.billID = self.billID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
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
    PayCell *cell = [PayCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
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
    
    UILabel *payMoneyLab = [[UILabel alloc] init];
    payMoneyLab.font = [UIFont systemFontOfSize:20];
    payMoneyLab.textColor = HEXColor(@"#3E3E40", 1);
    payMoneyLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:payMoneyLab];
    [payMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView);
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(33);
    }];
    _payMoneyLab = payMoneyLab;
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.font = [UIFont systemFontOfSize:13];
    timeLab.textColor = HEXColor(@"#818181", 1);
    timeLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(payMoneyLab);
        make.top.mas_equalTo(payMoneyLab.mas_bottom).offset(6);
        make.height.mas_equalTo(15);
    }];
    _timeLab = timeLab;
    
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
@end
