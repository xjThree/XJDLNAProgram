//
//  XJ_RenderDeviceModel.h
//  Demo3
//
//  Created by xjThree on 2018/8/31.
//  Copyright © 2018年 xjThree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJ_RenderDeviceModel : NSObject

//设备uuid
@property (nonatomic, copy) NSString *XJ_uuid;
//设备名称
@property (nonatomic, copy) NSString *XJ_name;
//生产商
@property (nonatomic, copy) NSString *XJ_producers;
//型号名
@property (nonatomic, copy) NSString *XJ_modelname;
//型号编号
@property (nonatomic, copy) NSString *XJ_modelNumber;
//设备生产串号
@property (nonatomic, copy) NSString *XJ_productionString;
//设备地址
@property (nonatomic, copy) NSString *XJ_deviceDescriptionURL;


@end
