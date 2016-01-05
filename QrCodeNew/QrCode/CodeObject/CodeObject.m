//
//  CodeObject.m
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/31.
//  Copyright © 2015年 LWC. All rights reserved.
//

#import "CodeObject.h"

@implementation CodeObject

+ (id)analyseWithData:(NSString *)dataString {
    CodeObject *object = [[CodeObject alloc] init];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    [arr addObject:@[[[DataModel alloc] initWithName:@"文本" Content:dataString ImageString:nil clickId:nil]]];
    [arr addObject:@[[[DataModel alloc] initWithName:nil Content:@"查看原始信息" ImageString:nil clickId:@"check://"]]];
    
    object.itmesList = arr;
    
    return object;
}

@end
