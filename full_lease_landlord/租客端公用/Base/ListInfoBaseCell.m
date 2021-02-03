//
//  ListInfoBaseCell.m
//  FullLease
//
//  Created by wz on 2020/8/11.
//  Copyright © 2020 kad. All rights reserved.
//

#import "ListInfoBaseCell.h"

@interface ListInfoBaseCell ()<UITextFieldDelegate>

@property (nonatomic, strong) ListInfoBaseModel *model;

@end

@implementation ListInfoBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.textField.font = kFont(14);
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)refreshCellWithMode:(ListInfoBaseModel *)model andRow:(NSInteger)row{
    self.model = model;
    self.rightBtn.hidden = NO;
    self.detailLab.hidden = NO;
    self.textField.hidden = YES;
    if (model.type == ListInfoItemChangeRentType) {
        [self.rightBtn setTitle:@"修改租金" forState:UIControlStateNormal];
        [self.rightBtn setImage:nil forState:UIControlStateNormal];
        self.rightBtn.titleLabel.font = kFont(12);
        self.rightBtn.backgroundColor = MainColor;
        self.rigthBtnW.constant = JCWidth(74);
        self.rigthBtnH.constant = JCWidth(20);
        self.rightBtn.layer.cornerRadius = 4.5;
    }else if (model.type == ListInfoItemPhoneType){
        [self.rightBtn setTitle:nil forState:UIControlStateNormal];
        [self.rightBtn setImage:[UIImage imageNamed:@"call_phone"] forState:UIControlStateNormal];
        self.rightBtn.backgroundColor = [UIColor clearColor];
        self.rigthBtnW.constant = JCWidth(14);
        self.rigthBtnH.constant = JCWidth(14);
    }else if(model.type == ListInfoItemArrowType){
       [self.rightBtn setTitle:nil forState:UIControlStateNormal];
        [self.rightBtn setImage:[UIImage imageNamed:@"arrow_right_custom"] forState:UIControlStateNormal];
        self.tintColor = UIColorFromHex(0x999999);
        self.rightBtn.backgroundColor = [UIColor clearColor];
        self.rigthBtnW.constant = JCWidth(14);
        self.rigthBtnH.constant = JCWidth(14);
    }else if(model.type == ListInfoItemInputType){
        self.textField.hidden = NO;
        self.detailLab.hidden = YES;
        self.rigthBtnW.constant = 0;
        self.textField.placeholder = model.hintText;
        self.textField.text = model.subTitle;
    }else if (model.type == ListInfoItemVerCodeType){
        self.detailLab.hidden = YES;
        self.rigthBtnW.constant = 0;
        self.textField.hidden = NO;
        [self.rightBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self.rightBtn setImage:nil forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:MainColor forState:UIControlStateNormal];
        self.rightBtn.titleLabel.font = kFont(14);
        self.rigthBtnW.constant = JCWidth(88);
        self.rigthBtnH.constant = JCWidth(20);
        self.textField.placeholder = model.hintText;
    }
    else{
        self.rigthBtnW.constant = 0;
    }
    
    self.textField.delegate = self;
    self.titleLab.text = model.title;
    self.detailLab.text = model.subTitle;
}

- (IBAction)rightBtnClick:(id)sender {
   UITableView *tableview = (UITableView *)[self superview];
    NSIndexPath *indexPath = [tableview indexPathForCell:self];
    [self openCountdown];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCellBtn:)] && self.model.type == ListInfoItemVerCodeType) {
        [self.delegate clickCellBtn:indexPath.row];
    }
}

-(void)setShowBottomLine:(bool)showBottomLine{
    _showBottomLine = showBottomLine;
    self.bottomLine.hidden = !showBottomLine;
}

-(void)openCountdown{
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{

                //设置按钮的样式
                [self.rightBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
             [self.rightBtn setTitleColor:MainColor forState:UIControlStateNormal];
                self.rightBtn.userInteractionEnabled = YES;
            });

        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.rightBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                 [self.rightBtn setTitleColor:UIColorFromHex(0x999999) forState:UIControlStateNormal];
                self.rightBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.model.subTitle  = textField.text;
}

-(void)textFieldDidChangeSelection:(UITextField *)textField{
     self.model.subTitle  = textField.text;
}

@end
