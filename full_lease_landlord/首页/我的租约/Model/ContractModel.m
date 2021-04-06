//
//  ContractModel.m
//  FullLease
//
//  Created by apple on 2020/8/25.
//  Copyright © 2020 kad. All rights reserved.
//

#import "ContractModel.h"

@implementation ContractModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"conID":@"id"
    };
}

- (NSString *)statusStr {
    if (!_statusStr) {
        if (self.status == 1) {
            _statusStr = @"待签约";
        } else if (self.status == 2) {
            _statusStr = @"续租在租";
        } else if (self.status == 4) {
            _statusStr = @"待搬入";
        } else if (self.status == 5) {
            _statusStr = @"在租中";
        } else if (self.status == 6) {
            _statusStr = @"逾期";
        } else if (self.status == 7) {
            _statusStr = @"已退租";
        } else if (self.status == 8) {
            _statusStr = @"作废";
        } else if (self.status == 13) {
            _statusStr = @"退租审核中";
        } else if (self.status == 10) {
            _statusStr = @"退租未结账";
        } else {
            _statusStr = @"- - !";
        }
    }
    return _statusStr;
}



@end


@implementation GradingModel


@end


@implementation OtherChargeModel


@end


@implementation TrentFreeModel


@end


@implementation OtherModel


@end
