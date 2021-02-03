//
//  ApnsModel.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/16.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApnsModel : NSObject
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, copy)NSString *apnsID;
@end

NS_ASSUME_NONNULL_END
