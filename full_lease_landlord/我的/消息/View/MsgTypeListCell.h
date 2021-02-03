//
//  MsgTypeListCell.h
//  full_lease_landlord
//
//  Created by apple on 2020/9/1.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MsgTypeListCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy)NSString *iconName;
@property (nonatomic, copy)NSString *msgCount;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *title;
@end

NS_ASSUME_NONNULL_END
