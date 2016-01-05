//
//  NSString+Separate.m
//  QrCodeDemo
//
//  Created by 李伟超 on 14-8-30.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import "NSString+Separate.h"

@implementation NSString (Separate)

- (NSString *)separateFromString:(NSString *)fromString ToString:(NSString *)toString {
    NSString *selfString = self;
    if (fromString && [selfString rangeOfString:fromString].length) {
        selfString = [selfString substringFromIndex:[selfString rangeOfString:fromString].location + fromString.length];
    }
    if (toString && [selfString rangeOfString:toString].length) {
        selfString = [selfString substringToIndex:[selfString rangeOfString:toString].location];
    }
    
    return selfString;
}

@end
