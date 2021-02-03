//
//  UITableView+Extension.m
//  full_lease_landlord
//
//  Created by apple on 2021/1/20.
//  Copyright © 2021 apple. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)

- (id)cddDequeueReusableCell:(Class)CellType {
    UITableViewCell *cell  = [self dequeueReusableCellWithIdentifier:NSStringFromClass(CellType)];
    if (cell == nil) {
        cell = [[CellType alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(CellType)];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (id)cddDequeueReusableHeaderFooter:(Class)HeaderFooterType {
    NSString *identifier = NSStringFromClass(HeaderFooterType);
    UITableViewHeaderFooterView *view  = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (view == nil) {
        view = [[HeaderFooterType alloc] initWithReuseIdentifier:identifier];
    }
    
    return view;
}


- (void)registerCell:(Class)CellType {
    [self registerClass:CellType forCellReuseIdentifier:NSStringFromClass(CellType)];
}

@end
