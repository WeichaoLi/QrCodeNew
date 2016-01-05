//
//  CodeObject.h
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/31.
//  Copyright © 2015年 LWC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"
#import "NSString+Separate.h"

@interface CodeObject : NSObject

@property (nonatomic, retain) NSArray *itmesList;
@property (nonatomic, retain) NSMutableDictionary *param;

+ (id)analyseWithData:(NSString *)dataString;

@end
