//
//  MessageListCell.h
//  FullLease
//
//  Created by apple on 2020/8/17.
//  Copyright © 2020 kad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MsgModel;

NS_ASSUME_NONNULL_BEGIN

@interface MessageListCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)MsgModel *model;
@end

NS_ASSUME_NONNULL_END
