//
//  LoaderView.m
//  Bola News
//
//  Created by Asep Priandana on 6/17/12.
//  Copyright (c) 2012 Bepitulaz. All rights reserved.
//

#import "LoaderView.h"

@implementation LoaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *loaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
        [loaderView setBackgroundColor:UIColorFromRGB(0x2592bf)];
        [self addSubview:loaderView];
        
        UILabel *loadingLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
        [loadingLbl setText:@"loading..."];
        [loadingLbl setFont:[UIFont systemFontOfSize:16]];
        [loadingLbl setTextColor:[UIColor whiteColor]];
        [loadingLbl setTextAlignment:UITextAlignmentCenter];
        [loadingLbl setBackgroundColor:[UIColor clearColor]];
        [self addSubview:loadingLbl];
         
    }
    return self;
}

@end
