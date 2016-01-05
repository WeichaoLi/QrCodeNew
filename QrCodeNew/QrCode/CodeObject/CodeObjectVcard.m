//
//  CodeObjectVcard.m
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/31.
//  Copyright © 2015年 LWC. All rights reserved.
//

#import "CodeObjectVcard.h"

@implementation CodeObjectVcard

+ (id)analyseWithData:(NSString *)dataString {
    CodeObjectVcard *object = [CodeObjectVcard new];
    
    /*
     //    BEGIN:VCARD
     //    VERSION:3.0
     //    N:张三宝
     //    EMAIL:email@address.com
     //    TEL:021-68008600
     //    TEL;CELL:13001700186
     //    ADR:上海市长宁区翔殷路188号云大楼616室
     //    ORG:上海二维科技有限公司
     //    TITLE:软件工程师
     //    URL:http://www.erwei.com
     //    NOTE:备注信息
     //    END:VCARD
     
     OR
     
     //    MECARD:TEL:4414212;URL:http://2621.com;EMAIL:2112211＃J#J;NOTE:21121212@qq.com;N:当时;ORG:非典时;TIL:反对;ADR:发达摄氏度;
     */
    
    NSString *separateString = nil;
    
    NSString *result = [dataString substringToIndex:[dataString rangeOfString:@":"].location];
    
    NSArray *OrderVALUE = nil;
    NSArray *OrderKEY = nil;
    NSArray *OrderImage = nil;
    if ([result isEqualToString:@"BEGIN"]) {
        //        OrderKEY = @[@"N:", @"ORG:", @"TITLE:", @"TEL:", @"TEL;CELL:", @"EMAIL:", @"URL:", @"ADR:", @"NOTE:"];
        //        OrderVALUE = @[@"姓名", @"单位", @"职位", @"电话", @"手机号", @"邮箱", @"网址", @"地址", @"备注"];
        //        OrderImage = @[@"", @"", @"", @"action_call.png", @"action_call.png", @"action_mail.png", @"action_url.png", @"", @""];
        OrderKEY = @[@"N:", @"FN:", @"LN:", @"ORG:", @"TITLE:", @"TEL:", @"TEL;CELL:", @"EMAIL:", @"URL:", @"ADR:", @"NOTE:"];
        OrderVALUE = @[@"姓名", @"名字", @"姓氏", @"单位", @"职位", @"电话", @"手机号", @"邮箱", @"网址", @"地址", @"备注"];
        OrderImage = @[@"", @"", @"", @"", @"", @"action_call.png", @"action_call.png", @"action_mail.png", @"action_url.png", @"", @""];
        
        separateString = @"\n";
        
    }else if ([result isEqualToString:@"MECARD"]) {
        
        dataString = [dataString stringByReplacingOccurrencesOfString:@"MECARD:" withString:@"MECARD:;"];
        
        OrderKEY = @[@"N:", @"ORG:", @"TIL:", @"TEL:", @"EMAIL:", @"URL:", @"ADR:", @"NOTE:"];
        OrderVALUE = @[@"姓名", @"单位", @"职位", @"电话", @"邮箱", @"网址", @"地址", @"备注"];
        OrderImage = @[@"", @"", @"", @"action_call.png", @"action_mail.png", @"action_url.png", @"", @""];
        
        separateString = @";";
    }
    
    NSDictionary *Order = [NSDictionary dictionaryWithObjects:OrderVALUE forKeys:OrderKEY];
    NSDictionary *Order1 = [NSDictionary dictionaryWithObjects:OrderImage forKeys:OrderKEY];
    
    NSMutableArray *Content = [NSMutableArray array];
    object.param = [NSMutableDictionary dictionary];
    
    for (NSString *KEY in OrderKEY) {
        if ([dataString rangeOfString:[NSString stringWithFormat:@"%@%@",separateString,KEY]].length) {
            DataModel *data = [[DataModel alloc] initWithName:[Order objectForKey:KEY]
                                                      Content:[dataString separateFromString:[separateString stringByAppendingString:KEY] ToString:separateString]
                                                  ImageString:[Order1 objectForKey:KEY]
                                                      clickId:nil];
            data ? [Content addObject:data] : nil;
            
            [object.param setObject:[dataString separateFromString:[separateString stringByAppendingString:KEY]
                                                          ToString:separateString]
                             forKey:[Order objectForKey:KEY]];
        }
    }
    NSMutableArray *items = [NSMutableArray array];
    
    [items addObject:Content];
    [items addObject:@[[[DataModel alloc] initWithName:nil Content:@"加入通讯录" ImageString:nil clickId:@"ADDRESS://"]]];
    [items addObject:@[[[DataModel alloc] initWithName:nil Content:@"查看原始信息" ImageString:nil clickId:@"check://"]]];
    
    object.itmesList = items;
    
    return object;
}

@end
