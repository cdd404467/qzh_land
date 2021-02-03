//
//  SelectBankCardView.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import "SelectBankCardView.h"
typedef void(^SelectBlock)(NSInteger index);
#define AniTime 0.35
#define BgColor HEXColor(@"#ffffff", 0.44);
@interface SelectBankCardView()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy)NSArray *dataSource;
@property (nonatomic, copy) SelectBlock selectBlock;
@property (nonatomic, assign)NSInteger selectPayType;
//背景
@property (nonatomic, strong) UIView *backView;
@end

@implementation SelectBankCardView

- (instancetype)initWithDataSource:(NSArray *)dataSource completion:(void (^)(NSInteger index))completion cancel:(void (^)(void))cancelBlock {
    self = [super init];
    if (self) {
        self.frame = SCREEN_BOUNDS;
        self.backgroundColor = RGBA(0, 0, 0, 0);
        self.dataSource = dataSource;
        self.selectBlock = completion;
        self.selectPayType = 0;
    }
    return self;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT / 2)];
        _backView.backgroundColor = UIColor.whiteColor;
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, SCREEN_WIDTH - 100, 20)];
        titleLab.text = @"选择到账银行卡";
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = HEXColor(@"#333333", 1);
        titleLab.font = [UIFont systemFontOfSize:16];
        [_backView addSubview:titleLab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = HEXColor(@"#D9D8D8", 1);
        [_backView addSubview:line];
        
        [_backView addSubview:self.tableView];
        self.tableView.frame = CGRectMake(0, 50, _backView.width, _backView.height - 50 - 50);
        [_backView addSubview:[self addFooter]];
    }
    return _backView;
}

- (void)show {
    [UIApplication.sharedApplication.windows[0] addSubview:self];
    
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeViews)];
    backTap.delegate = self;
    [self addGestureRecognizer:backTap];
    [self addSubview:self.backView];
    [UIView animateWithDuration:AniTime animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        self.backView.top = SCREEN_HEIGHT - self.backView.height;
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = BgColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = HEXColor(@"#D9D8D8", 1);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.tableFooterView = [UIView new];
        //点击切换时默认选中第一个
//        NSIndexPath *ip = [NSIndexPath indexPathForRow:self.selectPayType inSection:0];
//        [_tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    return _tableView;
}

- (UIView *)addFooter {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, _tableView.bottom, SCREEN_WIDTH, 50);
    UILabel *textLab = [[UILabel alloc] init];
    textLab.frame = CGRectMake(16, 0, SCREEN_WIDTH, 50);
    textLab.text = @"去添加新卡";
    textLab.font = [UIFont systemFontOfSize:16];
//    textLab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:textLab];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.width, 0.5)];
    line.backgroundColor = HEXColor(@"#D9D8D8", 1);
    [view addSubview:line];
    [HelperTool addTapGesture:view withTarget:self andSEL:@selector(useNewCard)];
    return view;
}

- (void)useNewCard {
    self.selectPayType = -1;
    if (self.selectBlock) {
        self.selectBlock(_selectPayType);
    }
    [self removeViews];
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectPayType = indexPath.row;
    if (self.selectBlock) {
        self.selectBlock(_selectPayType);
    }
    [self removeViews];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectBankCardViewCell *cell = [SelectBankCardViewCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)removeViews {
    [UIView animateWithDuration:AniTime animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
        self.backView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
        return NO;
    }
    
    if (touch.view.height < SCREEN_HEIGHT - 10) {
        return NO;
    }
    
    return YES;
}
@end




@interface SelectBankCardViewCell()
@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, strong)UILabel *subTitleLab;
@property (nonatomic, strong)UIButton *selectBtn;
@end

@implementation SelectBankCardViewCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    _selectBtn.selected = selected;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"SelectBankCardViewCell";
    SelectBankCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SelectBankCardViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setupUI {
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_bank_icon_2"]];
    [self.contentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.font = [UIFont systemFontOfSize:14];
    nameLab.textColor = HEXColor(@"#333333", 1);
    [self.contentView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(5);
        make.top.mas_equalTo(icon);
        make.right.mas_equalTo(KFit_W(-30));
    }];
    _nameLab = nameLab;
    
    UILabel *subTitleLab = [[UILabel alloc] init];
    subTitleLab.font = [UIFont systemFontOfSize:12];
    subTitleLab.textColor = HEXColor(@"#666666", 1);
    [self.contentView addSubview:subTitleLab];
    [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(nameLab);
        make.top.mas_equalTo(nameLab.mas_bottom).offset(3);
    }];
    _subTitleLab = subTitleLab;
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setImage:[UIImage imageNamed:@"btn_bg_normal"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"btn_bg_select1"] forState:UIControlStateSelected];
    selectBtn.adjustsImageWhenHighlighted = NO;
    selectBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(icon);
    }];
    _selectBtn = selectBtn;
}

- (void)setModel:(BankCardModel *)model {
    _model = model;
    _nameLab.text = [NSString stringWithFormat:@"%@ %@ (%@)",model.bankname,model.bankCardType,model.account];
    _subTitleLab.text = model.timeToAccount;
}

@end
