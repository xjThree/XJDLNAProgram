//
//  DLNAViewController.m
//  多屏互动
//
//  Created by WonderTek on 2018/9/11.
//  Copyright © 2018年 WonderTek. All rights reserved.
//

#import "DLNAViewController.h"
#import "DLNAHeaderView.h"
#import "WD_DMRControl.h"
#import "CustomTextField.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface DLNAViewController ()<UITableViewDelegate,UITableViewDataSource,WD_DMRProtocolDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITableView *deviceListTableView;
@property (nonatomic,strong) DLNAHeaderView *headerView;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) CustomTextField *textField;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *deviceDataArray;

@property (nonatomic,strong) WD_RenderDeviceModel *model;

@end

@implementation DLNAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
//    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:self.webView];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self setupUIData];
    [self addNotification];
}

- (void)setupUIData{
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.deviceListTableView];
    [self.view addSubview:self.textField];
    self.dataArray = @[@"初始化",@"搜索设备(DLNA)",@"绑定播放(DLNA)",@"暂停",@"停止",@"跳转到进度",@"获取当前播放音量",@"设置音量",@"获取播放状态"].mutableCopy;
    [self.deviceListTableView reloadData];
}

- (void)setNavigate{
    self.title = @"多屏互动DLNA近场";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [button addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBarbutton;
}

- (void)addNotification{
    [self.textView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];

}

- (void)keyBoardHidden:(NSNotification *)notification{
    self.textField.frame = CGRectMake(0, kScreenH+50, kScreenW, 50);
}

- (void)keyBoardShow:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = aValue.CGRectValue;
    self.textField.frame = CGRectMake(0, kScreenH-keyboardRect.size.height-50, kScreenW, 50);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"]) {
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 0)];
    }
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (DLNAHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[DLNAHeaderView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 140)];
        _headerView.backgroundColor = [UIColor grayColor];
    }
    return _headerView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(200, 140+64+200, kScreenW-200, kScreenH-140-64-200) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor redColor];
    }
    return _tableView;
}

- (UITableView *)deviceListTableView{
    if (!_deviceListTableView) {
        _deviceListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 140+64+200, 200, kScreenH-140-64-200) style:UITableViewStylePlain];
        _deviceListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _deviceListTableView.delegate = self;
        _deviceListTableView.dataSource = self;
    }
    return _deviceListTableView;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 140+64, kScreenW, 200)];
        _textView.editable = NO;
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.layer.borderColor = [UIColor grayColor].CGColor;
        _textView.layer.borderWidth = 1;
    }
    return _textView;
}

- (CustomTextField *)textField{
    if (!_textField) {
        _textField = [[CustomTextField alloc] initWithFrame:CGRectMake(0, kScreenH+50, kScreenW, 50)];
        __weak DLNAViewController *weakSelf = self;
        _textField.valueCallBack = ^(NSIndexPath *indexPath) {
            [weakSelf.textField.textField resignFirstResponder];
            if (indexPath.row == 5) {
                [[WD_DMRControl sharedInstance] setSeekTime:[weakSelf.textField.textField.text integerValue]];
            }
            if (indexPath.row == 7) {
                [[WD_DMRControl sharedInstance] setVolume:[weakSelf.textField.textField.text integerValue]];
            }
            weakSelf.textField.textField.text = @"";
        };
    }
    return _textField;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableView]) {
        return self.dataArray.count;
    }else{
        return self.deviceDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableView]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        }
        cell.backgroundColor = [UIColor orangeColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = self.dataArray[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCellId"];
        WD_RenderDeviceModel *model = self.deviceDataArray[indexPath.row];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        }
        cell.textLabel.text = model.wd_name;
        cell.detailTextLabel.text = model.wd_uuid;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableView]) {
        switch (indexPath.row) {
            case 0://初始化
            {
                [[WD_DMRControl sharedInstance] setDelegate:self];
                self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n\n初始化成功..."]];
            }
                break;
            case 1:
            {
                [self.deviceDataArray removeAllObjects];
                [self.deviceListTableView reloadData];
               [[WD_DMRControl sharedInstance] start];
                self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n\n搜索设备中..."]];
            }
                break;
            case 2:
            {
                if (self.model) {
                    [[WD_DMRControl sharedInstance] chooseRenderWithUUID:self.model.wd_uuid];//绑定
                    [self.headerView setConnectDeviceState:[NSString stringWithFormat:@"已连接：%@",self.model.wd_uuid]];
                    self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n\n绑定成功"]];
                    [WD_DMRControl sharedInstance].delegate = self;
                    [[WD_DMRControl sharedInstance] renderSetAVTransportWithURI:@"http://asp.cntv.lxdns.com/asp/hls/450/0303000a/3/default/9425de84e6874da305ba49949397da66/450.m3u8" mediaInfo:@""];
                    [[WD_DMRControl sharedInstance] play];   //播放
                }
            }
                break;
            case 3:
            {
                [[WD_DMRControl sharedInstance] pause]; //暂停
            }
                break;
            case 4:
            {
                [self.headerView setConnectDeviceState:@"未连接"];
                [[WD_DMRControl sharedInstance] stop]; //停止
            }
                break;
            case 5://跳转到进度
            {
                [self.textField  setIndexPath:indexPath];
            }
                break;
            case 6:
                //获取当前播放音量
                [[WD_DMRControl sharedInstance] getVolume];
                break;
            case 7://设置音量
            {
                [self.textField  setIndexPath:indexPath];
            }
                break;
            case 8://获取播放状态
            {
                [[WD_DMRControl sharedInstance] getInfo];
            }
                break;
            default:
                break;
        }
    }else{
        WD_RenderDeviceModel *model = self.deviceDataArray[indexPath.row];
        self.model = model;
    }
}

#pragma mark WD_DMRProtocolDelegate
- (void)onDMRAdded{
    self.deviceDataArray = [[WD_DMRControl sharedInstance] getActiveRenders].mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.deviceListTableView reloadData];
    });
}

- (void)getTransportInfoResponse:(WDTransportResponseInfo *)response{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",[response description]]];
    });
}

- (void)getTransportPositionInfoResponse:(WDTransportPositionInfo *)response{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",[response description]]];
    });
}

- (void)getVolumeResponse:(WDTransportVolumeInfo *)response{
    dispatch_async(dispatch_get_main_queue(), ^{
       self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",[response description]]];
    });
}

- (void)setVolumeResponse:(WDTransportResponseInfo *)response{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",[response description]]];
    });
}

- (void)OnSeekResult:(WDTransportResponseInfo *)response{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",[response description]]];
    });
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (NSMutableArray *)deviceDataArray{
    if (!_deviceDataArray) {
        _deviceDataArray = [NSMutableArray new];
    }
    return _deviceDataArray;
}

- (void)dealloc
{
    [[WD_DMRControl sharedInstance] upnpStop];
    NSLog(@"DLNA页面已销毁");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
