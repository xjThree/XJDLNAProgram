//
//  WDTransportResponseInfo.m
//  Demo3
//
//  Created by xjThree on 2018/9/4.
//  Copyright © 2018年 xjThree. All rights reserved.
//

#import "WDTransportResponseInfo.h"

@implementation WDTransportResponseInfo

- (instancetype)initWithResult:(NSInteger)result userData:(id)userData deviceUUID:(NSString *)deviceUUID{
    if (self = [super init]) {
        self.result = result;
        self.userData = userData;
        self.deviceUUID = deviceUUID;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"result:%ld\nuserData:%@\ndeviceUUID:%@\ncur_transport_state:%@\ncur_transport_status:%@\ncur_speed:%@\n", self.result,self.userData,self.deviceUUID,self.cur_transport_state,self.cur_transport_status,self.cur_speed];
}

@end

@implementation WDTransportPositionInfo

- (instancetype)initWithResult:(NSInteger)result  userData:(id)userData deviceUUID:(NSString *)deviceUUID{
    if (self = [super initWithResult:result userData:userData deviceUUID:deviceUUID]) {
        self.result = result;
        self.userData = userData;
        self.deviceUUID = deviceUUID;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"track:%ld\nrel_count:%ld\nabs_count:%ld\ntrack_uri:%@\nrel_time:%@\nabs_time:%@\ntrack_duration:%@\ntrack_metadata:%@\n", self.track,self.rel_count,self.abs_count,self.track_uri,self.rel_time,self.abs_time,self.track_duration,self.track_metadata];
}

@end

@implementation WDTransportVolumeInfo
/*
 @property (nonatomic, copy)NSString *channel;
 @property (nonatomic, assign)NSInteger volume;
 */
- (NSString *)description
{
    return [NSString stringWithFormat:@"channel:%@\nvolume:%ld\n", self.channel,self.volume];
}

//- (instancetype)initWithResult:(NSInteger)result userData:(id)userData deviceUUID:(NSString *)deviceUUID{
//    if (self = [super initWithResult:result userData:userData deviceUUID:deviceUUID]) {
//        self.result = result;
//        self.userData = userData;
//        self.deviceUUID = deviceUUID;
//    }
//    return self;
//}

@end

