//
//  JCBaseModel.h
//  YXJ
//
//  Created by houwen.wang on 2020/7/30.
//  Copyright © 2020年 jc-h. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>

#define JCMODEL(cls, jsonDic, err) modelFromJsonDic(cls, jsonDic, err)
#define JCMODELS(cls, jsonArray, err) modelsFromJsonArray(cls, jsonArray, err)

#define DictionaryToModel(Class, NSDictionary)                                                                     \
{                                                                                                                  \
    id value = [[Class alloc] init];                                                                               \
    [value setValuesForKeysWithDictionary:NSDictionary];                                                           \
    return value;                                                                                                  \
}

id modelFromJsonDic(Class cls, NSDictionary *jsonDic, NSError *err);
NSMutableArray *modelsFromJsonArray(Class cls, NSArray *jsonArray, NSError *err);

@interface JCBaseModel : NSObject<NSCopying,NSMutableCopying,NSCoding>

/**
 *  将属性名换为其他key去字典中取值
 *  @return key:属性名，value:字典中取值用的key
 */
+ (NSDictionary *)replacedKeyFromPropertyName;

/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (NSArray *)ignoredPropertyNames;

/**
 *  数组中需要转换的模型类
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)objectClassInArray;

/**
 *  旧值换新值，用于过滤字典中的值
 *  @param oldValue 旧值
 *  @return 新值
 */
- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property;

@end
