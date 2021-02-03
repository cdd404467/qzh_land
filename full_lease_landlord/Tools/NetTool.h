//
//  NetTool.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkPort.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetTool : NSObject
//get
+ (void)getRequestWithHeader:(nullable NSDictionary *)headerDict requestUrl:(NSString *)requestUrl Params:(nullable id)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure;
+ (void)getRequest:(NSString *)requestUrl Params:(nullable id)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure;
+ (void)getRequestAsync:(NSString *)requestUrl Params:(nullable id)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure;

//Post
+ (void)postRequestWithHeader:(nullable NSDictionary *)headerDict requestUrl:(NSString *)requestUrl Params:(nullable id)params  Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure;
+ (void)postRequest:(NSString *)requestUrl Params:(nullable id)params  Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure;
+ (void)postRequestAsync:(NSString *)requestUrl Params:(nullable id)params  Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure;

//上传多个文件
+ (void)uploadWithMutilFile:(NSString *)requestUrl Params:(nullable id)params ImgsArray:(nullable NSArray *)ImgsArray Success:(void (^)(id json))success Failure:(void (^)(NSError * error))failure Progress:(void(^)(float percent))percent;
+ (void)downLoadRequest:(NSString *)requestUrl Params:(nullable id)params  Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure;

@end


//用来封装 上传文件 的数据模型
@interface FormData : NSObject
@property(nonatomic,strong)NSData * fileData;//文件数据
@property(nonatomic,copy)NSString * fileName;//文件名.jpg
@property(nonatomic,copy)NSString * name;//参数名
@property(nonatomic,copy)NSString * fileType;//文件类型
@end

NS_ASSUME_NONNULL_END
