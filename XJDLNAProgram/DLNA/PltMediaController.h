//
//  PltMediaController.h
//  Demo3
//
//  Created by xjThree on 2018/8/30.
//  Copyright © 2018年 xjThree-XJ. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Platinum/PltLeaks.h>
#import <Platinum/PltDownloader.h>
#import <Platinum/Platinum.h>
#import <Platinum/PltMediaServer.h>
#import <Platinum/PltSyncMediaBrowser.h>
#import <Platinum/PltMediaController.h>
#import <Platinum/Neptune.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#import "XJ_DMRControl.h"

typedef NPT_Map<NPT_String, NPT_String>              PLT_StringMap;
typedef NPT_Lock<PLT_StringMap>                      PLT_LockStringMap;
typedef NPT_Map<NPT_String, NPT_String>::Entry       PLT_StringMapEntry;

class PltMediaController : public PLT_SyncMediaBrowser,
public PLT_MediaController,
public PLT_MediaControllerDelegate{
public:
    //构造方法
    PltMediaController(PLT_CtrlPointReference &ctrlPoint,XJ_DMRControl *delegateWrapper);
    virtual ~PltMediaController();
    virtual bool OnMRAdded(PLT_DeviceDataReference &device);
    void GetCurMediaRenderer(PLT_DeviceDataReference& renderer);
    const PLT_StringMap getMediaRenderersNameTable();
    void setRendererAVTransportURI(const char *uriStr, const char *metaData);
    void chooseMediaRenderer(NPT_String chosenUUID);
    
    void setRendererPlay();
    void setRendererStop();
    void setRendererPause();
    void getTransportInfo();
    void getTransportPlayTimeForNow();
    void getRendererVolume();
    void setRenderVolume(int volume);
    void setSeekTime(const char* command);
    
    
    void OnGetTransportInfoResult(
                                  NPT_Result               /* res */,
                                  PLT_DeviceDataReference& /* device */,
                                  PLT_TransportInfo*       /* info */,
                                  void*                    /* userdata */) ;
    
    void OnGetPositionInfoResult(
                                 NPT_Result               /* res */,
                                 PLT_DeviceDataReference& /* device */,
                                 PLT_PositionInfo*        /* info */,
                                 void*                    /* userdata */) ;
    
    void OnSeekResult(NPT_Result res,PLT_DeviceDataReference &device,void *userdata);
    
    void OnSetVolumeResult(NPT_Result res,PLT_DeviceDataReference& device,void* userdata);
    void OnGetVolumeResult( NPT_Result res,PLT_DeviceDataReference &device,const char *channel,NPT_UInt32 volume,void *userdata) ;
    
    
    
private:
    XJ_DMRControl *XJ_Target;
    NPT_Mutex XJ_CurMediaRendererLock;
    PLT_DeviceDataReference XJ_CurMediaRenderer;
    NPT_Stack<NPT_String> XJ_CurBrowseDirectoryStack;
    NPT_Lock<PLT_DeviceMap> XJ_MediaRenderers;
    NPT_Lock<PLT_DeviceMap> XJ_MediaServers;
    PLT_DeviceDataReference ChooseDevice(const NPT_Lock<PLT_DeviceMap>& deviceList, NPT_String chosenUUID);
};

