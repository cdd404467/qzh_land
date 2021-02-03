//
//  JCBaseModel.m
//  YXJ
//
//  Created by wz.wang on 2020/6/30.
//  Copyright © 2020年 jc-h. All rights reserved.
//

#import "JCBaseModel.h"

id modelFromJsonDic(Class cls, NSDictionary *jsonDic, NSError *err) { return [cls mj_objectWithKeyValues:jsonDic]; }

NSMutableArray *modelsFromJsonArray(Class cls, NSArray *jsonArray, NSError *err) {
    return [cls mj_objectArrayWithKeyValuesArray:jsonArray];
}

@implementation JCBaseModel

#pragma mark public api

+ (NSDictionary *)replacedKeyFromPropertyName {
    return nil;
}

+ (NSArray *)ignoredPropertyNames {
    return nil;
}

/**
 *  数组中需要转换的模型类
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)objectClassInArray {
    return nil;
}

/**
 *  旧值换新值，用于过滤字典中的值
 *  @param oldValue 旧值
 *  @return 新值
 */
- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    return oldValue;
}

#pragma mark mj_methods

/**
 *  旧值换新值，用于过滤字典中的值
 *  @param oldValue 旧值
 *  @return 新值
 */
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    return [self rp_newValueFromOldValue:oldValue property:property];
}

/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (NSArray *)mj_ignoredPropertyNames {
    return [[self class] ignoredPropertyNames];
}

/**
 *  将属性名换为其他key去字典中取值
 *  @return key:属性名，value:字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return [[self class] replacedKeyFromPropertyName];
}

/**
 *  数组中需要转换的模型类
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)mj_objectClassInArray {
    return [[self class] objectClassInArray];
}

#pragma mark private methods

// 重写父类
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
   // NSLog(@"%@--%@", NSStringFromClass([self class]), key);
}

// 重写父类
- (void)setNilValueForKey:(NSString *)key {
  //  NSLog(@"%@--%@", NSStringFromClass([self class]), key);
}

- (id)rp_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    // 前置判断
    if (property.type.typeClass == [NSString class]) {
        if (oldValue == nil || [oldValue isEqual:[NSNull null]] || [oldValue isEqual:@"null"]) {
            return @"";
        }
    }
    return [self newValueFromOldValue:oldValue property:property];
}

- (id)copyWithZone:(NSZone *)zone {
    id copyInstance = [[[self class] allocWithZone:zone] init];
    size_t instanceSize = class_getInstanceSize([self class]);
    memcpy((__bridge void *)(copyInstance), (__bridge const void *)(self), instanceSize);
    return copyInstance;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    id copyInstance = [[[self class] allocWithZone:zone] init];
    size_t instanceSize = class_getInstanceSize([self class]);
    memcpy((__bridge void *)(copyInstance), (__bridge const void *)(self), instanceSize);
    return copyInstance;
}


// encode
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self mj_encode:aCoder];
}

// decoder
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self=[super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}

@end
