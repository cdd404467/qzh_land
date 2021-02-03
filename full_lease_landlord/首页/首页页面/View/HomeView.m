//
//  HomeView.m
//  full_lease_landlord
//
//  Created by apple on 2020/12/4.
//  Copyright © 2020 apple. All rights reserved.
//

#import "HomeView.h"
#import "HomeSelectCell.h"
#import <SDCycleScrollView.h>

static NSString *iconCVID = @"HomeSelectCell";
@interface HomeView()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic, weak)  UICollectionView *showCollectionView;
@property (nonatomic, copy)NSArray *icons;
@property (nonatomic, copy)NSArray *titles;
@end


@implementation HomeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _icons = @[@"home_icon_1",@"home_icon_2",@"home_icon_3",@"home_icon_4",@"home_icon_6"];
        _titles = @[@"我的租约",@"我的房源",@"签约确认",@"租客合同",@"房屋托管"];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 3, KFit_W(85));
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = false;
    [collectionView registerClass:[HomeSelectCell class] forCellWithReuseIdentifier:iconCVID];
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _titles.count;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    //解决滚动条遮挡问题
    view.layer.zPosition = 0.0;
}

//设置header尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, KFit_W(220));
}

//设置头部
//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView *view = [UICollectionReusableView new];
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        
//    }
//    return view;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeSelectCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:iconCVID forIndexPath:indexPath];
    collectionCell.titleLab.text = _titles[indexPath.row];
    collectionCell.itemImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_icons[indexPath.row]]];
    return collectionCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectBannerItemWithIndex:)]) {
        [self.delegate selectBannerItemWithIndex:indexPath.row];
    }
}

@end


@implementation HomeBannerSecHeader

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
}

@end
