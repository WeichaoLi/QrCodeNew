//
//  CodeType.h
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/31.
//  Copyright © 2015年 LWC. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CodeObject.h"

typedef enum {
    CodeDataTEL = 0,  // telephone, TEL:1111111111
    CodeDataTypeSMS,      // message,   SMSTO:
    CodeDataTypeEmail,    // email,  'mailto:' or 'MATMSG:'
    CodeDataTypeWlan,     // WIFI    WIFI:
    CodeDataTypeLink,     // Link    'http:' or 'https:'
    CodeDataTypeVcard,    // Vcard   BEGIN:VCARD ... END:VCARD  OR  MECARD
    CodeDataTypeDefault,  // text or unkown type.
}CodeDataType;

@interface CodeType : NSObject

@property (nonatomic, assign, readonly) CodeDataType dataType;
@property (nonatomic, retain, readonly) CodeObject *object;

- (instancetype)initWithDataString:(NSString *)dataStr;

@end
