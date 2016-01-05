//
//  CodeObjectlink.m
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/31.
//  Copyright © 2015年 LWC. All rights reserved.
//

#import "CodeObjectLink.h"

@implementation CodeObjectLink

+ (id)analyseWithData:(NSString *)dataString {
    CodeObjectLink *object = [[CodeObjectLink alloc] init];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    [arr addObject:@[[[DataModel alloc] initWithName:@"网址" Content:dataString ImageString:@"action_url.png" clickId:@"Open://"]]];
//    [arr addObject:@[[[DataModel alloc] initWithName:nil Content:@"打开网址" ImageString:nil clickId:@"Open://"]]];
    [arr addObject:@[[[DataModel alloc] initWithName:nil Content:@"用浏览器打开网址" ImageString:nil clickId:@"OpenURL://"]]];
    [arr addObject:@[[[DataModel alloc] initWithName:nil Content:@"查看原始信息" ImageString:nil clickId:@"check://"]]];
    
    object.itmesList = arr;
    
    return object;
}

@end
