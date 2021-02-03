//
//  SendKeyQRcodeCell.m
//  Door_Lock
//
//  Created by wz on 2020/11/29.
//

#import "SendKeyQRcodeCell.h"
#import <YBImageBrowser.h>
#import <SDWebImage.h>

@implementation SendKeyQRcodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return  self;
}

-(void)setupSubviews{
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"发送钥匙前，请先扫描下方二维码下载智能门锁APP，注册账号。注册账号成功后发送钥匙。";
    titleLab.textColor = UIColorFromHex(0xD0021B);
    titleLab.font = kFont(12);
    titleLab.numberOfLines = 0;
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(JCWidth(16));
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-JCWidth(16));
    }];
    
    NSString *url = [kUserDefaults objectForKey:KlockAppLink];
    UIButton *orCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [orCode addTarget:self action:@selector(clickQr) forControlEvents:UIControlEventTouchUpInside];
    [orCode sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
    [self.contentView addSubview:orCode];
    [orCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(JCWidth(98), JCWidth(98)));
        make.top.mas_equalTo(titleLab.mas_bottom).offset(JCWidth(50));
        make.centerX.equalTo(self.contentView);
    }];
    
    UILabel *scaleLab = [[UILabel alloc] init];
    scaleLab.text = @"点击放大";
    scaleLab.textColor = MainColor;
    scaleLab.font = kFont(12);
    [self.contentView addSubview:scaleLab];
    [scaleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(orCode.mas_bottom).offset(JCWidth(20));
    }];
    
}

-(void)clickQr{
    
    NSString *url = [kUserDefaults objectForKey:KlockAppLink];
    
    
    NSMutableArray *datas = [NSMutableArray array];

    YBIBImageData *data = [YBIBImageData new];
    data.imageURL = [NSURL URLWithString:url];
    [datas addObject:data];

    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = 0;
    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
    [browser show];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
