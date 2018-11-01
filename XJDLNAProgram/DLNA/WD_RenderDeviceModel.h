//
//  WD_RenderDeviceModel.h
//  Demo3
//
//  Created by WonderTek on 2018/8/31.
//  Copyright © 2018年 WonderTek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WD_RenderDeviceModel : NSObject

//设备uuid
@property (nonatomic, copy) NSString *wd_uuid;
//设备名称
@property (nonatomic, copy) NSString *wd_name;
//生产商
@property (nonatomic, copy) NSString *wd_producers;
//型号名
@property (nonatomic, copy) NSString *wd_modelname;
//型号编号
@property (nonatomic, copy) NSString *wd_modelNumber;
//设备生产串号
@property (nonatomic, copy) NSString *wd_productionString;
//设备地址
@property (nonatomic, copy) NSString *wd_deviceDescriptionURL;


@end
