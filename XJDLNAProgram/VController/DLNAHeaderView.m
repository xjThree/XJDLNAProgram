//
//  DLNAHeaderView.m
//  多屏互动
//
//  Created by WonderTek on 2018/9/11.
//  Copyright © 2018年 WonderTek. All rights reserved.
//

#import "DLNAHeaderView.h"
#import "Masonry.h"

@interface DLNAHeaderView()
{
    UILabel *deviceIdLab;
    UIButton *sureBtn;
    UITextView *shortTextView;
    UITextView *longTextView;
    UILabel *conectStateLab;
}
@end
@implementation DLNAHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customView];
    }
    return self;
}

- (void)customView{
    deviceIdLab = [[UILabel alloc] init];
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shortTextView = [[UITextView alloc] init];
    longTextView = [[UITextView alloc] init];
    
    conectStateLab = [[UILabel alloc] init];
    [self addSubview:deviceIdLab];
    [self addSubview:sureBtn];
    [self addSubview:shortTextView];
    [self addSubview:longTextView];
    [self addSubview:conectStateLab];
    
    deviceIdLab.textAlignment = NSTextAlignmentCenter;
    shortTextView.textAlignment = NSTextAlignmentCenter;
    longTextView.textAlignment = NSTextAlignmentCenter;
    conectStateLab.textAlignment = NSTextAlignmentCenter;
    
    deviceIdLab.text = [NSString stringWithFormat:@"设备Id:%@",[[UIDevice currentDevice].identifierForVendor UUIDString]];
    
    [sureBtn setTitle:@"设置地址前缀:" forState:UIControlStateNormal];
    conectStateLab.text = @"未连接";
    sureBtn.titleLabel.numberOfLines = 0;
    sureBtn.backgroundColor = [UIColor orangeColor];
    
    deviceIdLab.textColor = shortTextView.textColor = longTextView.textColor = conectStateLab.textColor = [UIColor whiteColor];
    
    [deviceIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(30);
        make.width.mas_lessThanOrEqualTo([UIScreen mainScreen].bounds.size.width);
    }];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self->deviceIdLab.mas_bottom).offset(5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(65);
    }];
    
    [shortTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->sureBtn);
        make.left.equalTo(self->sureBtn.mas_right).offset(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(300);
    }];
    
    [longTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->shortTextView.mas_bottom).offset(5);
        make.left.equalTo(self->shortTextView);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(300);
    }];
    
    [conectStateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->longTextView.mas_bottom).offset(5);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(30);
        make.width.mas_lessThanOrEqualTo([UIScreen mainScreen].bounds.size.width);
    }];
}

-(void)setConnectDeviceState:(NSString *)connectDeviceState{
    conectStateLab.text = connectDeviceState;
}

@end
