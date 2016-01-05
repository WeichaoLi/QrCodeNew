//
//  CodeType.m
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/31.
//  Copyright © 2015年 LWC. All rights reserved.
//

#import "CodeType.h"

#import "CodeObjectTel.h"
#import "CodeObjectWlan.h"
#import "CodeObjectSMS.h"
#import "CodeObjectLink.h"
#import "CodeObjectEmail.h"
#import "CodeObjectVcard.h"

@implementation CodeType {
    NSString *dataString;
}

- (instancetype)initWithDataString:(NSString *)dataStr {
    if (self = [super init]) {
        dataString = dataStr;
        [self analyse];
        _object = [[self objectClass] analyseWithData:dataString];
    }
    return self;
}

- (void)analyse {    
    if ([dataString rangeOfString:@":"].length) {
        NSString *result = [dataString substringToIndex:[dataString rangeOfString:@":"].location];
        if (![result caseInsensitiveCompare:@"TEL"]) {
            //电话
            _dataType = CodeDataTEL;
        }else if (![result caseInsensitiveCompare:@"WIFI"]){
            //Wi-Fi
            _dataType = CodeDataTypeWlan;
        }else if (![result caseInsensitiveCompare:@"HTTP"] || ![result caseInsensitiveCompare:@"https"]) {
            //网址
            _dataType = CodeDataTypeLink;
        }else if (![result caseInsensitiveCompare:@"SMSTO"]) {
            //短信
            _dataType = CodeDataTypeSMS;
        }else if (![result caseInsensitiveCompare:@"mailto"] || ![result caseInsensitiveCompare:@"MATMSG"]) {
            //邮件
            _dataType = CodeDataTypeEmail;
        }else if ([dataString rangeOfString:@"CARD"].length) {
            //名片
            _dataType = CodeDataTypeVcard;
        }else {
            //文本
            _dataType = CodeDataTypeDefault;
        }
    }else {
        _dataType = CodeDataTypeDefault;
    }
}

- (Class)objectClass {
    switch (_dataType) {
        case CodeDataTEL: {
            return [CodeObjectTel class];
            break;
        }
        case CodeDataTypeSMS: {
            return [CodeObjectSMS class];
            break;
        }
        case CodeDataTypeEmail: {
            return [CodeObjectEmail class];
            break;
        }
        case CodeDataTypeWlan: {
            return [CodeObjectWlan class];
            break;
        }
        case CodeDataTypeLink: {
            return [CodeObjectLink class];
            break;
        }
        case CodeDataTypeVcard: {
            return [CodeObjectVcard class];
            break;
        }
        case CodeDataTypeDefault: {
            return [CodeObject class];
            break;
        }
    }
    return nil;
}

@end
