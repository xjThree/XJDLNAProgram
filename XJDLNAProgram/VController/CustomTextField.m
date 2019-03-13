//
//  CustomTextField.m
//  DLNA
//
//  Created by xjThree on 2018/10/9.
//  Copyright © 2018年 xjThree. All rights reserved.
//

#import "CustomTextField.h"
#import "Masonry.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface CustomTextField ()

@property (nonatomic,strong) UIButton *sendBtn;

@end

@implementation CustomTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        [self addSubview:self.textField];
        [self addSubview:self.sendBtn];

        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.center.equalTo(self);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(kScreenW-70);
        }];
        
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-5);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(40);
        }];
    }
    return self;
}

-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = @"请输入相应Value";
    }
    return _textField;
}
-(UIButton *)sendBtn{
    if (!_sendBtn ) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendBtn.backgroundColor = [UIColor blueColor];
        [_sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    [self.textField becomeFirstResponder];
}

- (void)sendClick{
    self.valueCallBack(self.indexPath);
}

@end
