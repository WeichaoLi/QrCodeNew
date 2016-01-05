//
//  QrBaseViewController.m
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/30.
//  Copyright © 2015年 LWC. All rights reserved.
//

#import "QrBaseViewController.h"

@interface QrBaseViewController ()

@end

@implementation QrBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#ifdef __IPHONE_7_0
    if (QRCODE_SYSTEM_VERSIONS_GREATER_THAN_OR_EQUAL(7.0)) {
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
