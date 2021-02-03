//
//  CommonlyUsedTools.m
//  FullLease
//
//  Created by wz on 2020/7/26.
//  Copyright © 2020 kad. All rights reserved.
//

#import "CommonlyUsedTools.h"
#import "MeToolItemCell.h"

#define Photo_Margin JCWidth(0)
#define CCP_count 4

@interface CommonlyUsedTools ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *showCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation CommonlyUsedTools{
    NSArray *_icons;
    NSArray *_titles;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
         [self setupSubviews:frame];
        //@"帮助反馈",@"银行卡管理",
        _titles = @[@"我的钱包",@"我的账单",@"租客账单",@"联系管家",@"智能门锁",@"系统管理"];
        _icons = @[@"tool_icon_1",@"tool_icon_2",@"tool_icon_3",@"tool_icon_6",@"tool_icon_smartdoor",@"tool_icon_7"];
        //@"tool_icon_4",@"tool_icon_5",
    }
    return self;
}

-(void)setupSubviews:(CGRect)frame{
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = KFit_W(32);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowLayout = flowLayout;
    _showCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,w,h) collectionViewLayout:flowLayout];
    _showCollectionView.backgroundColor = [UIColor whiteColor];
    _showCollectionView.delegate = self;
    _showCollectionView.dataSource = self;
    _showCollectionView.scrollEnabled = false;
    [_showCollectionView registerClass:[MeToolItemCell class] forCellWithReuseIdentifier:@"MeToolItemCell"];
    [self addSubview:self.showCollectionView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = self.width;
    CGFloat h = self.height;
    _showCollectionView.frame = CGRectMake(0,0,w,h);
    CGFloat itemW = w / CCP_count;
    _flowLayout.itemSize = CGSizeMake(itemW,KFit_W(54));
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _icons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MeToolItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeToolItemCell" forIndexPath:indexPath];
    cell.iconImage.image = [UIImage imageNamed:_icons[indexPath.row]];
    cell.nameLab.text = _titles[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickToolItem:)]){
           [self.delegate clickToolItem:indexPath.row];
       }
}


@end
