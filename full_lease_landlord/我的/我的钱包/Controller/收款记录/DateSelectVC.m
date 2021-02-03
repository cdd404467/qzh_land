//
//  DateSelectVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/9/7.
//  Copyright © 2020 apple. All rights reserved.
//

#import "DateSelectVC.h"
#import <BRDatePickerView.h>

typedef NS_ENUM(NSInteger, BRTimeType) {
    BRTimeTypeBeginTime = 0,
    BRTimeTypeEndTime
};

@interface DateSelectVC ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) BRDatePickerView *datePickerView;
@property (nonatomic, assign) BRTimeType timeType;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIView *dateShowView;
@property (nonatomic, strong) UIButton *yearMonthBtn;
@property (nonatomic, strong) CALayer *bottomBorder;
@property (nonatomic, strong) CALayer *bottomBorder1;
@property (nonatomic, strong) CALayer *bottomBorder2;

@property (nonatomic, weak) UIButton *yearMonthBtnLeft;
@property (nonatomic, weak) UIButton *yearMonthBtnRight;
@end

@implementation DateSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"按时间筛选";
    self.beginSelectDate = self.beginSelectDate?:[NSDate date];
    [self.navBar.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.navBar.rightBtn addTarget:self action:@selector(clickComplete) forControlEvents:UIControlEventTouchUpInside];
    self.navBar.rightBtn.hidden = NO;
    [self setupUI];
}

- (void)setupUI {
    UIView *backView = [[UIView alloc]init];
     [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
    }];
    
    UIView *buttonBack = [[UIView alloc] init];
    buttonBack.backgroundColor = HEXColor(@"F1F1F1", 1);
    buttonBack.layer.cornerRadius = KFit_W(15);
    [backView addSubview:buttonBack];
    [buttonBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(16);
        make.top.equalTo(backView).offset(20);
        make.width.mas_equalTo(KFit_W(106));
        make.height.mas_equalTo(KFit_W(30));
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle: self.isDaySelect?@"按日选择":@"按月选择" forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"switch_icon"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:HEXColor(@"333333", 1) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = kFont(12);
    [rightBtn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:4];
    [rightBtn addTarget:self action:@selector(switchDate) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(buttonBack);
        make.size.mas_equalTo(CGSizeMake(KFit_W(106), KFit_W(40)));
    }];
    self.rightBtn = rightBtn;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
    deleteBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [deleteBtn addTarget:self action:@selector(clickDelete) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView).offset(-KFit_W(16));
        make.size.mas_equalTo(CGSizeMake(KFit_W(16), KFit_W(16)));
        make.centerY.mas_equalTo(rightBtn);
    }];
    
    UIButton *yearMonthBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -KFit_W(32), KFit_W(38))];
    NSString *dateStr;
    UIColor *color;
    if (!self.isDaySelect) {
        dateStr = [NSDate br_stringFromDate:self.daySelectDate?self.daySelectDate:[NSDate date] dateFormat:@"yyyy-MM"];
        color = MainColor;
    }else{
        dateStr = @"选择月份";
        color = HEXColor(@"999999", 1);
    }
    [yearMonthBtn setTitle:dateStr forState:UIControlStateNormal];
    [yearMonthBtn setTitleColor:color forState:UIControlStateNormal];
    CALayer *bottomBorder = [CALayer layer];
    float height = yearMonthBtn.height-1.0f;
    float width = yearMonthBtn.width;
    [yearMonthBtn addTarget:self action:@selector(clickDateSelect) forControlEvents:UIControlEventTouchUpInside];
    bottomBorder.frame = CGRectMake(0.0f, height, width, 1.0f);
    bottomBorder.backgroundColor = color.CGColor;
    [yearMonthBtn.layer addSublayer:bottomBorder];
    [backView addSubview:yearMonthBtn];
    [yearMonthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(16));
        make.right.mas_equalTo(-KFit_W(16));
        make.top.mas_equalTo(deleteBtn.mas_bottom).offset(50);
        make.height.mas_equalTo(KFit_W(38));
    }];
    self.yearMonthBtn = yearMonthBtn;
    
    UIView *dateShowView = [[UIView alloc] init];
    dateShowView.hidden = YES;
    [backView addSubview:dateShowView];
    [dateShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(16));
        make.right.mas_equalTo(-KFit_W(16));
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - KFit_W(32), KFit_W(38)));
        make.top.mas_equalTo(deleteBtn.mas_bottom).offset(50);
    }];
    self.dateShowView = dateShowView;
    
    UIButton *yearMonthBtnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH -KFit_W(82)) / 2, KFit_W(38))];
    [yearMonthBtnLeft setTitle:[NSDate br_stringFromDate:self.beginSelectDate?self.beginSelectDate:[NSDate date] dateFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    [yearMonthBtnLeft setTitleColor: MainColor forState:UIControlStateNormal];
    CALayer *bottomBorder1 = [CALayer layer];
    float height1 = yearMonthBtnLeft.height-1.0f;
    float width1 = yearMonthBtnLeft.width;
    bottomBorder1.frame = CGRectMake(0.0f, height1, width1, 1.0f);
    bottomBorder1.backgroundColor = MainColor.CGColor;
    [yearMonthBtnLeft.layer addSublayer:bottomBorder1];
    [yearMonthBtnLeft addTarget:self action:@selector(clickDateSelect:) forControlEvents:UIControlEventTouchUpInside];
    [dateShowView addSubview:yearMonthBtnLeft];
    [yearMonthBtnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.bottom.mas_equalTo(dateShowView);
        make.width.mas_equalTo((SCREEN_WIDTH - KFit_W(82)) / 2);
    }];
    self.yearMonthBtnLeft = yearMonthBtnLeft;
  
    UIButton *yearMonthBtnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH -KFit_W(85)) / 2, KFit_W(38))];
    NSString *titleLabText = self.endSelectDate?[NSDate br_stringFromDate:self.endSelectDate dateFormat:@"yyyy-MM-dd"]:@"结束时间";
    [yearMonthBtnRight setTitle:titleLabText forState:UIControlStateNormal];
    [yearMonthBtnRight setTitleColor:HEXColor(@"999999", 1) forState:UIControlStateNormal];
    CALayer *bottomBorder2 = [CALayer layer];
    float height2 = yearMonthBtnRight.height-1.0f;
    float width2 = yearMonthBtnRight.width;
    bottomBorder2.frame = CGRectMake(0.0f, height2, width2, 1.0f);
    bottomBorder2.backgroundColor = HEXColor(@"999999", 1).CGColor;
    [yearMonthBtnRight.layer addSublayer:bottomBorder2];
    [dateShowView addSubview:yearMonthBtnRight];
    [yearMonthBtnRight addTarget:self action:@selector(clickDateSelect:) forControlEvents:UIControlEventTouchUpInside];
    [yearMonthBtnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(dateShowView.mas_right);
        make.top.bottom.mas_equalTo(dateShowView);
        make.width.mas_equalTo((SCREEN_WIDTH - KFit_W(82)) / 2);
    }];
    self.yearMonthBtnRight = yearMonthBtnRight;
    
    UILabel *zLab = [[UILabel alloc] init];
    zLab.text = @"至";
    zLab.textColor = HEXColor(@"999999", 1);
    zLab.font = kFont(14);
    [dateShowView addSubview:zLab];
    [zLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(dateShowView);
    }];
        
    // 3.创建选择器容器视图
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(30, 170, backView.frame.size.width - 60, 200)];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [backView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(yearMonthBtn.mas_bottom).offset(KFit_W(30));
        make.height.mas_equalTo(KFit_W(220));
    }];
    
    // 4.创建日期选择器
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
    datePickerView.pickerMode = BRDatePickerModeYM;
    datePickerView.maxDate = [NSDate date];
    datePickerView.selectDate = self.isDaySelect?self.beginSelectDate:self.daySelectDate;
    datePickerView.isAutoSelect = YES;
    datePickerView.showUnitType = BRShowUnitTypeOnlyCenter;
    datePickerView.pickerMode = BRDatePickerModeYM;
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        if (self.isDaySelect) {
            if (self.timeType == BRTimeTypeBeginTime) {
                self.beginSelectDate = selectDate;
                [self.yearMonthBtnLeft setTitle:selectValue forState:UIControlStateNormal];
            } else if (self.timeType == BRTimeTypeEndTime) {
                self.endSelectDate = selectDate;
                [self.yearMonthBtnRight setTitle:selectValue forState:UIControlStateNormal];
            }
        }else{
            self.daySelectDate = selectDate;
            [self.yearMonthBtn setTitle:selectValue forState:UIControlStateNormal];
        }
    };
    
    // 自定义选择器主题样式
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    customStyle.pickerColor = containerView.backgroundColor;
    datePickerView.pickerStyle = customStyle;
    self.datePickerView = datePickerView;
    
    // 添加选择器到容器视图
    [datePickerView addPickerToView:containerView];
    
    self.bottomBorder = bottomBorder;
    self.bottomBorder1 = bottomBorder1;
    self.bottomBorder2 = bottomBorder2;
    
    NSDate *showDate = self.isDaySelect?self.beginSelectDate:self.daySelectDate;
    self.datePickerView.selectDate = showDate?showDate:[NSDate date];
    self.timeType = BRTimeTypeBeginTime;
    self.yearMonthBtn.hidden = self.isDaySelect;
    self.dateShowView.hidden = !self.isDaySelect;
    if ( !self.isDaySelect) {
        self.datePickerView.pickerMode = BRDatePickerModeYM;
        self.datePickerView.hidden = !self.daySelectDate;
        
    } else {
        self.datePickerView.pickerMode = BRDatePickerModeYMD;
        self.datePickerView.hidden = !(self.beginSelectDate || self.endSelectDate);
    }
}

-(void)switchDate{
    
    self.isDaySelect = !self.isDaySelect;
  
    NSString *title = self.isDaySelect?@"按日选择":@"按月选择";
    [self.rightBtn setTitle:title forState:UIControlStateNormal];
    
    NSDate *showDate = self.isDaySelect?self.beginSelectDate:self.daySelectDate;
    self.datePickerView.selectDate = showDate?showDate:[NSDate date];
    self.timeType = BRTimeTypeBeginTime;
    self.yearMonthBtn.hidden = self.isDaySelect;
    self.dateShowView.hidden = !self.isDaySelect;
    if ( !self.isDaySelect) {
        self.datePickerView.pickerMode = BRDatePickerModeYM;
        self.datePickerView.hidden = !self.daySelectDate;
        
    } else {
        self.datePickerView.pickerMode = BRDatePickerModeYMD;
        self.datePickerView.hidden = !(self.beginSelectDate || self.endSelectDate);
    }
}

-(void)clickDateSelect:(UIButton *)sender{
    if (sender == self.yearMonthBtnLeft) {
        self.timeType = BRTimeTypeBeginTime;
        self.bottomBorder1.backgroundColor = MainColor.CGColor;
        self.bottomBorder2.backgroundColor = HEXColor(@"999999", 1).CGColor;
        [self.yearMonthBtnRight setTitleColor: HEXColor(@"999999", 1) forState:UIControlStateNormal];
        NSDate *showDate = self.beginSelectDate?:[NSDate date];
        self.datePickerView.selectDate = showDate;
        self.beginSelectDate = showDate;
        [sender setTitle:[NSDate br_stringFromDate:showDate dateFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    }else if(sender == self.yearMonthBtnRight){
        self.timeType = BRTimeTypeEndTime;
        self.bottomBorder2.backgroundColor = MainColor.CGColor;
        self.bottomBorder1.backgroundColor = HEXColor(@"999999", 1).CGColor;
        [self.yearMonthBtnLeft setTitleColor: HEXColor(@"999999", 1) forState:UIControlStateNormal];
        NSDate *showDate = self.endSelectDate?:[NSDate date];
        self.datePickerView.selectDate = showDate;
        self.endSelectDate = showDate;
        [sender setTitle:[NSDate br_stringFromDate:showDate dateFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    }
    
    self.datePickerView.hidden = NO;
    [sender setTitleColor:MainColor forState:UIControlStateNormal];
    
}

-(void)clickDelete{
    if (self.isDaySelect) {
        self.beginSelectDate = nil;
        self.endSelectDate = nil;
        [self.yearMonthBtnLeft setTitle:@"开始时间" forState:UIControlStateNormal];
        [self.yearMonthBtnLeft setTitleColor:HEXColor(@"999999", 1) forState:UIControlStateNormal];
        self.bottomBorder1.backgroundColor  = HEXColor(@"999999", 1).CGColor;
        [self.yearMonthBtnRight setTitle:@"结束时间" forState:UIControlStateNormal];
        [self.yearMonthBtnRight setTitleColor:HEXColor(@"999999", 1) forState:UIControlStateNormal];
        self.bottomBorder2.backgroundColor  = HEXColor(@"999999", 1).CGColor;
    }else{
        self.daySelectDate = nil;
        self.bottomBorder.backgroundColor = HEXColor(@"999999", 1).CGColor;
        [self.yearMonthBtn setTitle:@"选择月份" forState:UIControlStateNormal];
        [self.yearMonthBtn setTitleColor:HEXColor(@"999999", 1) forState:UIControlStateNormal];
    }
    self.datePickerView.hidden = YES;
    self.datePickerView.selectDate = nil;
}

-(void)clickComplete{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectTimeComplete:endTime:monthTime:isDaySelect:)]) {
        NSString *beginTime;
        NSString *endTime;
        NSString *monthTime;
        if (self.isDaySelect) {
            int result = [self compareOneDay:self.beginSelectDate withAnotherDay:self.endSelectDate];
            if (result ==1) {
                NSDate *tempDate = self.endSelectDate;
                self.endSelectDate = self.beginSelectDate;
                self.beginSelectDate = tempDate;
            }
            beginTime = [NSDate br_stringFromDate:self.beginSelectDate dateFormat:@"yyyy-MM-dd"];
            endTime = [NSDate br_stringFromDate:self.endSelectDate dateFormat:@"yyyy-MM-dd"];
            if (endTime.length == 0) {
                [CddHud showTextOnly:@"请选择结束时间" view:self.view];
                return;
            }
             [self.delegate selectTimeComplete:beginTime endTime:endTime monthTime:monthTime isDaySelect:self.isDaySelect];
        } else{
             monthTime = [NSDate br_stringFromDate:self.daySelectDate dateFormat:@"yyyy-MM"];
             [self.delegate selectTimeComplete:beginTime endTime:endTime monthTime:monthTime isDaySelect:self.isDaySelect];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickDateSelect{
    self.datePickerView.hidden = NO;
    
    NSDate *showDate = self.daySelectDate?:[NSDate date];
    self.datePickerView.selectDate = showDate;
    self.daySelectDate = showDate;
    self.bottomBorder.backgroundColor = MainColor.CGColor;
    [self.yearMonthBtn setTitleColor:MainColor forState:UIControlStateNormal];
    
    
    [self.yearMonthBtn setTitle:[NSDate br_stringFromDate:showDate dateFormat:@"yyyy-MM"] forState:UIControlStateNormal];

}

- (int)compareOneDay:(NSDate*)oneDay withAnotherDay:(NSDate*)anotherDay{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy年MM月dd日 HH:mm"];
    NSString*oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString*anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate*dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate*dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        return 1;
        
    }else if(result == NSOrderedAscending){
        //没过指定时间 没过期
        return-1;
        
    }//刚好时间一样.
    return 0;
}

#pragma mark ------------------ clickBack -----------------
-(void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
