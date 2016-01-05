//
//  CodeDataTableViewCell.m
//  QrCodeNew
//
//  Created by 李伟超 on 16/1/4.
//  Copyright © 2016年 LWC. All rights reserved.
//

#import "CodeDataTableViewCell.h"
#import "QrcodeConfig.h"

@implementation CodeDataTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _title = [UILabel new];
        _title.textAlignment = NSTextAlignmentCenter;
        [_title setFont:[UIFont systemFontOfSize:14]];
        [_title setTextColor:[UIColor colorWithRed:0.6667 green:0.6667 blue:0.6667 alpha:1.0]];
        [self.contentView addSubview:_title];
        
        _content = [UILabel new];
        _content.numberOfLines = 0;
        _content.lineBreakMode = NSLineBreakByTruncatingTail;
        [_content setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:_content];
        
        _signImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_signImageView];
    }
    return self;
}

- (void)setDataModel:(DataModel *)dataModel {
    if (_dataModel != dataModel) {
        _dataModel = dataModel;
        
        _title.text = _dataModel.name;
        _content.text = _dataModel.content;
        [_signImageView setImage:QRCODE_GET_ICON(_dataModel.imageString)];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_content setFont:[UIFont systemFontOfSize:14]];
    _content.textAlignment = NSTextAlignmentLeft;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    _title.frame = CGRectMake(10, 0, 58, height);
    
    CGFloat left = _signImageView.image.size.width ?  _signImageView.image.size.width + 20 : 10;
    CGSize size = CGSizeMake(width - CGRectGetMaxX(_title.frame) - 10 - left, height);
    CGSize newsize = [_content sizeThatFits:size];
    
    if (newsize.height > height - 20) {
        _content.frame = CGRectMake(CGRectGetMaxX(_title.frame) + 10, 10, size.width, newsize.height);
    }else {
        _content.frame = CGRectMake(CGRectGetMaxX(_title.frame) + 10, 10, size.width, height - 20);
    }
    
    _signImageView.frame = CGRectMake(CGRectGetMaxX(_content.frame) + 10, _title.center.y - _signImageView.image.size.height/2, _signImageView.image.size.width, _signImageView.image.size.height);
    
    if (!_dataModel.name) {
        _content.frame = self.bounds;
        [_content setFont:[UIFont boldSystemFontOfSize:18]];
        _content.textAlignment = NSTextAlignmentCenter;
    }
    
    CGRect frame = self.bounds;
    frame.size.height = CGRectGetMaxY(_content.frame) + 10;
    self.contentView.frame = frame;
}

@end
