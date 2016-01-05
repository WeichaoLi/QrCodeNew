//
//  DataModel.m
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/31.
//  Copyright © 2015年 LWC. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (id)initWithName:(NSString *)name Content:(NSString *)content ImageString:(NSString *)imagestring clickId:(NSString *)clickId {
    if (self = [super init]) {
        _name = name;
        _content = content;
        _imageString = imagestring;
        _clickId = clickId;
    }
    return self;
}

@end
