//
//  XJ_DMRControl.h
//  Demo3
//
//  Created by xjThree on 2018/8/30.
//  Copyright © 2018年 xjThree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJ_RenderDeviceModel.h"
#import "WDTransportResponseInfo.h"

@protocol XJ_DMRProtocolDelegate <NSObject>
@optional

/**
 发现并添加DMR(媒体渲染器)
 */
-(void)onDMRAdded;

/**
 移除DMR
 */
-(void)onDMRRemoved;

- (void)getTransportInfoResponse:(WDTransportResponseInfo *)response;

- (void)getTransportPositionInfoResponse:(WDTransportPositionInfo *)response;

- (void)getVolumeResponse:(WDTransportVolumeInfo *)response;

- (void)setVolumeResponse:(WDTransportResponseInfo *)response;

- (void)OnSeekResult:(WDTransportResponseInfo *)response;

//-(void)previousResponse:(WDTransportResponseInfo *)response;
//
//-(void)nextResponse:(WDTransportResponseInfo *)response;
//
//-(void)DMRStateViriablesChanged:(WDTransportResponseInfo *)response;
//
//-(void)playResponse:(WDTransportResponseInfo *)response;
//
//-(void)pasuseResponse:(id *)response;
//
//-(void)stopResponse:(id *)response;
//
//-(void)setAVTransponrtResponse:(id *)response;


@end

@interface XJ_DMRControl : NSObject

@property (nonatomic,weak) id<XJ_DMRProtocolDelegate> delegate;

+ (instancetype)sharedInstance;

-(BOOL)isRunning;

- (void)start;

- (void)upnpStop;

- (NSArray <XJ_RenderDeviceModel *> *)getActiveRenders;

- (void)chooseRenderWithUUID:(NSString *)uuid;

- (void)renderSetAVTransportWithURI:(NSString *)url mediaInfo:(NSString *)Info;

- (void)play;

- (void)stop;

- (void)pause;

- (void)getInfo;

- (void)getPlayTimeForNow;

- (void)setSeekTime:(NSInteger)seekTime;

- (void)getVolume;

- (void)setVolume:(NSInteger)volume;

-(void)destruction; //释放销毁

@end
