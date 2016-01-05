//
//  DetailViewController.h
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/30.
//  Copyright © 2015年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

