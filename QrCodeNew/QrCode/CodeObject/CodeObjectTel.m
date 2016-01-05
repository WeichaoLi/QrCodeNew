//
//  CodeObjectTel.m
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/31.
//  Copyright © 2015年 LWC. All rights reserved.
//

#import "CodeObjectTel.h"

@implementation CodeObjectTel

+ (id)analyseWithData:(NSString *)dataString {
    CodeObject *object = [[CodeObject alloc] init];
    
    NSArray *array = [dataString componentsSeparatedByString:@":"];
    NSMutableArray *arr = [NSMutableArray array];
    
    [arr addObject:@[[[DataModel alloc] initWithName:@"电话号码" Content:array[1] ImageString:@"action_call.png" clickId:@"TEL://"]]];
    [arr addObject:@[[[DataModel alloc] initWithName:nil Content:@"拨打电话" ImageString:nil clickId:@"TEL://"]]];
    [arr addObject:@[[[DataModel alloc] initWithName:nil Content:@"查看原始信息" ImageString:nil clickId:@"check://"]]];
    
    object.itmesList = arr;
    
    return object;
}

@end
