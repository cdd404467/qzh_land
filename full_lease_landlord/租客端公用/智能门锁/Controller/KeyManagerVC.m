//
//  KeyManagerVC.m
//  Door_Lock
//
//  Created by wz on 2020/11/29.
//

#import "KeyManagerVC.h"
#import "KeyManagerCell.h"
#import "KeyManagerDetailVC.h"

@interface KeyManagerVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<KeyManagerListModel *>*models;

@property (nonatomic, assign)NSInteger page;

@end

@implementation KeyManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"钥匙管理";
    
    _page = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshKeyManagerList" object:nil];
    
    [self createUI];
    
    [self fetchData];
}

- (void)refreshData {
    _page = 1;
    [self fetchData];
}

-(NSMutableArray<KeyManagerListModel *> *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

-(void)fetchData{
    NSString *toke = DoorToken;
    if (toke.length < 2) {
        return;
    }
    NSDictionary *headerDict = @{@"Authorization":toke};
    NSDictionary *dic = @{
        @"lockId":self.lockId,
        @"pageIndex":@(_page),
        @"pageSize":@"20"
    };
    DDWeakSelf;
    [CddHud show:self.view];
    [NetTool postRequestWithHeader:headerDict requestUrl:@"member/smartDevices/getLockKeyRecordList" Params:dic Success:^(id  _Nonnull json) {
        [CddHud hideHUD:self.view];
        // 结束刷新
        if(self.page != 1){
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
        }else{
             [self.tableView.mj_footer resetNoMoreData];
            if (self.tableView.mj_header.isRefreshing){
                [self.tableView.mj_header endRefreshing];
            }
        }
        
        if (JsonCode == 200) {
            NSArray *tempArr = [KeyManagerListModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"numberData"]];
            if(tempArr.count < 20){
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                [weakself.tableView.mj_footer setHidden:YES];
            }else{
                [weakself.tableView.mj_footer setHidden:NO];
            }
            if (self.page == 1) {
                [self.models removeAllObjects];
            }
            [self.models addObjectsFromArray:tempArr];
            [self.tableView reloadData];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

-(void)createUI{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = [UIView new];
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    [tableView registerClass:[KeyManagerCell class] forCellReuseIdentifier:@"KeyManagerCell"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(JCNAVBar_H);
        make.bottom.mas_equalTo(self.view);
    }];
    
    DDWeakSelf;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refreshData];
    }];
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        weakself.page ++;
        [weakself fetchData];
    }];
    
    tableView.mj_header = header;
    tableView.mj_footer = footer;
    
    self.tableView = tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KeyManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KeyManagerCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.models[indexPath.row];
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  JCWidth(60);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KeyManagerDetailVC *vc = [[KeyManagerDetailVC alloc] init];
    vc.model = self.models[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
