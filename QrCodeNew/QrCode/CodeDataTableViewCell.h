//
//  CodeDataTableViewCell.h
//  QrCodeNew
//
//  Created by 李伟超 on 16/1/4.
//  Copyright © 2016年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface CodeDataTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *content;
@property (nonatomic, retain) UIImageView *signImageView;

@property (nonatomic, retain) DataModel *dataModel;

@end
