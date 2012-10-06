//
//  LHDetailViewController.h
//  Lifehacks
//
//  Created by Asep Bagja on 9/29/12.
//  Copyright (c) 2012 Milk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface LHDetailViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *headline;
@property (nonatomic, strong) IBOutlet UILabel *author;
@property (nonatomic, strong) IBOutlet UIWebView *content;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet ADBannerView *adView;
@property (nonatomic, readwrite) NSString *articleDate;
@property (nonatomic, readwrite) NSString *articleTitle;
@property (nonatomic, readwrite) NSString *articleAuthor;
@property (nonatomic, readwrite) NSString *articleContent;
@property (nonatomic, readwrite) NSString *articleUrl;

- (IBAction)shareButton:(id)sender;

@end
