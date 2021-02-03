//
//  ListInfoBaseModel.h
//  FullLease
//
//  Created by wz on 2020/8/8.
//  Copyright © 2020 kad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ListInfoItemType){
    ListInfoItemNomalType = 0,
    ListInfoItemArrowType = 1,
    ListInfoItemPhoneType = 2,
    ListInfoItemChangeRentType = 3,
    ListInfoItemInputType = 4,
    ListInfoItemVerCodeType = 5
};

@interface ListInfoBaseModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, copy) NSString *hintText;

@property (nonatomic, assign) ListInfoItemType type;

@property (nonatomic, copy) NSString *b_id;



@end

NS_ASSUME_NONNULL_END
