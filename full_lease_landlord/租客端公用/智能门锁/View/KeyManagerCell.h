//
//  KeyManagerCell.h
//  Door_Lock
//
//  Created by wz on 2020/11/29.
//

#import <UIKit/UIKit.h>
#import "KeyManagerListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KeyManagerCell : UITableViewCell

@property (nonatomic, weak) UILabel *titleLab;

@property (nonatomic, weak) UILabel *subTitle;

@property (nonatomic, strong) KeyManagerListModel *model;

@end

NS_ASSUME_NONNULL_END
