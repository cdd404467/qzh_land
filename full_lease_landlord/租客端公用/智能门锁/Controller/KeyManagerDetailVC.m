//
//  KeyManagerDetailVC.m
//  Door_Lock
//
//  Created by wz on 2020/11/29.
//

#import "KeyManagerDetailVC.h"
#import "BaseViewController.h"
#import "ListInfoBaseCell.h"
#import "JCBaseModel.h"

@interface KeyManagerDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray <ListInfoBaseModel *>*models;

@end

@implementation KeyManagerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitle = @"钥匙管理";
    
    [self createUI];
    
    [self setupNorData];
}

-(void)setupNorData{
    NSString *time;
    if (isRightData(self.model.startTime)) {
        time = [NSString stringWithFormat:@"%@至%@",self.model.startTime,self.model.endTime];
    }else{
        time = @"永久期限";
    }
    NSArray *data = @[
        @{
            @"title":@"名称",
            @"subTitle":self.model.keyName,
            @"type":@(ListInfoItemNomalType),
        },@{
            @"title":@"有效期",
            @"subTitle":time,
            @"type":@(ListInfoItemNomalType),
        },@{
            @"title":@"接受者账号",
            @"subTitle":self.model.receiveName,
             @"type":@(ListInfoItemNomalType),
        },@{
            @"title":@"发送人",
            @"subTitle":self.model.senderName,
             @"type":@(ListInfoItemNomalType),
        }, @{
            @"title":@"发送时间",
            @"subTitle":self.model.operTime,
             @"type":@(ListInfoItemNomalType),
        }
    ];
    self.models = JCMODELS([ListInfoBaseModel class], data, nil);
    [self.tableView reloadData];
}

-(void)createUI{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"删除钥匙" forState:UIControlStateNormal];
    [sendBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    sendBtn.layer.cornerRadius = 4;
    sendBtn.backgroundColor = MainColor;
    [sendBtn addTarget:self action:@selector(deleteKey) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(JCWidth(16));
        make.right.equalTo(self.view).offset(-JCWidth(16));
        make.height.mas_equalTo(JCWidth(50));
        make.top.mas_equalTo(tableView.mas_bottom).offset(JCWidth(20));
        BottomOffset(-JCWidth(40));
    }];
    
    sendBtn.hidden = self.model.isSelf == 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListInfoBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListInfoBaseCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailLab.numberOfLines = 0;
    [cell refreshCellWithMode:self.models[indexPath.row] andRow:indexPath.row];
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  JCWidth(40);
}

-(void)deleteKey{
    NSString *toke = DoorToken;
    if (toke.length < 2) {
        return;
    }
    NSDictionary *headerDict = @{@"Authorization":toke};
    NSDictionary *dic = @{
        @"keyId":self.model.keyId,
        @"lockId":self.model.lockId
    };
    [CddHud show:self.view];
    [NetTool postRequestWithHeader:headerDict requestUrl:@"member/smartDevices/deleteKey" Params:dic Success:^(id  _Nonnull json) {
        [CddHud hideHUD:self.view];
        if (JsonCode == 200) {
            [CddHud showTextOnly:@"删除钥匙成功" view:self.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshKeyManagerList" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } 
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

@end
