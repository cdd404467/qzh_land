//
//  ListInfoBaseCell.h
//  FullLease
//
//  Created by wz on 2020/8/11.
//  Copyright © 2020 kad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListInfoBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ListInfoBaseCellDelegate <NSObject>

@optional

-(void)clickCellBtn:(NSInteger)index;

@end

@interface ListInfoBaseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rigthBtnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rigthBtnH;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) id<ListInfoBaseCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (nonatomic, assign) bool showBottomLine;

@property (weak, nonatomic) IBOutlet UIView *bottomSepLine;
- (IBAction)rightBtnClick:(id)sender;

-(void)refreshCellWithMode:(ListInfoBaseModel *)model andRow:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
