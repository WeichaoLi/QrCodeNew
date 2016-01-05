//
//  QrcodeConfig.h
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/30.
//  Copyright © 2015年 LWC. All rights reserved.
//

#ifndef QrcodeConfig_h
#define QrcodeConfig_h

#define QRCODE_SYSTEM_VERSIONS_GREATER_THAN_OR_EQUAL(args) [[UIDevice currentDevice].systemVersion floatValue] >= args

#define IS_MIN_SCREEN [UIScreen mainScreen].bounds.size.height < 568.0  //3.5寸屏幕

#define QRCODE_BUNDLE @"Qrcode.bundle"

#define QRCODE_GETIMAGE(args) [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/image/%@", QRCODE_BUNDLE, args]]]

#define QRCODE_GET_ICON(args) [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/image/icon/%@", QRCODE_BUNDLE, args]]]

#endif 
