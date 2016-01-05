//
//  QrcodeScanViewController.m
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/30.
//  Copyright © 2015年 LWC. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "QrcodeScanViewController.h"
#import "ZBarSDK.h"
#import "QrcodeDataViewController.h"

#define QRCODE_VIEW_WIDTH   self.view.frame.size.width
#define QRCODE_VIEW_HEIGHT self.view.frame.size.height

#define QRCODE_SCAN_WIDTH   220
//#define QRCODE_TOP_HEIGHT   100

@interface QrcodeScanViewController ()<ZBarReaderViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZBarReaderDelegate, AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIActivityIndicatorView * activeityView;
@property (strong, nonatomic) UIImageView *scanLine;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *lightButton;

//iOS6
@property (strong, nonatomic) ZBarReaderView *readerView;
//>=iOS7
@property (strong,nonatomic) AVCaptureDevice *device;
@property (strong,nonatomic) AVCaptureDeviceInput *input;
@property (strong,nonatomic) AVCaptureMetadataOutput *output;
@property (strong,nonatomic) AVCaptureSession *session;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *preview;

@end

@implementation QrcodeScanViewController {
    NSTimer *timer;
}

@synthesize imageView, activeityView, backButton, lightButton, scanLine;

- (void)loadView {
    [super loadView];
    [self createUI];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    CGFloat QRCODE_TOP_HEIGHT = 0;
    
    if (IS_MIN_SCREEN) {
        QRCODE_TOP_HEIGHT = 80;
    }else {
        QRCODE_TOP_HEIGHT = 100;
    }
        
    //扫描区域的背景
    CGFloat imageLeft = (QRCODE_VIEW_WIDTH - QRCODE_SCAN_WIDTH) / 2;
    imageView = [[UIImageView alloc] initWithImage:QRCODE_GETIMAGE(@"pick_bg.png")];
    imageView.frame = CGRectMake(imageLeft, QRCODE_TOP_HEIGHT , QRCODE_SCAN_WIDTH, QRCODE_SCAN_WIDTH);
    imageView.backgroundColor = [UIColor clearColor];
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:imageView];
    
    UIColor *bezierColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.386270059121622];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QRCODE_VIEW_WIDTH, QRCODE_TOP_HEIGHT)];
    topView.backgroundColor = bezierColor;
    [self.view addSubview:topView];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, QRCODE_TOP_HEIGHT, imageLeft, QRCODE_SCAN_WIDTH)];
    leftView.backgroundColor = bezierColor;
    [self.view addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame), QRCODE_TOP_HEIGHT, imageLeft, QRCODE_SCAN_WIDTH)];
    rightView.backgroundColor = bezierColor;
    [self.view addSubview:rightView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), QRCODE_VIEW_WIDTH, QRCODE_VIEW_HEIGHT - CGRectGetMaxY(imageView.frame))];
    bottomView.backgroundColor = bezierColor;
    bottomView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:bottomView];
    
    //显示提示语
    UILabel *LableSuggest = [[UILabel alloc] initWithFrame:CGRectZero];
    LableSuggest.backgroundColor = [UIColor clearColor];
    LableSuggest.numberOfLines = 0;
    LableSuggest.textAlignment = NSTextAlignmentCenter;
    LableSuggest.text = @"将取景框对准二维码,\n即可自动扫描";
    [LableSuggest sizeToFit];
    LableSuggest.center = CGPointMake(topView.center.x, CGRectGetHeight(topView.frame) - LableSuggest.center.y - 10);
    LableSuggest.textColor = [UIColor whiteColor];
    [topView addSubview:LableSuggest];
    
    scanLine = [[UIImageView alloc] initWithImage:QRCODE_GETIMAGE(@"line.png")];
    CGRect lineFrame = CGRectZero;
    lineFrame.origin.x = imageView.frame.origin.x;
    lineFrame.origin.y = imageView.frame.origin.y + 4;
    lineFrame.size = CGSizeMake(CGRectGetWidth(imageView.frame), 2);
    scanLine.frame = lineFrame;
    [self.view addSubview:scanLine];
    
    //扫描区域的动画
    activeityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activeityView.alpha = 0.6;
    activeityView.backgroundColor = [UIColor blackColor];
    activeityView.frame = imageView.frame;
    [self.view addSubview:activeityView];

    CGFloat buttonViewHeight = 0;
    if (IS_MIN_SCREEN) {
        buttonViewHeight = MIN(CGRectGetHeight(bottomView.frame), 110);
    }else {
        buttonViewHeight = MIN(CGRectGetHeight(bottomView.frame), 140);
    }
  
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(bottomView.frame) - buttonViewHeight, QRCODE_VIEW_WIDTH, buttonViewHeight)];
//    buttonView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.587389146959459];
    buttonView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleHeight;
    [bottomView addSubview:buttonView];
    
    
    //返回按钮
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    backButton.tag = 10;
    [backButton setImage:QRCODE_GET_ICON(@"scan_cancle.png") forState:UIControlStateNormal];
    backButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    CGSize size = [backButton sizeThatFits:CGSizeMake(QRCODE_VIEW_WIDTH/2, buttonViewHeight)];
    CGFloat padding = (QRCODE_VIEW_WIDTH - 2*size.width) / 3;
    backButton.frame = CGRectMake(padding, (CGRectGetHeight(buttonView.frame) - size.height)/2, size.width, size.height);
    [buttonView addSubview:backButton];
    
    //开灯按钮
    lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lightButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    lightButton.tag = 11;
    [lightButton setImage:QRCODE_GET_ICON(@"scan_flash_on.png") forState:UIControlStateNormal];
    lightButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    size = [lightButton sizeThatFits:CGSizeMake(QRCODE_VIEW_WIDTH/2, buttonViewHeight)];
    lightButton.frame = CGRectMake(CGRectGetMaxX(backButton.frame) + padding, (CGRectGetHeight(buttonView.frame) - size.height)/2, size.width, size.height);
    [buttonView addSubview:lightButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"扫一扫";
    
    [activeityView startAnimating];
    
    timer = [NSTimer timerWithTimeInterval:1.5 target:self selector:@selector(repeatScan) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    [timer setFireDate:[NSDate distantFuture]];
    
    // Do any additional setup after loading the view.
    if (QRCODE_SYSTEM_VERSIONS_GREATER_THAN_OR_EQUAL(7)) {
#ifdef __IPHONE_7_0
        [self setupCamera];
#endif
    }else {
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startRun];
}

- (void)setupCamera {
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_output setRectOfInterest:CGRectMake(0, 0, 1, 1)]; //扫描区域，origin为左上角原点，size是比例
    // Session
    _session = [[AVCaptureSession alloc]init];
    if ([_session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
    }
    // 条码类型 AVMetadataObjectTypeQRCode,必须在output加入到session后才能设置metadataObjectTypes
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Mod43Code];
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
}

- (void)repeatScan {
    [UIView animateWithDuration:1.5 animations:^{
        scanLine.transform = CGAffineTransformMakeTranslation(0, imageView.frame.size.height - 8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            scanLine.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) { }];
    }];
}

- (void)startRun {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)1.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [activeityView stopAnimating];
        [timer setFireDate:[NSDate distantPast]];
        if (QRCODE_SYSTEM_VERSIONS_GREATER_THAN_OR_EQUAL(7)) {
            [_session startRunning];
        }else {
            [_readerView start];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [timer invalidate];
    timer = nil;
    [activeityView stopAnimating];
    [_preview removeFromSuperlayer];
    
    _device = nil;
    _input = nil;
    _output = nil;
    _session = nil;
    _preview = nil;
    
    imageView = nil;
    scanLine = nil;
    activeityView = nil;
    backButton = nil;
    lightButton = nil;
}

#pragma mark -

- (void)clickButton:(UIButton *)button {
    if (button.tag == 10) {
        if ([_session isRunning]) {
            [timer setFireDate:[NSDate distantFuture]];
            BOOL success = [_device lockForConfiguration:nil];
            if (success) {
                [_device setTorchMode:AVCaptureTorchModeOff];
                [lightButton setImage:QRCODE_GET_ICON(@"scan_flash_on.png") forState:UIControlStateNormal];
            }
            [_session stopRunning];
        }else {
            [_session startRunning];
            [timer setFireDate:[NSDate distantPast]];
        }
    }else if (button.tag == 11){
        if ([_session isRunning]) {
            BOOL success = [_device lockForConfiguration:nil];
            if (success) {
                if (_device.isTorchActive) {
                    [_device setTorchMode:AVCaptureTorchModeOff];
                    [button setImage:QRCODE_GET_ICON(@"scan_flash_on.png") forState:UIControlStateNormal];
                }else {
                    [_device setTorchMode:AVCaptureTorchModeOn];
                    [button setImage:QRCODE_GET_ICON(@"scan_flash_off.png") forState:UIControlStateNormal];
                }
            }
        }
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue = nil;
    if ([metadataObjects count] >0) {
        
        [_session stopRunning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        if ([stringValue canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
            stringValue = [NSString stringWithCString:[stringValue cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        
        QrcodeDataViewController *dataVC = [[QrcodeDataViewController alloc] init];
        dataVC.dataString = stringValue;
        
        [self.navigationController pushViewController:dataVC animated:YES];
    }
}

#pragma mark - ZBarReaderViewDelegate

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image {
    symbols.filterSymbols = YES;
    NSString *stringValue = nil;
    for (ZBarSymbol *symbol in symbols) {
        //处理部分中文乱码问题
        
        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
            stringValue = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }else {
            stringValue = symbol.data;
        }
        break;
    }
    [_readerView stop];
}

#pragma mark - Autorotate

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
