//
//  UITableView+Extension.h
//  full_lease_landlord
//
//  Created by apple on 2021/1/20.
//  Copyright © 2021 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Extension)
- (id)cddDequeueReusableCell:(Class)CellType;
- (id)cddDequeueReusableHeaderFooter:(Class)HeaderFooterType;
- (void)registerCell:(Class)CellType;
@end

NS_ASSUME_NONNULL_END
