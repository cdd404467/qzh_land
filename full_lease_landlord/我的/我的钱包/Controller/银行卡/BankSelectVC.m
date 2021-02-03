//
//  BankSelectVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/11.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BankSelectVC.h"
#import "SelectBankCell.h"

@interface BankSelectVC ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UITextField *searchTF;
@property (nonatomic, copy)NSArray *dataSource;
@property (nonatomic, strong)UIView *backView;
@end

@implementation BankSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"选择银行";
    [self.view addSubview:self.tableView];
    [self requestListWithName:@""];
    [self setupUI];
}


- (void)setupUI {
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT + KFit_W(60), SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - KFit_W(60))];
    _backView.backgroundColor = RGBA(0, 0, 0, 0.3);
    _backView.hidden = YES;
    [HelperTool addTapGesture:_backView withTarget:self andSEL:@selector(backViewClick)];
    [self.view addSubview:_backView];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXColor(@"#FAFAFA", 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, TABBAR_HEIGHT, 0);
        _tableView.tableHeaderView = [self getTableHeader];
    }
    return _tableView;
}

- (UIView *)getTableHeader {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(60))];
    _searchTF = [[UITextField alloc] init];
    _searchTF.placeholder = @"搜索银行名字";
    _searchTF.font = kFont(14);
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 15, 15)];
    imageView.image = [UIImage imageNamed:@"search_icon"];
    [leftView addSubview:imageView];
    _searchTF.leftView = leftView;
    _searchTF.delegate = self;
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
    [_searchTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    _searchTF.backgroundColor = HEXColor(@"#F0F2F5", 1);
    _searchTF.layer.cornerRadius = KFit_W(33) / 2;
    [view addSubview:_searchTF];
    [_searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(KFit_W(33));
        make.centerY.mas_equalTo(view);
    }];
    
    return view;
}

- (void)backViewClick {
    self.backView.hidden = YES;
    [_searchTF resignFirstResponder];
}

// 获得焦点
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.backView.hidden = NO;
    return YES;
}


-(void)changedTextField:(UITextField *)textField {
    if (textField.markedTextRange == nil) {
        [self requestListWithName:textField.text];
    }
}

- (void)requestListWithName:(NSString *)keyword {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (keyword.length == 0) {
        [mDict setObject:@"0" forKey:@"status"];
    } else {
        [mDict setObject:@"1" forKey:@"status"];
        [mDict setObject:keyword forKey:@"name"];
    }
    
    [NetTool postRequest:URLPost_Check_BankList Params:mDict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            self.dataSource = [BankCardModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [self.tableView reloadData];
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
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BankCardModel *model = self.dataSource[indexPath.row];
    if (self.selectBlock) {
        self.selectBlock(model.name);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectBankCell *cell = [SelectBankCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
@end
