//
//  CodeObjectEmail.m
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/31.
//  Copyright © 2015年 LWC. All rights reserved.
//

#import "CodeObjectEmail.h"

@implementation CodeObjectEmail

+ (id)analyseWithData:(NSString *)dataString {
    CodeObjectEmail *object = [[CodeObjectEmail alloc] init];
    
    NSString *result = [dataString substringToIndex:[dataString rangeOfString:@":"].location];
    NSArray *OrderVALUE;
    NSArray *OrderKEY;
    NSArray *OrderImage;
    if (![result caseInsensitiveCompare:@"mailto"]) {
        ////        mailto:email@address.com?subject=这是主题&body=内容啊
        
        dataString = [dataString stringByReplacingOccurrencesOfString:@"?subject" withString:@";subject"];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"&subject" withString:@";subject"];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"&body" withString:@";body"];
        
        OrderKEY = @[@"mailto:", @"cc=", @"bcc=", @"subject=", @"body="];
        OrderVALUE = @[@"邮箱", @"抄送", @"密送", @"主题", @"内容"];
        OrderImage = @[@"", @"", @"", @"", @""];
        
    }else if (![result caseInsensitiveCompare:@"MATMSG"]) {
        ////        MATMSG:;     TO: test@address.com;    SUB:这是标题;    BODY:这是邮件内容;    ;;
        
        OrderKEY = @[@"TO:", @"CC:", @"BCC:", @"SUB:", @"BODY:"];
        OrderVALUE = @[@"邮箱", @"抄送", @"密送", @"主题", @"内容"];
        OrderImage = @[@"", @"", @"", @"", @""];
    }
    NSString *separateString = @";";
    NSDictionary *Order = [NSDictionary dictionaryWithObjects:OrderVALUE forKeys:OrderKEY];
    NSDictionary *Order1 = [NSDictionary dictionaryWithObjects:OrderImage forKeys:OrderKEY];
    
    NSMutableArray *Content = [NSMutableArray array];
    object.param = [NSMutableDictionary dictionary];
    
    for (NSString *KEY in OrderKEY) {
        if ([dataString rangeOfString:KEY].length) {
            DataModel *data = [[DataModel alloc] initWithName:[Order objectForKey:KEY]
                                                      Content:[dataString separateFromString:KEY ToString:separateString]
                                                  ImageString:[Order1 objectForKey:KEY]
                                                      clickId:nil];
            data ? [Content addObject:data] : nil;
            
            [object.param setObject:[dataString separateFromString:KEY ToString:separateString] forKey:[Order objectForKey:KEY]];
        }
    }
    
    NSMutableArray *items = [NSMutableArray array];
    
    [items addObject:Content];
    [items addObject:@[[[DataModel alloc] initWithName:nil Content:@"发送邮件" ImageString:nil clickId:@"MAILTO://"]]];
    [items addObject:@[[[DataModel alloc] initWithName:nil Content:@"查看原始信息" ImageString:nil clickId:@"check://"]]];
    
    object.itmesList = items;
    
    return object;
}

@end
