//
//  SendKeyViewController.m
//  FullLease
//
//  Created by wz on 2020/11/24.
//  Copyright © 2020 kad. All rights reserved.
//

#import "SendKeyViewController.h"
#import "SendKeyCell.h"
#import "SendKeyTimeCell.h"
#import "SendKeyQRcodeCell.h"
#import "TimeAbout.h"
#import <BRPickerView.h>
#import "TopNavTitleBar.h"

@interface SendKeyViewController ()<UITableViewDelegate,UITableViewDataSource,TopNavTitleBarDelegate>

@property (nonatomic, strong) NSString *startTime;

@property (nonatomic, strong) NSString *endTime;

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) NSString *refundPeople;

@property (nonatomic,strong) NSString *keyName;

@property (nonatomic, assign) NSInteger curIndex;

@end

@implementation SendKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitle = @"发送钥匙";
    
    [self createUI];
}

-(void)createUI{
    TopNavTitleBar *bar = [[TopNavTitleBar alloc] initWithTitles:@[@"永久",@"限时"] titleColor:UIColorFromHex(0x333333) selectedColor:MainColor titleSize:17 selectIndex:0 lineH:2.5 frame:CGRectMake(0, JCNAVBar_H, JCWIDTH, JCWidth(42))];
    bar.delegate = self;
    [self.view addSubview:bar];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[SendKeyCell class] forCellReuseIdentifier:@"SendKeyCell"];
    [tableView registerClass:[SendKeyTimeCell class] forCellReuseIdentifier:@"SendKeyTimeCell"];
    [tableView registerClass:[SendKeyQRcodeCell class] forCellReuseIdentifier:@"SendKeyQRcodeCell"];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(JCNAVBar_H + JCWidth(42));
    }];
    self.tableView = tableView;
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"发送钥匙" forState:UIControlStateNormal];
    [sendBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    sendBtn.layer.cornerRadius = 4;
    sendBtn.backgroundColor = MainColor;
    [sendBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(JCWidth(16));
        make.right.equalTo(self.view).offset(-JCWidth(16));
        make.height.mas_equalTo(JCWidth(50));
        make.top.mas_equalTo(tableView.mas_bottom).offset(JCWidth(20));
        BottomOffset(-JCWidth(40));
    }];
}

-(void)selectTitle:(TopNavTitleBar *)topNavTitleBar index:(NSInteger)index{
    _curIndex = index;
    
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _curIndex==0?2:4;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            SendKeyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendKeyCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLab.text = indexPath.row == 0?@"接受者":@"钥匙名称";
            cell.textField.text = indexPath.row==0?self.refundPeople:self.keyName;
            DDWeakSelf;
            cell.inputText = ^(NSString * _Nonnull str) {
                if (indexPath.row == 0) {
                    weakself.refundPeople = str;
                }else if(indexPath.row == 1){
                    weakself.keyName = str;
                }
            };
            return  cell;
        }else if (indexPath.row == 2 || indexPath.row == 3){
            SendKeyTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendKeyTimeCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLab.text = indexPath.row == 2?@"生效时间":@"失效时间";
            cell.subTitle.text = indexPath.row == 2?self.startTime:self.endTime;
            return  cell;
        }
        return [UITableViewCell new];
    }if(indexPath.section == 1){
        SendKeyQRcodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendKeyQRcodeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [UITableViewCell new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0? JCWidth(56):JCWidth(294);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            [self selectTime:YES];
        }
        if (indexPath.row == 3) {
            [self selectTime:NO];
        }
    }
}

- (void)selectTime:(BOOL)isStart {
    [self.view endEditing:YES];
    
    double startDataDob = [self.model.bluetooth.startDate doubleValue];
    double endDataDob = [self.model.bluetooth.endDate doubleValue];
    
    // 1.创建日期选择器
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]initWithPickerMode:BRDatePickerModeDateAndTime];
    datePickerView.title = @"选择时间";
    datePickerView.selectValue = isStart?self.startTime:self.endTime;
    if (isStart) {
        if (startDataDob != 0) {
            datePickerView.minDate = [NSDate dateWithTimeIntervalSince1970:(startDataDob / 1000)];
            datePickerView.maxDate = [NSDate dateWithTimeIntervalSince1970:(endDataDob / 1000)];
        }else{
            datePickerView.minDate = [NSDate date];
        }
      
    }else{
        
        if (startDataDob != 0) {
            datePickerView.minDate = [NSDate br_dateFromString:self.startTime dateFormat:@"yyyy-MM-dd mm:ss"];
            datePickerView.maxDate = [NSDate dateWithTimeIntervalSince1970:(endDataDob / 1000)];
        }else{
            datePickerView.minDate =  [NSDate br_dateFromString:self.startTime dateFormat:@"yyyy-MM-dd mm:ss"];
        }
    }
  
    datePickerView.isAutoSelect = YES;
    
    datePickerView.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        if (isStart) {
            self.startTime = selectValue;
        }else{
            self.endTime = selectValue;
        
        }
        [self.tableView reloadData];
    };
    [datePickerView show];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JCWIDTH, 10)];
    bgView.backgroundColor = UIColorFromHex(0xF5F5F5);
    return bgView;
}

-(void)clickSendBtn{
    NSString *toke = DoorToken;
    if (toke.length < 2) {
        return;
    }
    NSDictionary *headerDict = @{@"Authorization":toke};
    if (!isRightData(self.refundPeople)) {
        [CddHud showTextOnly:@"接收人不能为空" view:self.view];
        return;
    }
    
    if (!isRightData(self.keyName)) {
        [CddHud showTextOnly:@"钥匙名称不能为空" view:self.view];
        return;
    }
    if (self.curIndex == 1) {
        if (!isRightData(self.startTime)) {
            [CddHud showTextOnly:@"钥匙名称不能为空" view:self.view];
            return;
        }
        if (!isRightData(self.endTime)) {
            [CddHud showTextOnly:@"钥匙名称不能为空" view:self.view];
            return;
        }
    }
    
    NSMutableDictionary *dics = [NSMutableDictionary dictionary];
    dics[@"receiverUsername"] = self.refundPeople;
    dics[@"lockId"] = self.model.lockId;
    dics[@"houseId"] = self.model.houseId;
    dics[@"keyName"] = self.keyName;
    NSString *startDateStr =  [NSDate br_stringFromDate:[NSDate dateWithTimeIntervalSince1970:([self.model.bluetooth.startDate doubleValue] / 1000)] dateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *endDateStr =  [NSDate br_stringFromDate:[NSDate dateWithTimeIntervalSince1970:([self.model.bluetooth.endDate doubleValue] / 1000)] dateFormat:@"yyyy-MM-dd HH:mm"];
    if (self.curIndex == 0) {
        if (![self.model.bluetooth.startDate isEqualToString:@"0"]) {
            dics[@"startDate"] = startDateStr;
            dics[@"endDate"] = endDateStr;
        }
        dics[@"pwdType"] = @8;
    }else{
        dics[@"startDate"] = self.startTime;
        dics[@"endDate"] = self.endTime;
        dics[@"pwdType"] = @7;
    }
    dics[@"fllowPwdId"] = self.model.bluetooth.keyId;
    DDWeakSelf;
    [CddHud show:self.view];
    [NetTool postRequestWithHeader:headerDict requestUrl:@"member/smartDevices/sendKey" Params:dics Success:^(id  _Nonnull json) {
        [CddHud hideHUD:self.view];
        if (JsonCode == 200) {
            [CddHud showTextOnly:@"发送钥匙成功" view:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        } 
    } Failure:^(NSError * _Nonnull error) {
        [CddHud showTextOnly:@"服务器返回异常" view:self.view];
    }];
}

@end
