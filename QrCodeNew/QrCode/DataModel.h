//
//  DataModel.h
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/31.
//  Copyright © 2015年 LWC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *imageString;
@property (copy, nonatomic) NSString *clickId;

- (id)initWithName:(NSString *)name
           Content:(NSString *)content
       ImageString:(NSString *)imagestring
           clickId:(NSString *)clickId;

@end
