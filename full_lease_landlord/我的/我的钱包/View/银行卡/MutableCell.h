//
//  MutableCell.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/9.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MutableCellModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^BtnClickBlock)(void);

@interface MutableCell : UITableViewCell
@property (nonatomic, strong)UILabel *titleLab;
@property (nonatomic, strong)UILabel *rightLab;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *subTitle;
@property (nonatomic, strong)UITextField *tf;
@property (nonatomic, copy)NSString *placeHolder;
@property (nonatomic, strong)UIButton *sendCodeBtn;
@property (nonatomic, strong)MutableCellModel *model;
@property (nonatomic, copy)BtnClickBlock btnClickBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView type:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
