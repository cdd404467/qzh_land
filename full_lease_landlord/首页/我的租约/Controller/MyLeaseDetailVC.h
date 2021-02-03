//
//  MyLeaseDetailVC.h
//  FullLease
//
//  Created by apple on 2020/8/22.
//  Copyright © 2020 kad. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyLeaseDetailVC : BaseViewController
@property (nonatomic, copy)NSString *conID;
@end


typedef void(^TapClick)(NSInteger index);
@interface MyLeaseDetailTopView : UIView
@property (nonatomic, copy)TapClick tapClick;
@end

@interface StageView : UIView
@property (nonatomic, assign)NSInteger gradetype;
@property (nonatomic, copy)NSString *gradeValue;
@property (nonatomic, copy)NSArray *dataSource;
@end
NS_ASSUME_NONNULL_END
