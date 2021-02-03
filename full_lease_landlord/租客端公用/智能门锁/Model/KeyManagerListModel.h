//
//  KeyManagerListModel.h
//  Door_Lock
//
//  Created by wz on 2020/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyManagerListModel : NSObject

@property (nonatomic, copy) NSString *Code;
@property (nonatomic, copy) NSString *keyName;
@property (nonatomic, copy) NSString *pageIndex;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *receiveName;
@property (nonatomic, copy) NSString *senderName;
@property (nonatomic, copy) NSString *operTime;
@property (nonatomic, copy) NSString *lockId;
@property (nonatomic, copy) NSString *keyId;
@property (nonatomic, assign)int isSelf;
@end

NS_ASSUME_NONNULL_END
