//
//  LHCustomCell.m
//  Lifehacks
//
//  Created by Asep Bagja on 9/25/12.
//  Copyright (c) 2012 Milk. All rights reserved.
//

#import "LHCustomCell.h"

@implementation LHCustomCell

@synthesize thumbnail = _thumbnail;
@synthesize title     = _title;
@synthesize subtitle  = _subtitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [_title setNumberOfLines:2];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
