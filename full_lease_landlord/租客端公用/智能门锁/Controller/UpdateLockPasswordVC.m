//
//  UpdateLockPasswordVC.m
//  FullLease
//
//  Created by wz on 2020/11/19.
//  Copyright © 2020 kad. All rights reserved.
//

#import "UpdateLockPasswordVC.h"
#import "ListInfoBaseModel.h"
#import "JCBaseModel.h"
#import "ListInfoBaseCell.h"
#import "UITextField+Limit.h"
#import "CountDown.h"
#import "GesturePasswordVC.h"

@interface UpdateLockPasswordVC ()<UITableViewDelegate,UITableViewDataSource,ListInfoBaseCellDelegate>

@property (nonatomic, strong) NSArray<ListInfoBaseModel *>*models;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)UIButton *codeBtn;
@end

@implementation UpdateLockPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitle = @"忘记手势密码";
    
    [self createUI];
    
    [self setupNorData];
}

-(void)setupNorData{
    NSArray *data = @[
        @{
            @"title":@"手机号",
            @"subTitle":User_Phone,
            @"type":@(ListInfoItemNomalType),
        },
        @{
            @"title":@"验证码",
            @"subTitle":@"",
            @"type":@(ListInfoItemVerCodeType),
            @"hintText":@"请输入验证码"
        },
        @{
            @"title":@"签约证件号码",
            @"subTitle":@"",
             @"type":@(ListInfoItemInputType),
             @"hintText":@"请输入完整的身份证号"
        }
    ];
    self.models = JCMODELS([ListInfoBaseModel class], data, nil);
    [self.tableView reloadData];
}

-(void)createUI{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = [UIView new];
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"ListInfoBaseCell" bundle:nil] forCellReuseIdentifier:@"ListInfoBaseCell"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(JCNAVBar_H);
    }];
    self.tableView = tableView;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = UIColorFromHex(0x28C3CE);
    btn.layer.cornerRadius = 4;
    [btn addTarget:self action:@selector(checkSMSCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(tableView.mas_bottom);
        make.bottom.mas_equalTo(self.view).offset(-(Bottom_Height_Dif + JCWidth(38)));
        make.size.mas_equalTo(CGSizeMake(JCWIDTH - JCWidth(32), JCWidth(50)));
    }];
}


//获取短信验证码
- (void)getSMSCode {
    ListInfoBaseModel *model_0 = self.models[0];
    NSDictionary *dict = @{@"userPhone":model_0.subTitle,
                           @"status":@9,
                           @"userType":@2
    };
    [NetTool postRequest:URLPost_OtherSMS_Code Params:dict Success:^(id  _Nonnull json) {
        if ([json[@"code"] integerValue] == 200) {
            [self countDown];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)checkSMSCode {
    [self.view endEditing:YES];
    [CddHud show:self.view];
    ListInfoBaseModel *model_0 = self.models[0];
    ListInfoBaseModel *model_1 = self.models[1];
    ListInfoBaseModel *model_2 = self.models[2];
    if (model_1.subTitle.length == 0) {
        [CddHud showTextOnly:@"请输入验证码" view:self.view];
        return;
    } else if (model_2.subTitle.length == 0) {
        [CddHud showTextOnly:@"请输入证件号" view:self.view];
        return;
    }

    NSDictionary *dict = @{@"userPhone":model_0.subTitle,
                           @"status":@9,
                           @"SMSCode":model_1.subTitle,
                           @"document":model_2.subTitle
    };
    [NetTool postRequest:URLPost_OtherSMS_Check Params:dict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:self.view];
        if ([json[@"code"] integerValue] == 200) {
            
            if ([json[@"data"][@"Code"] integerValue] == 0) {
                GesturePasswordVC *vc = [[GesturePasswordVC alloc] init];
                vc.type = 1;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [CddHud showTextOnly:json[@"data"][@"Message"] view:self.view];
            }
        }
    } Failure:^(NSError * _Nonnull error) {
        [CddHud showTextOnly:@"网络错误！" view:self.view];
    }];
}

#pragma mark 倒计时
-(void)countDown {
   DDWeakSelf;
   NSTimeInterval aMinutes = 60;
   NSDate *finishDate = [NSDate dateWithTimeIntervalSinceNow:aMinutes];
   CountDown *countDown = [[CountDown alloc] init];
   [countDown countDownWithStratDate:[NSDate date] finishDate:finishDate completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
       if (second == 0) {
           weakself.codeBtn.enabled = YES;
           [weakself.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
       }else{
           weakself.codeBtn.enabled = NO;
           [weakself.codeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)second] forState:UIControlStateNormal];
       }
   }];
}

#pragma mark ---------------- delegate ----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListInfoBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListInfoBaseCell"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell refreshCellWithMode:self.models[indexPath.row] andRow:indexPath.row];
    if (indexPath.row == 1) {
        cell.textField.maxLength = 6;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.codeBtn = cell.rightBtn;
        [self.codeBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [self.codeBtn addTarget:self action:@selector(getSMSCode) forControlEvents:UIControlEventTouchUpInside];
    } else if (indexPath.row == 2) {
        cell.textField.text = @"";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return JCWidth(56);
}

-(void)clickCellBtn:(NSInteger)index{
    ListInfoBaseModel *model = self.models[index];
    if (index == 1) {
        if (model.type == ListInfoItemVerCodeType) {
//            [AFN_Net.sharedInstance sendCodeWithParemeter:@{@"userPhone":self.models[1].subTitle?:@"",@"status":@"6",@"userType":@2} StringBlock:^(NSString *str, NSString *error) {
//                   if(error){
//                       [YJProgressHUD showMessage:error inView:self.view];
//                   }else{
//                       [YJProgressHUD showMessage:@"发送验证码成功" inView:self.view];
//                   }
//               }];
        }
    }
}

@end
