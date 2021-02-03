//
//  NetTool.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import "NetTool.h"
#import <AFNetworking.h>
#import "BaseViewController.h"
#import "LoginVC.h"

@implementation NetTool
+ (void)dealErrorWithJson:(id)json {
    //token 过期
    if ([json[@"code"] integerValue] == 401) {
        [UserDefault removeObjectForKey:@"userInfo"];
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationName_UserExitLogin object:nil userInfo:nil];
        BaseViewController *baseVC = (BaseViewController *)[HelperTool getCurrentVC];
        if (![baseVC isKindOfClass:[LoginVC class]]) {
            [baseVC jumpToLoginWithComplete:nil];
        }
    }
}

+ (void)showErrorMsg:(NSString *)msg {
    [CddHud hideHUD:nil];
    [CddHud showTextOnly:msg view:nil];
}

//请求出错显示HUD
+ (void)showFailMsg:(NSDictionary *)dict {
    NSData *errorData = [dict objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSDictionary *msgDict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
    [self showErrorMsg:msgDict[@"message"]];
    NSLog(@"Error-------- : %@",msgDict);
}

/* 网络请求封装  */

// Get请求
+ (void)getRequest:(NSString *)requestUrl Params:(nullable id)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure {
    NSDictionary *headerDict = @{@"Authorization":User_Token};
    [self getRequestWithHeader:headerDict requestUrl:requestUrl Params:params Success:success Failure:failure];
}

+ (void)getRequestWithHeader:(NSDictionary *)headerDict requestUrl:(NSString *)requestUrl Params:(nullable id)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure {
//    NSURL *URL = [NSURL URLWithString:Server_Api(requestUrl)];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    requestUrl = Server_Api(requestUrl);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30.0f;
                                      
    //json序列化
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    for (NSString *key in [headerDict allKeys]) {
        [manager.requestSerializer setValue:headerDict[key] forHTTPHeaderField:key];
    }
    //解决解析<null>崩溃
//    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    [manager GET:requestUrl parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
            if ([responseObject[@"code"] integerValue] != 200) {
                [self showErrorMsg:responseObject[@"message"]];
                [self dealErrorWithJson:responseObject];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            [self showErrorMsg:error.localizedDescription];
        }
        
    }];
}

+ (void)getRequestAsync:(NSString *)requestUrl Params:(nullable id)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure {
//    NSURL *URL = [NSURL URLWithString:Server_Api(requestUrl)];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    requestUrl = Server_Api(requestUrl);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30.0f;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:User_Token forHTTPHeaderField:@"Authorization"];
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [manager GET:requestUrl parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
            if ([responseObject[@"code"] integerValue] != 200) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showErrorMsg:responseObject[@"message"]];
                        [self dealErrorWithJson:responseObject];
                    });
                });
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showErrorMsg:error.localizedDescription];
                });
            });
        }
    }];
}

// Post请求
+ (void)postRequest:(NSString *)requestUrl Params:(nullable id)params  Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure {
    NSDictionary *headerDict = @{@"Authorization":User_Token};
    [self postRequestWithHeader:headerDict requestUrl:requestUrl Params:params Success:success Failure:failure];
}

// Post请求
+ (void)postRequestWithHeader:(NSDictionary *)headerDict requestUrl:(NSString *)requestUrl Params:(nullable id)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure {
//    NSURL *URL = [NSURL URLWithString:Server_Api(requestUrl)];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    requestUrl = Server_Api(requestUrl);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    for (NSString *key in [headerDict allKeys]) {
//        [manager.requestSerializer setValue:headerDict[key] forHTTPHeaderField:key];
//    }
    //发送Post请求
    [manager POST:requestUrl parameters:params headers:headerDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //json如果不是字典,万一是字典如果不包含code这个key的话，就返回json
//        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (success) {
            success(responseObject);
            if ([responseObject[@"code"] integerValue] != 200) {
                [self showErrorMsg:responseObject[@"message"]];
                [self dealErrorWithJson:responseObject];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            [self showErrorMsg:error.localizedDescription];
        }
    }];
}


// Post请求
+ (void)postRequestAsync:(NSString *)requestUrl Params:(nullable id)params  Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure {
//    NSURL *URL = [NSURL URLWithString:Server_Api(requestUrl)];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    requestUrl = Server_Api(requestUrl);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [manager.requestSerializer setValue:User_Token forHTTPHeaderField:@"Authorization"];
    //发送Post请求
    [manager POST:requestUrl parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
            if ([responseObject[@"code"] integerValue] != 200) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showErrorMsg:responseObject[@"message"]];
                        [self dealErrorWithJson:responseObject];
                    });
                });
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showErrorMsg:error.localizedDescription];
                });
            });
        }
    }];
}

//// 上传多个文件请求
+ (void)uploadWithMutilFile:(NSString *)requestUrl Params:(nullable id)params ImgsArray:(nullable NSArray *)ImgsArray Success:(void (^)(id json))success Failure:(void (^)(NSError * error))failure Progress:(void(^)(float percent))percent {
//    NSURL *URL = [NSURL URLWithString:Server_Api(requestUrl)];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    requestUrl = Server_Api(requestUrl);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:User_Token forHTTPHeaderField:@"Authorization"];
    [manager POST:requestUrl parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (FormData *data in ImgsArray) {
            [formData appendPartWithFileData:data.fileData
                                        name:data.name
                                    fileName:data.fileName
                                    mimeType:data.fileType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
            if ([responseObject[@"code"] integerValue] != 200) {
                [self showErrorMsg:responseObject[@"message"]];
                [self dealErrorWithJson:responseObject];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error-------- : %@",error);
        if (failure) {
            failure(error);
            [self showErrorMsg:error.localizedDescription];
        }
    }];
}

// 下载请求
+ (void)downLoadRequest:(NSString *)requestUrl Params:(nullable id)params  Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURL *URL = [NSURL URLWithString:requestUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (success) {
            success(filePath);
        }
        if (error) {
            [self showErrorMsg:error.localizedDescription];
        }
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}



@end

@implementation FormData
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fileType = @"";
        self.name = @"";
    }
    return self;
}
@end
