//
//  HouseResourceDetailVC.h
//  FullLease
//
//  Created by apple on 2020/8/22.
//  Copyright © 2020 kad. All rights reserved.
//

#import "BaseViewController.h"
@class HouseInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface HouseResourceDetailVC : BaseViewController
@property (nonatomic, copy)NSString *houseID;
@end


@interface HouseResourceDetailTopView : UIView
@property (nonatomic, strong)HouseInfoModel *model;
@property (nonatomic, strong)UILabel *moneyLab;
@property (nonatomic, strong)UIButton *changeMoneyBtn;
@end

@interface HouseResourceDetailBannerView : UIView
@property (nonatomic, copy)NSArray *images;
@end

@interface HouseResourceDetailInfo : UIView
- (instancetype)initWithFrame:(CGRect)frame model:(HouseInfoModel *)model;
@end
NS_ASSUME_NONNULL_END
