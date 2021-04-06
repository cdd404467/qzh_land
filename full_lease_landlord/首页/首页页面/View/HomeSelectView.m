//
//  HomeSelectView.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import "HomeSelectView.h"
#import "HomeSelectCell.h"


static NSString *iconCVID = @"HomeSelectCell";
@interface HomeSelectView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak)  UICollectionView *showCollectionView;
@end

@implementation HomeSelectView {
    NSArray *_icons;
    NSArray *_titles;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
       
        _icons = @[@"home_icon_1",@"home_icon_2",@"home_icon_3",@"home_icon_4",@"home_icon_6",@"home_icon_decorate",@"home_icon_shop"];
        _titles = @[@"我的租约",@"我的房源",@"签约确认",@"租客合同",@"轻资产服务",@"装修",@"商城"];
        //,@"推荐房东"  ,@"home_icon_5"
        [self setupSubviews:frame];
    }
    return self;
}

-(void)setupSubviews:(CGRect)frame{
    CGFloat viewW = frame.size.width;
    CGFloat viewH = frame.size.height;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(viewW / 3, viewH / 3);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *showCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,viewW,viewH) collectionViewLayout:flowLayout];
    showCollectionView.backgroundColor = [UIColor whiteColor];
    showCollectionView.delegate = self;
    showCollectionView.dataSource = self;
    showCollectionView.scrollEnabled = false;
    [showCollectionView registerClass:[HomeSelectCell class] forCellWithReuseIdentifier:iconCVID];
    [self addSubview:showCollectionView];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _titles.count;
}

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
