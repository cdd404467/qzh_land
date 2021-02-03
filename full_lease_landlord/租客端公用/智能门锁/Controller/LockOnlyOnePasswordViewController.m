//
//  LockOnlyOnePasswordViewController.m
//  FullLease
//
//  Created by wz on 2020/11/19.
//  Copyright © 2020 kad. All rights reserved.
//

#import "LockOnlyOnePasswordViewController.h"
#import "PasswordShowRectView.h"

@interface LockOnlyOnePasswordViewController ()

@end

@implementation LockOnlyOnePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitle = @"一次性密码";
    
    [self createUI];
}

-(void)createUI{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"door_lock_type"];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(JCNAVBar_H);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(JCWidth(192));
    }];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"亲爱的用户您好,\n您的有效期临时密码为：30分钟,请妥善保存"];
    NSMutableParagraphStyle *paragraphStyle  = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    
    UILabel *msgLab = [[UILabel alloc] init];
    msgLab.attributedText = attributedString;
    msgLab.textColor = UIColor.whiteColor;
    msgLab.font = kFont(18);
    msgLab.numberOfLines = 0;
    [imgView addSubview:msgLab];
    [msgLab setLineBreakMode:NSLineBreakByTruncatingTail];
    [msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(JCWidth(16));
        make.right.mas_equalTo(-JCWidth(16));
        make.top.mas_equalTo(imgView).offset(60);
    }];
    
    NSString *passwordOne = self.oneTimeModel.password;
    NSString *passwordOneStr = passwordOne?:@"********";
    PasswordShowRectView *passwordShowRectView = [PasswordShowRectView createPasswordShowRectView:passwordOneStr frame:CGRectZero];
    [self.view addSubview:passwordShowRectView];
    [passwordShowRectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(JCWidth(16));
        make.right.mas_equalTo(-JCWidth(16));
        make.height.mas_equalTo(JCWidth(84));
        make.top.equalTo(imgView.mas_bottom).offset(18);
    }];
    passwordShowRectView.passwordNums = passwordOneStr;
    passwordShowRectView.lockTitle = self.oneTimeModel.frontDoor ==1? @"外门锁密码": @"房间锁密码";

}

@end
