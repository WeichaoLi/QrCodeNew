//
//  CodeObjectSMS.m
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/31.
//  Copyright © 2015年 LWC. All rights reserved.
//

#import "CodeObjectSMS.h"

@implementation CodeObjectSMS

+ (id)analyseWithData:(NSString *)dataString {
    CodeObjectSMS *object = [[CodeObjectSMS alloc] init];
    
    //    SMSTO:15270024074:Hi Nick,反对分地方
    
    NSArray *array = [dataString componentsSeparatedByString:@":"];
    DataModel *data = [[DataModel alloc] initWithName:@"收信人" Content:array[1] ImageString:@"action_call.png" clickId:nil];
    NSMutableArray *arr = [NSMutableArray arrayWithObject:data];
    DataModel *data1 = [[DataModel alloc] initWithName:@"短信内容" Content:array[2] ImageString:nil clickId:nil];
    [arr addObject:data1];
    
    NSMutableArray *items = [NSMutableArray array];
    
    [items addObject:arr];
    [items addObject:@[[[DataModel alloc] initWithName:nil Content:@"发送短信" ImageString:nil clickId:@"SMSTO://"]]];
    [items addObject:@[[[DataModel alloc] initWithName:nil Content:@"查看原始信息" ImageString:nil clickId:@"check://"]]];
    
    object.itmesList = items;
    
    object.param = [NSMutableDictionary dictionary];
    [object.param setObject:array[1] forKey:@"收信人"];
    [object.param setObject:array[1] forKey:@"短信内容"];
    
    return object;
}

@end
