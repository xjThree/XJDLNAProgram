//
//  PltMediaController.m
//  Demo3
//
//  Created by WonderTek on 2018/8/30.
//  Copyright © 2018年 WonderTek-XJ. All rights reserved.
//

#import "PltMediaController.h"

#define CHARTONSSTRING(x) [NSString stringWithUTF8String:x]
#define LONGLONGSTRING(x) [NSString stringWithFormat:@"%lld",x]

PltMediaController::PltMediaController(PLT_CtrlPointReference& ctrlPoint,WD_DMRControl * delegateWrapper) :
PLT_SyncMediaBrowser(ctrlPoint),
PLT_MediaController(ctrlPoint),
wd_Target(delegateWrapper)
{
    wd_CurBrowseDirectoryStack.Push("0");
    
    PLT_MediaController::SetDelegate(this);
}

PltMediaController::~PltMediaController()
{
}

void
PltMediaController::GetCurMediaRenderer(PLT_DeviceDataReference &renderer){
    NPT_AutoLock lock(wd_CurMediaRendererLock);
    if (wd_CurMediaRenderer.IsNull()) {
        //没有索索到设备
    }else{
        renderer = wd_CurMediaRenderer;
    }
}

const PLT_StringMap
PltMediaController:: getMediaRenderersNameTable()
{
    const NPT_Lock<PLT_DeviceMap>& deviceList = wd_MediaRenderers;
    
    PLT_StringMap            namesTable;
    NPT_AutoLock             lock(wd_MediaServers);
    
    // create a map with the device UDN -> device Name
    const NPT_List<PLT_DeviceMapEntry*>& entries = deviceList.GetEntries();
    NPT_List<PLT_DeviceMapEntry*>::Iterator entry = entries.GetFirstItem();
    while (entry) {
        PLT_DeviceDataReference device = (*entry)->GetValue();
        NPT_String              name   = device->GetFriendlyName();
        namesTable.Put((*entry)->GetKey(), name);
        ++entry;
    }
    
    return namesTable;
}

/**
 绑定设备
 */
void PltMediaController::chooseMediaRenderer(NPT_String chosenUUID)
{
    NPT_AutoLock lock(wd_CurMediaRendererLock);
    
    wd_CurMediaRenderer = ChooseDevice(wd_MediaRenderers, chosenUUID);
}

///查找设备
PLT_DeviceDataReference
PltMediaController::ChooseDevice(const NPT_Lock<PLT_DeviceMap>& deviceList, NPT_String chosenUUID)
{
    PLT_DeviceDataReference* result = NULL;
    
    if (chosenUUID.GetLength()) {
        deviceList.Get(chosenUUID, result);
    }
    return result?*result:PLT_DeviceDataReference(); // return empty reference if not device was selected
}


/**
 推屏
 */
void
PltMediaController::setRendererAVTransportURI(const char *uriStr, const char *metaData){
    PLT_DeviceDataReference device;
    GetCurMediaRenderer(device); //检查设备
    if(!device.IsNull()){
        bool result = NPT_FAILED(SetAVTransportURI(device, 0, uriStr, metaData==NULL?"":metaData, NULL));
        if (result) {
            NSLog(@"set uri failed");
        }
    }
}


/**
 播放
 */
void
PltMediaController::setRendererPlay()
{
    PLT_DeviceDataReference device;
    GetCurMediaRenderer(device);
    if (!device.IsNull()) {
        Play(device, 0, "1", NULL);
    }
}


/**
 退出播放
 */
void
PltMediaController::setRendererStop()
{
    PLT_DeviceDataReference device;
    GetCurMediaRenderer(device);
    if (!device.IsNull()) {
        Stop(device, 0, NULL);
    }
}


/**
 暂停播放
 */
void
PltMediaController::setRendererPause()
{
    PLT_DeviceDataReference device;
    GetCurMediaRenderer(device);
    if (!device.IsNull()) {
        Pause(device, 0, NULL);
    }
}


/**
 获取播放状态
 */
void
PltMediaController::getTransportInfo()
{
    PLT_DeviceDataReference device;
    GetCurMediaRenderer(device);
    if (!device.IsNull()) {
       GetTransportInfo(device, 0, NULL);
    }
}

/*
 获取当前播放时间
 */
void
PltMediaController::getTransportPlayTimeForNow(){
    PLT_DeviceDataReference device;
    GetCurMediaRenderer(device);
    if (!device.IsNull()) {
        GetPositionInfo(device, 0, NULL);
    }
}


/**
 获取当前音量
 */
void
PltMediaController::getRendererVolume()
{
    PLT_DeviceDataReference device;
    GetCurMediaRenderer(device);
    if (!device.IsNull()) {
        GetVolume(device, 0, "Master", NULL);
    }
}

/**
 设置音量
 */
void
PltMediaController::setRenderVolume(int volume){
    PLT_DeviceDataReference device;
    GetCurMediaRenderer(device);
    if (!device.IsNull()) {
        SetVolume(device, 0, "Master", volume, NULL);
    }
}

/**
 快进
 */
void
PltMediaController::setSeekTime(const char* command){
    PLT_DeviceDataReference device;
    GetCurMediaRenderer(device);
    if (!device.IsNull()) {
//        NPT_String target = command;
        Seek(device, 0, "REL_TIME", command, NULL);
    }
}


#pragma mark 父类的回调
/**
 发现设备进行代理回调
 */
bool
PltMediaController::OnMRAdded(PLT_DeviceDataReference& device)
{
    NPT_String uuid = device->GetUUID();
    // test if it's a media renderer
    PLT_Service* service;
    if (NPT_SUCCEEDED(device->FindServiceByType("urn:schemas-upnp-org:service:AVTransport:*", service)))
    {
        NPT_AutoLock lock(wd_MediaRenderers);
        wd_MediaRenderers.Put(uuid, device);
    }
    if(wd_Target.delegate && [wd_Target.delegate respondsToSelector:@selector(onDMRAdded)])
    {
        [wd_Target.delegate onDMRAdded];
    }
    
    return true;
}

/**
 请求播放状态回调
 */
void
PltMediaController::OnGetTransportInfoResult(NPT_Result res, PLT_DeviceDataReference &device, PLT_TransportInfo *info, void *userdata){
    if (wd_Target.delegate && [wd_Target.delegate respondsToSelector:@selector(getTransportInfoResponse:)]){
        WDTransportResponseInfo *response = [[WDTransportResponseInfo alloc] initWithResult:res userData:(__bridge id)userdata deviceUUID:CHARTONSSTRING(device->GetUUID())];
        response.cur_transport_state = CHARTONSSTRING(info->cur_transport_state);
        response.cur_transport_status = CHARTONSSTRING(info->cur_transport_status);
        response.cur_speed = CHARTONSSTRING(info->cur_speed);
        [wd_Target.delegate getTransportInfoResponse:response];
    }
}

/**
 请求播放进度回调
 */
void
PltMediaController::OnGetPositionInfoResult( NPT_Result res,PLT_DeviceDataReference&device,PLT_PositionInfo*info,void*userdata){
    if(wd_Target.delegate && [wd_Target.delegate respondsToSelector:@selector(getTransportPositionInfoResponse:)]){
        WDTransportPositionInfo *response = [[WDTransportPositionInfo alloc] initWithResult:res userData:(__bridge id)userdata deviceUUID:CHARTONSSTRING(device->GetUUID())];
        response.track = info->track;
        response.rel_count = info->rel_count;
        response.abs_count = info->abs_count;
        response.track_uri = CHARTONSSTRING(info->track_uri);
        response.rel_time = LONGLONGSTRING(info->rel_time.ToSeconds());
        response.abs_time = LONGLONGSTRING(info->abs_time.ToSeconds());
        response.track_duration = LONGLONGSTRING(info->track_duration.ToSeconds());
        response.track_metadata = CHARTONSSTRING(info->track_metadata);
        [wd_Target.delegate getTransportPositionInfoResponse:response];
    }
}

/**
 跳转进度回调
 */
void
PltMediaController::OnSeekResult(NPT_Result res,PLT_DeviceDataReference &device,void *userdata)
{
    if(wd_Target.delegate && [wd_Target.delegate respondsToSelector:@selector(OnSeekResult:)])
    {
        NSInteger result = res;
        WDTransportResponseInfo *response = [[WDTransportResponseInfo alloc] initWithResult:result userData:(__bridge id)userdata deviceUUID:CHARTONSSTRING(device->GetUUID())];
        [wd_Target.delegate OnSeekResult:response];
    }
}

/**
 获取当前播放音量回调
 */
void PltMediaController::
OnGetVolumeResult(NPT_Result res,PLT_DeviceDataReference &device, const char *channel,  NPT_UInt32 volume, void *userdata)
{
    if(wd_Target.delegate && [wd_Target.delegate respondsToSelector:@selector(getVolumeResponse:)])
    {
        NSInteger result = res;
        WDTransportVolumeInfo *volumeInfo = [[WDTransportVolumeInfo alloc] initWithResult:result userData:(__bridge id)userdata deviceUUID:CHARTONSSTRING(device->GetUUID())];
        volumeInfo.channel = CHARTONSSTRING(channel);
        volumeInfo.volume = volume;
        [wd_Target.delegate getVolumeResponse:volumeInfo];
    }
}

/**
 设置音量回调
 */
void PltMediaController::
OnSetVolumeResult(NPT_Result res,PLT_DeviceDataReference &device,void *userdata)
{
    if(wd_Target.delegate && [wd_Target.delegate respondsToSelector:@selector(setVolumeResponse:)])
    {
        WDTransportResponseInfo *response = [[WDTransportResponseInfo alloc] initWithResult:res userData:(__bridge id)userdata deviceUUID:CHARTONSSTRING(device->GetUUID())];
        [wd_Target.delegate setVolumeResponse:response];
        
    }
}
