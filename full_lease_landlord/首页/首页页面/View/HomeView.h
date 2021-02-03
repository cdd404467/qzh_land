//
//  HomeView.h
//  full_lease_landlord
//
//  Created by apple on 2020/12/4.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HomeSelectViewDelegate <NSObject>

@optional

-(void)selectBannerItemWithIndex:(NSInteger)index;

@end

@interface HomeView : UIView
@property (nonatomic, weak) id<HomeSelectViewDelegate> delegate;
@end

@interface HomeBannerSecHeader : UICollectionReusableView

@end
NS_ASSUME_NONNULL_END
