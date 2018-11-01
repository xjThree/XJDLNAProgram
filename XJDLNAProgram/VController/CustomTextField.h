//
//  CustomTextField.h
//  多屏互动
//
//  Created by WonderTek on 2018/10/9.
//  Copyright © 2018年 WonderTek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextField : UIView

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,copy) void(^valueCallBack)(NSIndexPath *indexPath);

@end
