//
//  CodeObjectWlan.m
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/31.
//  Copyright © 2015年 LWC. All rights reserved.
//

#import "CodeObjectWlan.h"

@implementation CodeObjectWlan

+ (id)analyseWithData:(NSString *)dataString {
    CodeObject *object = [[CodeObject alloc] init];
    
//    NSArray *array = [dataString componentsSeparatedByString:@":"];
    NSMutableArray *arr = [NSMutableArray array];
    
    NSArray *OrderVALUE = @[@"SSID", @"加密", @"密码"];
    NSArray *OrderKEY = @[@"S:", @"T:", @"P:"];
//    NSArray *OrderImage = @[@"", @"", @""];
    
    NSString *separateString = @";";
    
    NSDictionary *Order = [NSDictionary dictionaryWithObjects:OrderVALUE forKeys:OrderKEY];
//    NSDictionary *Order1 = [NSDictionary dictionaryWithObjects:OrderImage forKeys:OrderKEY];
    
    NSMutableArray *Content = [NSMutableArray array];
    
    for (NSString *KEY in OrderKEY) {
        DataModel *data = [[DataModel alloc] initWithName:[Order objectForKey:KEY]
                                                  Content:[dataString separateFromString:KEY ToString:separateString]
                                              ImageString:nil
                                                  clickId:nil];
        data ? [Content addObject:data] : nil;
    }

    [arr addObject:Content];
    [arr addObject:@[[[DataModel alloc] initWithName:nil Content:@"查看原始信息" ImageString:nil clickId:@"check://"]]];
    
    object.itmesList = arr;
    
    return object;
}

@end
