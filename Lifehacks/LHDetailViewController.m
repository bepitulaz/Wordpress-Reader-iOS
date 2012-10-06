//
//  LHDetailViewController.m
//  Lifehacks
//
//  Created by Asep Bagja on 9/29/12.
//  Copyright (c) 2012 Milk. All rights reserved.
//

#import "LHDetailViewController.h"
#import <Twitter/Twitter.h>

@implementation LHDetailViewController

@synthesize headline   = _headline;
@synthesize author     = _author;
@synthesize content    = _content;
@synthesize scrollView = _scrollView;
@synthesize adView     = _adView;
@synthesize articleAuthor  = _articleAuthor;
@synthesize articleContent = _articleContent;
@synthesize articleDate    = _articleDate;
@synthesize articleTitle   = _articleTitle;
@synthesize articleUrl     = _articleUrl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // setup the toolbar
    [[self navigationItem] setTitle:_articleDate];
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"bg_toolbar_only.png"] forBarMetrics:UIBarMetricsDefault];
    
    // setup the title
    [_headline setText:_articleTitle];
    [_headline setNumberOfLines:0];
    [_headline sizeToFit];
    
    // setup the author
    CGFloat authorYPosition = _headline.frame.size.height + 15.0f;
    [_author setFrame:CGRectMake(_headline.frame.origin.x, authorYPosition, 301.0f, 21.0f)];
    [_author setText:[NSString stringWithFormat:@"Penulis: %@", _articleAuthor]];
    
    // setup the content
    CGFloat contentYPosition = authorYPosition + _author.frame.size.height + 20.0f;
    [_content loadHTMLString:_articleContent baseURL:nil];
    [_content setFrame:CGRectMake(_headline.frame.origin.x, contentYPosition, 320, _content.scrollView.contentSize.height)];
    [[_content scrollView] setScrollEnabled:YES];
    
    // setup the scroll view
    CGFloat scrollViewSize = contentYPosition + _content.frame.size.height;
    [_scrollView setContentSize:CGSizeMake(_content.frame.size.width, scrollViewSize)];
    [_scrollView setScrollEnabled:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setHeadline:nil];
    [self setAuthor:nil];
    [self setContent:nil];
    [self setScrollView:nil];
}

#pragma mark - implement action
- (IBAction)shareButton:(id)sender
{
    if ([TWTweetComposeViewController canSendTweet]) {
        // Initialize Tweet Compose View Controller
        TWTweetComposeViewController *vc = [[TWTweetComposeViewController alloc] init];
        // Settin The Initial Text
        [vc setInitialText:[NSString stringWithFormat:@"%@ via @Lifehacks", _articleTitle]];
        // Adding a URL
        NSURL *url = [NSURL URLWithString:_articleUrl];
        [vc addURL:url];
        // Setting a Completing Handler
        [vc setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
            [self dismissModalViewControllerAnimated:YES];
        }];
        // Display Tweet Compose View Controller Modally
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        // Show Alert View When The Application Cannot Send Tweets
        NSString *message = @"The application cannot send a tweet at the moment. This is because it cannot reach Twitter or you don't have a Twitter account associated with this device.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - ADBannerViewDelegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

@end
