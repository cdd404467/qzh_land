//
//  SendKeyCell.h
//  FullLease
//
//  Created by wz on 2020/11/24.
//  Copyright © 2020 kad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyInputText)(NSString * _Nonnull str);

NS_ASSUME_NONNULL_BEGIN

@interface SendKeyCell : UITableViewCell

@property (nonatomic, weak) UILabel *titleLab;

@property (nonatomic, weak) UITextField *textField;

@property (nonatomic, copy) MyInputText inputText;

@end

NS_ASSUME_NONNULL_END
