//
//  SmartDoorLockTypeView.m
//  FullLease
//
//  Created by wz on 2020/11/19.
//  Copyright © 2020 kad. All rights reserved.
//

#import "SmartDoorLockTypeView.h"
#import "ListInfoBaseCell.h"

@interface SmartDoorLockTypeView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) UILabel *lockName;
@property (nonatomic, weak) UILabel *electricityLab;

@end

@implementation SmartDoorLockTypeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}


-(void)setupViews{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UIImageView *backImg = [[UIImageView alloc] init];
    backImg.image = [UIImage imageNamed:@"door_lock_type"];
    [backView addSubview:backImg];
    [backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.top.mas_equalTo(backView);
        make.height.mas_equalTo(JCWidth(206));
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"远洋悦庭58单元1102室";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = UIColorFromHex(0xFFFFFF);
    titleLab.font = kFont(16);
    [backImg addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(backImg);
        make.top.mas_equalTo(backImg).offset(JCWidth(60));
    }];
    self.titleLab = titleLab;
    
    UILabel *lockName = [[UILabel alloc] init];
    lockName.text = @"外门锁";
    lockName.textColor = UIColor.whiteColor;
    lockName.font = kFont(14);
    lockName.textAlignment = NSTextAlignmentCenter;
    [backImg addSubview:lockName];
    [lockName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).offset(14);
        make.left.right.mas_equalTo(backImg);
    }];
    self.lockName = lockName;
    
    UILabel *electricityLab = [[UILabel alloc] init];
    electricityLab.text = @"电量：53%";
    electricityLab.textColor = UIColor.whiteColor;
    electricityLab.textAlignment = NSTextAlignmentCenter;
    electricityLab.font = kFont(14);
    [backImg addSubview:electricityLab];
    [electricityLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lockName.mas_bottom).offset(10);
        make.left.right.mas_equalTo(backImg);
    }];
    self.electricityLab = electricityLab;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"ListInfoBaseCell" bundle:nil] forCellReuseIdentifier:@"ListInfoBaseCell"];
    [backView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backImg.mas_bottom).offset(JCWidth(0));
        make.left.mas_equalTo(backView);
        make.right.mas_equalTo(backView);
        make.bottom.mas_equalTo(backView.mas_bottom).offset(-JCWidth(48));
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListInfoBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListInfoBaseCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.showBottomLine = YES;
    ListInfoBaseModel *model = [[ListInfoBaseModel alloc] init];
    model.title = indexPath.row ==0 ? @"修改密码":indexPath.row==1?@"获取一次性密码":indexPath.row==2?@"发送钥匙":@"钥匙管理";
    model.type = ListInfoItemArrowType;
    [cell refreshCellWithMode:model andRow:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return JCWidth(58);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (self.updatePWD) {
            self.updatePWD();
        }
    }
    
    if (indexPath.row == 1) {
        if (self.oneTimePWD) {
            self.oneTimePWD();
        }
    }
    
    if (indexPath.row == 2) {
      
    }
    
    if (indexPath.row == 3) {
        
    }
}

-(void)setModel:(DoorLockModel *)model{
    _model = model;

    self.titleLab.text = model.doorAddress;
    self.lockName.text = model.frontDoor == 1?@"外门锁":@"内门锁";
    self.electricityLab.text = [[NSString stringWithFormat:@"电量: %@",model.password.electricQuantity?:@"--"] stringByAppendingString:@"%"];
}

@end
