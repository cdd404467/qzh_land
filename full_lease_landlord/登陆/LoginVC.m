//
//  LoginVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import "LoginVC.h"
#import "UITextField+Limit.h"
#import "HWTFCursorView.h"
#import "CustomTextfieldView.h"
#import "UserInfoModel.h"
#import <JPUSHService.h>

@interface LoginVC ()<UITextViewDelegate,UITextFieldDelegate,HWTFCursorViewDelegate>
@property (nonatomic, weak) UIButton *verCodeBtn;
@property (nonatomic, weak) HWTFCursorView *codeView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) CustomTextfieldView *phoneView;
@property (nonatomic, weak) UILabel *verHint;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"登录/注册";
    self.navBar.titleColor = UIColor.whiteColor;
    [self.navBar.leftBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.navBar.backMode = 1;
    self.navBar.backgroundColor = UIColor.clearColor;
    self.navBar.backBtnTintColor = UIColor.whiteColor;
    [self setupUI];
    
}

- (void)setupUI {
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImageView.image = [UIImage imageNamed:@"lgon_background_img"];
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:backImageView atIndex:0];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - NAV_HEIGHT);
    scrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:scrollView];
    scrollView.scrollEnabled = NO;
    self.scrollView = scrollView;
    
    UILabel *helloLabel = [[UILabel alloc] init];
    helloLabel.text = @"Hi~";
    helloLabel.textColor = [UIColor whiteColor];
    helloLabel.font = kFont(30);
    [helloLabel sizeToFit];
    helloLabel.left = KFit_W(34);
    helloLabel.top = KFit_H(75);
    [scrollView addSubview:helloLabel];
    
    UILabel *welcomeLabel = [[UILabel alloc] init];
    welcomeLabel.text = @"欢迎来到全住托管平台";
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.font = bkFont(24);
    [welcomeLabel sizeToFit];
    welcomeLabel.left = KFit_W(34);
    welcomeLabel.top = helloLabel.bottom + KFit_H(14);
    [scrollView addSubview:welcomeLabel];
    
    CustomTextfieldView *phone = [[CustomTextfieldView alloc]initWithFrame:CGRectMake(KFit_W(34), welcomeLabel.bottom + KFit_W(52), SCREEN_WIDTH-KFit_W(34) * 2, KFit_H(50))];
    phone.placeholderColor = HEXColor(@"#BBBBBB", 1);
    phone.placeholder = @"请输入手机号";
    phone.Regex = @"^(0|86|17951)?(13[0-9]|15[0-9]|17[0-9]|18[0-9]|14[0-9]|19[0-9]|16[0-9])[0-9]{8}$";
    ;
    phone.KTextfield.maxLength = 11;
//    phone.KTextfield.delegate = self;
    [phone.KTextfield addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    phone.KTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [scrollView addSubview:phone];
    self.phoneView = phone;
    
    UIButton *verCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    verCodeBtn.frame = CGRectMake(KFit_W(34),phone.bottom + KFit_W(30),SCREEN_WIDTH - KFit_W(68),KFit_W(50));
    verCodeBtn.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:0.46];
    verCodeBtn.layer.cornerRadius = 4;
    verCodeBtn.enabled = false;
    [verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verCodeBtn addTarget:self action:@selector(clickFetchVerCode) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:verCodeBtn];
    self.verCodeBtn = verCodeBtn;
    
    NSString *str = @"登录即代表您同意《用户使用条款》与《隐私保护政策》";
    NSString *PrivacyStr = @"《用户使用条款》";
    NSString *UserStr = @"《隐私保护政策》";
    NSMutableAttributedString *MAttributedString = [[NSMutableAttributedString alloc]initWithString:str];
    
    if ([str rangeOfString:PrivacyStr].location!=NSNotFound) {
        [MAttributedString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"PrivacyStr://"] range:[[MAttributedString string] rangeOfString:PrivacyStr]];
    }
    if ([str rangeOfString:UserStr].location!=NSNotFound) {
        [MAttributedString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"UserStr://"] range:[[MAttributedString string] rangeOfString:UserStr]];
    }
    
    UITextView *msgTextView = [[UITextView alloc] initWithFrame:CGRectMake(KFit_W(34),verCodeBtn.bottom + KFit_W(30),SCREEN_WIDTH - KFit_W(68), KFit_H(40))];
    msgTextView.editable = NO;
    NSDictionary *linkAttributes =@{NSForegroundColorAttributeName: HEXColor(@"#D5D5D5", 1)};
    msgTextView.linkTextAttributes = linkAttributes;
    msgTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    msgTextView.delegate = self;
    msgTextView.attributedText = MAttributedString;
    msgTextView.backgroundColor = [UIColor clearColor];
    msgTextView.textColor = HEXColor(@"#D5D5D5", 1);
    msgTextView.font = kFont(11);
    [scrollView addSubview:msgTextView];
    
    UIView *verView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_HEIGHT, SCREEN_HEIGHT)];
    [scrollView addSubview:verView];
    
    UILabel *verTitle = [[UILabel alloc] init];
    verTitle.text = @"请输入验证码";
    verTitle.textColor = [UIColor whiteColor];
    verTitle.font = bkFont(24);
    [verTitle sizeToFit];
    verTitle.left = KFit_W(31);
    verTitle.top = KFit_H(130);
    [verView addSubview:verTitle];
    
    UILabel *verHint = [[UILabel alloc] init];
    verHint.text = @"验证码已发送至手机：";
    verHint.textColor = HEXColor(@"#F0F0F0", 1);
    verHint.font = kFont(14);
    [verHint sizeToFit];
    verHint.left = KFit_W(31);
    verHint.top = verTitle.bottom + KFit_W(11);
    verHint.width = SCREEN_WIDTH - KFit_W(16);
    [verView addSubview:verHint];
    self.verHint = verHint;
    
    HWTFCursorView *codeView = [[HWTFCursorView alloc] initWithCount:6 margin:12];
    codeView.frame = CGRectMake(KFit_W(31), verHint.bottom + KFit_H(20), SCREEN_WIDTH-KFit_W(62), KFit_W(60));
    [verView addSubview:codeView];
    codeView.delegate = self;
    self.codeView = codeView;
    
    UILabel *fetchVer = [[UILabel alloc] init];
    fetchVer.text = @"获取验证码";
    fetchVer.font = kFont(14);
    fetchVer.textColor = [UIColor whiteColor];
    [fetchVer sizeToFit];
    fetchVer.left = KFit_W(31);
    fetchVer.top = codeView.bottom + KFit_H(28);
    [verView addSubview:fetchVer];
}

//    - (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
//    {
//        if ([[URL scheme] containsString:@"PrivacyStr"]) {
//            NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
//            SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:url];
//            [self presentViewController:safariVc animated:YES completion:nil];
//        }
//        if ([[URL scheme] containsString:@"UserStr"]) {
//            NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
//            SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:url];
//            [self presentViewController:safariVc animated:YES completion:nil];
//        }
//        return NO;//跳转到浏览器
//    }

#pragma mark ----------------- textfieldView -----------------
//-(void)textFieldDidChangeSelection:(UITextField *)textField {
//    if(textField.text.length == 11) {
//        self.verCodeBtn.enabled = true;
//        self.verCodeBtn.backgroundColor = HEXColor(@"#28C3CE", 1);
//    } else {
//        self.verCodeBtn.enabled = false;
//        self.verCodeBtn.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:0.46];
//    }
//}

- (void)textFieldTextDidChange:(UITextField *)tf {
    if(tf.text.length == 11) {
        self.verCodeBtn.enabled = true;
        self.verCodeBtn.backgroundColor = HEXColor(@"#28C3CE", 1);
    } else {
        self.verCodeBtn.enabled = false;
        self.verCodeBtn.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:0.46];
    }
}

/**验证完成*/
-(void)verificationCodeInputIsComplete:(NSString *)code{//25
    /**测试用*/
//    if([code isEqualToString:@"111111"] ){
//        code = @"1111";
//    }
    NSDictionary *parameters = @{
        @"userPhone":self.phoneView.KTextfield.text,
        @"userType":@1,
        @"SMSCode":code
    };
    [NetTool postRequest:URLPost_user_Login Params:parameters Success:^(id  _Nonnull json) {
        if ([json[@"code"] integerValue] == 200) {
            //登录成功回调
            if (self.loginCompleteBlock) {
                self.loginCompleteBlock();
            }
            UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:json[@"data"][@"userinfo"]];
            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:0];
            [mDict setValue:json[@"data"][@"Authorization"] forKey:@"token"];
            [mDict setValue:model.userName forKey:@"userName"];
            [mDict setValue:model.userMoney forKey:@"userMoney"];
            [mDict setValue:model.userPhone forKey:@"userPhone"];
            [mDict setValue:model.userid forKey:@"id"];
            [UserDefault setObject:[mDict copy] forKey:@"userInfo"];
            [self isSetPassWord];
            [[NSNotificationCenter defaultCenter]postNotificationName:NotificationName_UserLoginSuccess object:nil userInfo:nil];
            [self dismiss];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)isSetPassWord {
    __block NSMutableDictionary *mdict = [User_Info mutableCopy];
    [NetTool getRequest:URLGet_IsSet_Password Params:nil Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            if ([json[@"data"][@"result"] integerValue] == 1) {
                [mdict setValue:@"1" forKey:@"isSetPW"];
            } else {
                [mdict setValue:@"0" forKey:@"isSetPW"];
            }
        } else {
            [mdict setValue:@"-1" forKey:@"isSetPW"];
        }
        [UserDefault setObject:[mdict copy] forKey:@"userInfo"];
    } Failure:^(NSError * _Nonnull error) {
        [mdict setValue:@"-2" forKey:@"isSetPW"];
    }];
}


-(void)clickFetchVerCode{
    NSString *jpushStr = [NSString string];
    if (JPushID) {
        jpushStr = JPushID;
    } else {
        jpushStr = [JPUSHService registrationID];
    }
    if (!jpushStr)
        jpushStr = @"";
    
    NSDictionary *dict = @{@"userPhone":self.phoneView.KTextfield.text,
                           @"userType":@1,
                           @"uniqueDeviceIdentification":jpushStr
    };
    
    [NetTool postRequest:URLPost_SMS_Code Params:dict Success:^(id  _Nonnull json) {
        if ([json[@"code"] integerValue] == 200) {
            [CddHud showTextOnly:@"获取验证码成功" view:self.view];
            self.verHint.text = [NSString stringWithFormat:@"验证码已发送至手机：%@",self.phoneView.KTextfield.text];
            /**滚动显示验证码界面*/
            self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
            [self.codeView.textField becomeFirstResponder];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
