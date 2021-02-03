//
//  DictModel.h
//  FullLease
//
//  Created by apple on 2020/8/25.
//  Copyright © 2020 kad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DictModel : NSObject

@property (nonatomic, copy)NSString *key;

@property (nonatomic, copy)NSString *value;

@property (nonatomic, assign)CGFloat height;

@end

NS_ASSUME_NONNULL_END
