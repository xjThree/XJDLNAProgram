//
//  WDTransportResponseInfo.h
//  Demo3
//
//  Created by xjThree on 2018/9/4.
//  Copyright © 2018年 xjThree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDTransportResponseInfo : NSObject

@property (nonatomic, assign) NSInteger result;
@property (nonatomic, assign)       id  userData;
@property (nonatomic, copy)   NSString  *deviceUUID;
@property (nonatomic, copy)   NSString  *cur_transport_state;
@property (nonatomic, copy)   NSString  *cur_transport_status;
@property (nonatomic, copy)   NSString  *cur_speed;

- (instancetype)initWithResult:(NSInteger)result userData:(id)userData deviceUUID:(NSString *)deviceUUID;

@end

@interface WDTransportPositionInfo : WDTransportResponseInfo
/*
 NPT_UInt32    track;
 NPT_TimeStamp track_duration;
 NPT_String    track_metadata;
 NPT_String    track_uri;
 NPT_TimeStamp rel_time;
 NPT_TimeStamp abs_time;
 NPT_Int32     rel_count;
 NPT_Int32     abs_count;
 */
@property (nonatomic, assign) NSInteger track;
@property (nonatomic, assign) NSInteger rel_count;
@property (nonatomic, assign) NSInteger abs_count;
@property (nonatomic, copy)   NSString *track_uri;
@property (nonatomic, copy)   NSString *rel_time;
@property (nonatomic, copy)   NSString *abs_time;
@property (nonatomic, copy)   NSString *track_duration;
@property (nonatomic, copy)   NSString *track_metadata;

- (instancetype)initWithResult:(NSInteger)result userData:(id)userData deviceUUID:(NSString *)deviceUUID;

@end

@interface WDTransportVolumeInfo : WDTransportResponseInfo

@property (nonatomic, copy)NSString *channel;
@property (nonatomic, assign)NSInteger volume;

@end



