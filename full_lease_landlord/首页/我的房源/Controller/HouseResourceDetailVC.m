//
//  HouseResourceDetailVC.m
//  FullLease
//
//  Created by apple on 2020/8/22.
//  Copyright © 2020 kad. All rights reserved.
//

#import "HouseResourceDetailVC.h"
#import <SDCycleScrollView.h>
#import "HouseInfoModel.h"
#import "ChangePriceView.h"
#import "LeaseContractVC.h"
#import "EmptyCompensationVC.h"
#import "MyLeaseDetailVC.h"
#import "MyLeaseDetail2VC.h"

@interface HouseResourceDetailVC ()
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)HouseInfoModel *dataSource;
@property (nonatomic, strong)HouseResourceDetailTopView *topBg;
@property (nonatomic, copy)NSString *price;
@end

@implementation HouseResourceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"房源详情";
    [self requestData];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
        _scrollView.backgroundColor = HEXColor(@"#f8f8f8", 1);
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_HouseResource_Detail,_houseID];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            self.dataSource = [HouseInfoModel mj_objectWithKeyValues:json[@"data"]];
            [self setupUI];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)phoneCall {
    Phone_Call(_dataSource.keeperMobile);
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    
    HouseResourceDetailTopView *topBg = [[HouseResourceDetailTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(107))];
    topBg.model = self.dataSource;
    [topBg.changeMoneyBtn addTarget:self action:@selector(changePrice) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:topBg];
    _topBg = topBg;
    //图片
    HouseResourceDetailBannerView *bannerView = [[HouseResourceDetailBannerView alloc] initWithFrame:CGRectMake(0, topBg.bottom + KFit_W(10), topBg.width, KFit_W(227))];
    bannerView.images = self.dataSource.publicimgList;
    [self.scrollView addSubview:bannerView];
    
    //房屋信息
    HouseResourceDetailInfo *infoView = [[HouseResourceDetailInfo alloc] initWithFrame:CGRectMake(0, bannerView.bottom + KFit_W(10), bannerView.width, KFit_W(240)) model:self.dataSource];
    [self.scrollView addSubview:infoView];
    
    //其他的view
    UIView *otherBgView = [[UIView alloc] initWithFrame:CGRectMake(0, infoView.bottom, SCREEN_WIDTH, 200)];
    otherBgView.backgroundColor = UIColor.whiteColor;
    [self.scrollView addSubview:otherBgView];
    
    UIView *contactView = [[UIView alloc] initWithFrame:CGRectMake(KFit_W(16), KFit_W(30), SCREEN_WIDTH - KFit_W(32), KFit_W(54))];
    contactView.layer.cornerRadius = 4.f;
    contactView.clipsToBounds = YES;
    contactView.layer.borderColor = HEXColor(@"#E9E8E8", 1).CGColor;
    contactView.layer.borderWidth = 0.5f;
    [otherBgView addSubview:contactView];
    
    UIView *manageBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KFit_W(107), contactView.height)];
    manageBg.backgroundColor = HEXColor(@"#FAFAFA", 1);
    [contactView addSubview:manageBg];
    
    UIImageView *signImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"house_manager_sign"]];
    signImageView.frame = CGRectMake(0, 0, KFit_W(37), KFit_W(35));
    [contactView addSubview:signImageView];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(signImageView.right - 3, 0, manageBg.width - signImageView.width - 6, 30)];
    nameLab.font = kFont(15);
    nameLab.text = _dataSource.keeperRealName;
    nameLab.textColor = HEXColor(@"#333333", 1);
    nameLab.centerY = manageBg.centerY;
    [contactView addSubview:nameLab];
    
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callBtn.backgroundColor = HEXColor(@"#F5A623", 1);
    callBtn.layer.cornerRadius = 4.f;
    [callBtn setTitle:@"去拨打" forState:UIControlStateNormal];
    [callBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(phoneCall) forControlEvents:UIControlEventTouchUpInside];
    callBtn.titleLabel.font = kFont(15);
    [contactView addSubview:callBtn];
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KFit_W(-15));
        make.width.mas_equalTo(KFit_W(69));
        make.height.mas_equalTo(KFit_W(26));
        make.centerY.mas_equalTo(contactView);
    }];
    
    UILabel *phoneLab = [[UILabel alloc] init];
    phoneLab.font = kFont(18);
    phoneLab.text = _dataSource.keeperMobile;
    phoneLab.textColor = HEXColor(@"#F5A623", 1);
    [manageBg addSubview:phoneLab];
    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(manageBg.mas_right).offset(KFit_W(10));
        make.centerY.mas_equalTo(contactView);
        make.right.mas_equalTo(callBtn.mas_left).offset(-2);
    }];
    
    //赔偿空置金
    UIView *emptyCompensationView = [[UIView alloc] initWithFrame:CGRectMake(contactView.left, contactView.bottom + KFit_W(35), contactView.width, KFit_W(61))];
    emptyCompensationView.layer.cornerRadius = 4.f;
    emptyCompensationView.layer.borderColor = HEXColor(@"#E9E8E8", 1).CGColor;
    emptyCompensationView.layer.borderWidth = 0.5f;
    [otherBgView addSubview:emptyCompensationView];
    
    UIImageView *emptyImageView = [[UIImageView alloc] init];
    emptyImageView.image = [UIImage imageNamed:@"house_empty_img"];
    [emptyCompensationView addSubview:emptyImageView];
    [emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(30));
        make.width.mas_equalTo(KFit_W(64));
        make.height.mas_equalTo(KFit_W(52));
        make.centerY.mas_equalTo(emptyImageView);
    }];
    
    UIButton *empty_checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    empty_checkBtn.layer.cornerRadius = 4;
    empty_checkBtn.layer.borderColor = MainColor.CGColor;
    empty_checkBtn.layer.borderWidth = 0.5f;
    [empty_checkBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [empty_checkBtn setTitle:@"查看" forState:UIControlStateNormal];
    empty_checkBtn.backgroundColor = UIColor.whiteColor;
    [empty_checkBtn addTarget:self action:@selector(emptyCompen) forControlEvents:UIControlEventTouchUpInside];
    empty_checkBtn.titleLabel.font = kFont(14);
    [emptyCompensationView addSubview:empty_checkBtn];
    [empty_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KFit_W(-25));
        make.centerY.mas_equalTo(emptyCompensationView);
        make.width.mas_equalTo(KFit_W(60));
        make.height.mas_equalTo(KFit_W(20));
    }];
    
    UILabel *txtlab_1 = [[UILabel alloc] init];
    txtlab_1.font = kFont(14);
    txtlab_1.text = @"空置赔偿金";
    txtlab_1.textColor = HEXColor(@"#1C1C1C", 1);
    [emptyCompensationView addSubview:txtlab_1];
    [txtlab_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(emptyImageView.mas_right).offset(KFit_W(40));
        make.right.mas_equalTo(empty_checkBtn.mas_left).offset(5);
        make.centerY.mas_equalTo(emptyCompensationView);
        make.height.mas_equalTo(KFit_W(20));
    }];
    
    //业主合同
    UIView *landlordConView = [[UIView alloc] initWithFrame:CGRectMake(emptyCompensationView.left, emptyCompensationView.bottom + KFit_W(35), emptyCompensationView.width, emptyCompensationView.height)];
    landlordConView.layer.cornerRadius = 4.f;
    landlordConView.layer.borderColor = HEXColor(@"#E9E8E8", 1).CGColor;
    landlordConView.layer.borderWidth = 0.5f;
    [otherBgView addSubview:landlordConView];
    
    UIImageView *landImageView = [[UIImageView alloc] init];
    landImageView.image = [UIImage imageNamed:@"house_land_img"];
    [landlordConView addSubview:landImageView];
    [landImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(35));
        make.width.mas_equalTo(KFit_W(57));
        make.height.mas_equalTo(KFit_W(45));
        make.centerY.mas_equalTo(landlordConView);
    }];
    
    UIButton *land_checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    land_checkBtn.layer.cornerRadius = 4;
    land_checkBtn.layer.borderColor = MainColor.CGColor;
    land_checkBtn.layer.borderWidth = 0.5f;
    [land_checkBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [land_checkBtn setTitle:@"查看" forState:UIControlStateNormal];
    land_checkBtn.backgroundColor = UIColor.whiteColor;
    land_checkBtn.titleLabel.font = kFont(14);
    [land_checkBtn addTarget:self action:@selector(landCon) forControlEvents:UIControlEventTouchUpInside];
    [landlordConView addSubview:land_checkBtn];
    [land_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KFit_W(-25));
        make.centerY.mas_equalTo(landlordConView);
        make.width.mas_equalTo(KFit_W(60));
        make.height.mas_equalTo(KFit_W(20));
    }];
    
    UILabel *txtlab_2 = [[UILabel alloc] init];
    txtlab_2.font = kFont(14);
    txtlab_2.text = @"业主合同";
    txtlab_2.textColor = HEXColor(@"#1C1C1C", 1);
    [landlordConView addSubview:txtlab_2];
    [txtlab_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(landImageView.mas_right).offset(KFit_W(40));
        make.right.mas_equalTo(land_checkBtn.mas_left).offset(5);
        make.centerY.mas_equalTo(landlordConView);
        make.height.mas_equalTo(KFit_W(20));
    }];
    
    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    historyBtn.layer.cornerRadius = 4.f;
    historyBtn.clipsToBounds = YES;
    historyBtn.layer.borderWidth = 0.5;
    historyBtn.layer.borderColor = MainColor.CGColor;
    [historyBtn setTitle:@"历史租客" forState:UIControlStateNormal];
    historyBtn.backgroundColor = UIColor.whiteColor;
    [historyBtn setTitleColor:MainColor forState:UIControlStateNormal];
    historyBtn.titleLabel.font = kFont(16);
    [historyBtn addTarget:self action:@selector(histroyZuke) forControlEvents:UIControlEventTouchUpInside];
    [otherBgView addSubview:historyBtn];
    [historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(16));
        make.height.mas_equalTo(49);
        make.top.mas_equalTo(landlordConView.mas_bottom).offset(KFit_W(98));
        make.width.mas_equalTo(KFit_W(160));
    }];
    
    UIButton *inrentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [inrentBtn setTitle:@"在租租客" forState:UIControlStateNormal];
    inrentBtn.backgroundColor = MainColor;
    inrentBtn.layer.cornerRadius = 4.f;
    inrentBtn.clipsToBounds = YES;
    [inrentBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    inrentBtn.titleLabel.font = kFont(16);
    [inrentBtn addTarget:self action:@selector(inrentZuke) forControlEvents:UIControlEventTouchUpInside];
    [otherBgView addSubview:inrentBtn];
    [inrentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KFit_W(-16));
        make.height.width.top.mas_equalTo(historyBtn);
    }];
    [inrentBtn.superview layoutIfNeeded];
    
    otherBgView.height = inrentBtn.bottom + KFit_W(62) + Bottom_Height_Dif;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, otherBgView.bottom);
}
//历史租客
- (void)histroyZuke {
    LeaseContractVC *vc = [[LeaseContractVC alloc] init];
    vc.houseID = _houseID;
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
}
//在租租客
- (void)inrentZuke {
    LeaseContractVC *vc = [[LeaseContractVC alloc] init];
    vc.houseID = _houseID;
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
//空置赔偿金
- (void)emptyCompen {
    EmptyCompensationVC *vc = [[EmptyCompensationVC alloc] init];
    vc.conID = _dataSource.townContractId;
    [self.navigationController pushViewController:vc animated:YES];
}
//业主合同
- (void)landCon {
    if (self.dataSource.type == 1) {
        MyLeaseDetailVC *vc = [[MyLeaseDetailVC alloc] init];
        vc.conID = _dataSource.townContractId;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.dataSource.type == 2) {
        MyLeaseDetail2VC *vc = [[MyLeaseDetail2VC alloc] init];
        vc.conID = _dataSource.townContractId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)changePrice {
    DDWeakSelf;
    ChangePriceView *view = [[ChangePriceView alloc] initWithMaxPrice:_dataSource.higHestincreaseStr completion:^(NSString * _Nonnull text) {
        [weakself changeMoney:text];
    }];
    view.zujinTF.text = _dataSource.price;
    [view show];
}

- (void)changeMoney:(NSString *)price {
    NSDictionary *dict = @{@"price":price,
                           @"tHouseSourcesId":_houseID
    };
    [NetTool postRequest:URLPost_ChangeMoney_HRD Params:dict Success:^(id  _Nonnull json) {
//        NSLog(@"--- %@",json);
        if (JsonCode == 200) {
            [CddHud showTextOnly:@"修改成功" view:self.view];
            self.topBg.moneyLab.text = price;
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

@end


@interface HouseResourceDetailTopView()
@property (nonatomic, strong)UILabel *stateLab;
@property (nonatomic, strong)UILabel *addressLab;
@property (nonatomic, strong)UILabel *detailAddressLab;
@end

@implementation HouseResourceDetailTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = UIColor.whiteColor;
    UILabel *stateLab = [[UILabel alloc] init];
    stateLab.textAlignment = NSTextAlignmentRight;
    stateLab.textColor = UIColor.blackColor;
    [self addSubview:stateLab];
    [stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KFit_W(-16));
        make.top.mas_equalTo(KFit_W(16));
        make.height.mas_equalTo(KFit_W(20));
        make.width.mas_equalTo(KFit_W(60));
    }];
    _stateLab = stateLab;
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.textColor = HEXColor(@"#333333", 1);
    addressLab.font = kFont(14);
    [self addSubview:addressLab];
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(16));
        make.top.mas_equalTo(KFit_W(16));
        make.height.mas_equalTo(KFit_W(20));
        make.right.mas_equalTo(stateLab.mas_left).offset(2);
    }];
    _addressLab = addressLab;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"location_icon"];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressLab);
        make.width.mas_equalTo(KFit_W(13));
        make.height.mas_equalTo(KFit_W(15));
        make.top.mas_equalTo(addressLab.mas_bottom).offset(KFit_W(10));
    }];
    
    UILabel *detailAddressLab = [[UILabel alloc] init];
    detailAddressLab.textColor = HEXColor(@"#999999", 1);
    detailAddressLab.font = kFont(14);
    [self addSubview:detailAddressLab];
    [detailAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).offset(3);
        make.centerY.mas_equalTo(imageView);
        make.right.mas_equalTo(stateLab);
    }];
    _detailAddressLab = detailAddressLab;
    
    UILabel *moneyLab = [[UILabel alloc] init];
    moneyLab.textColor = HEXColor(@"#FA6565", 1);
    moneyLab.font = kFont(14);
    [self addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressLab);
        make.height.mas_equalTo(KFit_W(20));
        make.top.mas_equalTo(detailAddressLab.mas_bottom).offset(KFit_W(12));
        make.right.mas_equalTo(KFit_W(110));
    }];
    _moneyLab = moneyLab;
    
    UIButton *changeMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeMoneyBtn.backgroundColor = MainColor;
    [changeMoneyBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    changeMoneyBtn.layer.cornerRadius = 5.f;
    [changeMoneyBtn setTitle:@"修改租金" forState:UIControlStateNormal];
    changeMoneyBtn.titleLabel.font = kFont(12); 
    [self addSubview:changeMoneyBtn];
    [changeMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(stateLab);
        make.width.mas_equalTo(KFit_W(73));
        make.height.mas_equalTo(KFit_W(20));
        make.centerY.mas_equalTo(moneyLab);
    }];
    _changeMoneyBtn = changeMoneyBtn;
}

- (void)setModel:(HouseInfoModel *)model {
    _model = model;
    [self setStates];
    _addressLab.text = model.specificAddress;
    _detailAddressLab.text = model.adress;
    _moneyLab.text = [NSString stringWithFormat:@"¥%@",model.price];
}

- (void)setStates {
    //文字状态颜色和背景颜色
    _stateLab.text = _model.statusStr;
    UIColor *textColor;
    UIColor *backgroundColor;
    if (_model.status == 1) {
        textColor = HEXColor(@"#FA6565", 1);
        backgroundColor = HEXColor(@"#FEEAE9", 1);
    } else if (_model.status == 2) {
        textColor = HEXColor(@"#333333", 1);
        backgroundColor = UIColor.whiteColor;
    } else if (_model.status == 3) {
        textColor = HEXColor(@"#333333", 1);
        backgroundColor = UIColor.whiteColor;
    } else if (_model.status == 4) {
        textColor = HEXColor(@"#BFBFBF", 1);
        backgroundColor = HEXColor(@"#000000", 0.08);
    } else if (_model.status == 5) {
        textColor = HEXColor(@"#27C3CE", 1);
        backgroundColor = HEXColor(@"#E7F5F2", 1);
    } else {
        textColor = HEXColor(@"#333333", 1);
        backgroundColor = UIColor.whiteColor;
    }
    _stateLab.textColor = textColor;
}

@end


@interface HouseResourceDetailBannerView()<SDCycleScrollViewDelegate>
@property (nonatomic, strong)SDCycleScrollView *bannerView;
@end

@implementation HouseResourceDetailBannerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = UIColor.whiteColor;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(KFit_W(16), KFit_W(20), 4, KFit_W(18))];
    lineView.backgroundColor = MainColor;
    [self addSubview:lineView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(lineView.right + 10, lineView.top, 150, lineView.height)];
    titleLab.text = @"图片";
    titleLab.textColor = HEXColor(@"#333333", 1);
    titleLab.font = kFont(14);
    [self addSubview:titleLab];
    
    CGRect frame = CGRectMake(lineView.left, lineView.bottom + KFit_W(16), SCREEN_WIDTH - lineView.left * 2, KFit_W(153));
    SDCycleScrollView *bannerView = [[SDCycleScrollView alloc] initWithFrame:frame];
    bannerView.delegate = self;
    bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    bannerView.autoScroll = YES;
    bannerView.backgroundColor = BannerBgColor;
    bannerView.autoScrollTimeInterval = 3.0;
    bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    bannerView.clipsToBounds = true;
    bannerView.placeholderImage = PlaceHolderImg;
    bannerView.pageControlDotSize = CGSizeMake(6, 6);
    bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    bannerView.layer.cornerRadius = 8;
    [self addSubview:bannerView];
    _bannerView = bannerView;
}

- (void)setImages:(NSArray *)images {
    _images = images;
    _bannerView.imageURLStringsGroup = images;
}

@end

@interface HouseResourceDetailInfo()
@property (nonatomic, strong)UILabel *orientationLab;
@end

@implementation HouseResourceDetailInfo
- (instancetype)initWithFrame:(CGRect)frame model:(HouseInfoModel *)model {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIWithModel:model];
    }
    return self;
}


- (void)setupUIWithModel:(HouseInfoModel *)model {
    self.backgroundColor = UIColor.whiteColor;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(KFit_W(16), KFit_W(20), 4, KFit_W(18))];
    lineView.backgroundColor = MainColor;
    [self addSubview:lineView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(lineView.right + 10, lineView.top, 150, lineView.height)];
    titleLab.text = @"房屋信息";
    titleLab.textColor = HEXColor(@"#333333", 1);
    titleLab.font = kFont(14);
    [self addSubview:titleLab];
    
    UIView *line_2 = [[UIView alloc] init];
    line_2.backgroundColor = HEXColor(@"#F5F5F5", 1);
    [self addSubview:line_2];
    [line_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(KFit_W(30));
        make.top.mas_equalTo(lineView.mas_bottom).offset(KFit_W(40));
    }];
    
    UIView *line_1 = [[UIView alloc] init];
    line_1.backgroundColor = line_2.backgroundColor;
    [self addSubview:line_1];
    [line_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.mas_equalTo(line_2);
        make.right.mas_equalTo(line_2.mas_left).offset(KFit_W(-85));
    }];

    UIView *line_3 = [[UIView alloc] init];
    line_3.backgroundColor = line_2.backgroundColor;
    [self addSubview:line_3];
    [line_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(line_2.mas_right).offset(KFit_W(85));
        make.width.height.top.mas_equalTo(line_2);
    }];
    
    CGFloat labWidth = KFit_W(65);
    NSArray *titleArr = @[@"户型",@"面积",@"楼层",@"朝向"];
    NSArray *destitleArr = @[model.hallDesc,
                             [NSString stringWithFormat:@"%@m²",model.measure],
                             model.floorDesc,
                             model.orientation];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UILabel *labTitle = [[UILabel alloc] init];
        labTitle.text = titleArr[i];
        labTitle.font = kFont(13);
        labTitle.textColor = HEXColor(@"#999999", 1);
        labTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labTitle];
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(labWidth);
            make.height.mas_equalTo(KFit_W(19));
            make.bottom.mas_equalTo(line_1.mas_centerY).offset(-8);
            if (i == 0) {
                make.right.mas_equalTo(line_1.mas_left).offset(KFit_W(-10));
            } else if (i == 1) {
                make.left.mas_equalTo(line_1.mas_right).offset(KFit_W(10));
            } else if (i == 2) {
                make.left.mas_equalTo(line_2.mas_right).offset(KFit_W(10));
            } else if (i == 3) {
                make.left.mas_equalTo(line_3.mas_right).offset(KFit_W(10));
            }
        }];
        
        UILabel *desLab = [[UILabel alloc] init];
        desLab.text = destitleArr[i];
        desLab.font = kFont(13);
        desLab.textColor = HEXColor(@"#333333", 1);
        desLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:desLab];
        [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.centerX.mas_equalTo(labTitle);
            make.top.mas_equalTo(line_1.mas_centerY).offset(8);
        }];
        
        if (i == 3) {
            _orientationLab = desLab;
        }
    }
    
    //下面三行
    NSArray *titleArr_1 = @[@"房屋配备",@"房屋特色",@"房屋描述"];
    NSArray *destitleArr_1 = @[model.publicpeibei,model.publicteshe,model.houseDesc];
    for (NSInteger i = 0;i < 3;i++) {
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.font = kFont(13);
        titleLab.text = titleArr_1[i];
        titleLab.textColor = HEXColor(@"#999999", 1);
        [self addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KFit_W(29));
            make.top.mas_equalTo(self.orientationLab.mas_bottom).offset(KFit_W(30) + i * KFit_W(10 + 19));
            make.height.mas_equalTo(KFit_W(19));
        }];
        [titleLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        UILabel *desLab = [[UILabel alloc] init];
        desLab.text = destitleArr_1[i];
        desLab.font = kFont(13);
        desLab.textColor = HEXColor(@"#333333", 1);
        [self addSubview:desLab];
        [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(titleLab);
            make.left.mas_equalTo(titleLab.mas_right).offset(KFit_W(15));
            make.right.mas_equalTo(-15);
        }];
    }
}

@end
