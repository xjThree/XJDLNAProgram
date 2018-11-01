//
//  WD_DMRControl.m
//  Demo3
//
//  Created by WonderTek on 2018/8/30.
//  Copyright © 2018年 WonderTek. All rights reserved.
//

#import "WD_DMRControl.h"
#import "PltMediaController.h"
#import <Platinum/Platinum.h>

@interface WD_DMRControl()
{
    PLT_UPnP *upnp;
    PltMediaController *controller;
    
}
@end
@implementation WD_DMRControl
 static WD_DMRControl *dmrControl;

+ (instancetype)sharedInstance{
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dmrControl = [[WD_DMRControl alloc] init];
    });
    return dmrControl;
}

- (instancetype)init
{
    if (self = [super init]) {
        upnp = new PLT_UPnP();
        PLT_CtrlPointReference ctrlPoint(new PLT_CtrlPoint());
        upnp->AddCtrlPoint(ctrlPoint);
        controller = new PltMediaController(ctrlPoint,self);
    }
    return self;
}

-(void)destruction{
    delete upnp;
    delete controller;
}

-(BOOL)isRunning
{
    if (upnp->IsRunning()) {
        return YES;
    }else{
        return NO;
    }
}

- (void)start{
    if(!upnp->IsRunning()){
        upnp->Start();
    }else{
        NSLog(@"Upnp Serverce Is Start");
        [self upnpStop];
        [self start];
    }
}

- (void)upnpStop{
    if(upnp->IsRunning()){
        upnp->Stop();
    }else{
        NSLog(@"Upnp Serverce already disconnected");
    }
}

- (NSArray<WD_RenderDeviceModel*> *)getActiveRenders{
    NSMutableArray<WD_RenderDeviceModel *> *renderArray = [NSMutableArray new];
    const PLT_StringMap rendersNameTable = controller->getMediaRenderersNameTable();
    NPT_List<PLT_StringMapEntry *>::Iterator entry = rendersNameTable.GetEntries().GetFirstItem();
    while (entry) {
        WD_RenderDeviceModel * renderModel = [[WD_RenderDeviceModel alloc] init];
        renderModel.wd_name = [NSString stringWithUTF8String:(const char *)(*entry)->GetValue()];
        renderModel.wd_uuid = [NSString stringWithUTF8String:(const char *)(*entry)->GetKey()];
        
        [renderArray addObject:renderModel];
        ++entry;
    }
    
    return renderArray;
}

- (void)chooseRenderWithUUID:(NSString *)uuid{
    if (![uuid isEqualToString:@""]) {
        controller->chooseMediaRenderer([uuid UTF8String]);
    }else{
        NSLog(@"UUID不能为空");
    }
}
- (void)renderSetAVTransportWithURI:(NSString *)url mediaInfo:(NSString *)Info{
    if (![url isEqualToString:@""]) {
        controller->setRendererAVTransportURI([url UTF8String], [Info UTF8String]);
    }else{
        NSLog(@"URL不能为空");
    }
}

//播放
- (void)play{
    controller->setRendererPlay();
}

//停止
- (void)stop{
    controller->setRendererStop();
}

//暂停
- (void)pause{
    controller->setRendererPause();
}

//跳转到进度
- (void)setSeekTime:(NSInteger)seekTime{
    NSString *timeString = [self getMMSSFromSS:seekTime];
    const char *cString = (const char *)[timeString UTF8String];
    controller->setSeekTime(cString);
}

//播放信息
- (void)getInfo{
    controller->getTransportInfo();
}

//获取当前播放时间
- (void)getPlayTimeForNow
{
    controller->getTransportPlayTimeForNow();
}

//获取播放音量
- (void)getVolume {
    controller->getRendererVolume();
}

- (void)setVolume:(NSInteger)volume{
    int newVolume = (int)volume;
    controller->setRenderVolume(newVolume);
}


///秒转时分秒字符串
-(NSString *)getMMSSFromSS:(NSInteger)totalTime{

    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",totalTime/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(totalTime%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",totalTime%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
    
}



@end
