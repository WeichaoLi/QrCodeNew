//
//  AppDelegate.h
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/30.
//  Copyright © 2015年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QrcodeScanViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong ,nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) QrcodeScanViewController *viewController;

@end

