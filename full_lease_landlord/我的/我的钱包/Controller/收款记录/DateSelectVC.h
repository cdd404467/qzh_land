//
//  DateSelectVC.h
//  full_lease_landlord
//
//  Created by apple on 2020/9/7.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DateSelectDelegate <NSObject>

@optional

-(void)selectTimeComplete:(NSString *)startTime endTime:(NSString *)endTime monthTime:(NSString *)monthTime isDaySelect:(BOOL)isDaySelect;

@end


@interface DateSelectVC : BaseViewController
@property (nonatomic,weak)id<DateSelectDelegate>delegate;

@property (nonatomic, strong, nullable) NSDate *beginSelectDate;
@property (nonatomic, strong, nullable) NSDate *endSelectDate;
@property (nonatomic, strong, nullable) NSDate *daySelectDate;
@property (nonatomic, assign) BOOL isDaySelect;
@end

NS_ASSUME_NONNULL_END
