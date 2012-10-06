//
//  LHCustomCell.h
//  Lifehacks
//
//  Created by Asep Bagja on 9/25/12.
//  Copyright (c) 2012 Milk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHCustomCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *thumbnail;
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *subtitle;

@end
