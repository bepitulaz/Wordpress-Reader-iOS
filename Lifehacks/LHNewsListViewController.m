//
//  LHNewsListViewController.m
//  Lifehacks
//
//  Created by Asep Bagja on 9/27/12.
//  Copyright (c) 2012 Milk. All rights reserved.
//

#import "LHNewsListViewController.h"
#import "AFNetworking.h"
#import "NSString+HTML.h"
#import "LHCustomCell.h"
#import "LHDetailViewController.h"
#import "LoaderView.h"

@interface LHNewsListViewController()
- (void)loadPostByCategory:(NSString*)categoryID;
@end

@implementation LHNewsListViewController

@synthesize tableData = _tableData;
@synthesize tableView = _tableView;
@synthesize categoryID   = _categoryID;
@synthesize categorySlug = _categorySlug;
@synthesize categoryTitle = _categoryTitle;
@synthesize adView = _adView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // setup the toolbar
    [[self navigationItem] setTitle:_categoryTitle];
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"bg_toolbar_only.png"] forBarMetrics:UIBarMetricsDefault];
    
    // load view
    _loader = [[LoaderView alloc] init];
    
    // load data from server
    [self loadPostByCategory:_categoryID];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

#pragma mark - Motion method
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if(motion == UIEventSubtypeMotionShake) {
        [self loadPostByCategory:_categoryID];
    }
}

#pragma mark - Implementation custom method
- (void)loadPostByCategory:(NSString *)categoryID
{
    //handle the data table
    //Get the data from the server
    NSString *baseURL = [NSString stringWithFormat:@"%@?json=get_category_posts&id=%@", BASEAPIURL, categoryID];
    NSURL *url = [NSURL URLWithString:baseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _tableData = [[NSArray alloc] init];
    
    [self.view addSubview:_loader];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        _tableData = [JSON objectForKey:@"posts"];
        
        [_tableView setHidden:NO];
        [_tableView reloadData];
        
        [_loader removeFromSuperview];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Error pengambilan data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
    [operation start];
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"newsCell";
    LHCustomCell *cell = (LHCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[LHCustomCell alloc] init];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    // parsing the json file
    NSDictionary *posts = [_tableData objectAtIndex:indexPath.row];
    NSString *title = [posts valueForKey:@"title"];
    NSString *date  = [posts valueForKey:@"date"];
    
    [[cell thumbnail] setImageWithURL:[NSURL URLWithString:[posts valueForKey:@"thumbnail"]] placeholderImage:[UIImage imageNamed:@"placeholder-small.png"]];
    [[cell title] setText:[title kv_decodeHTMLCharacterEntities]];
    [[cell subtitle] setText:date];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"detail2Segue"]) {
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        NSDictionary *posts = [_tableData objectAtIndex:indexPath.row];
        NSString *title    = [posts valueForKey:@"title"];
        NSString *date     = [posts valueForKey:@"date"];
        NSString *content  = [posts valueForKey:@"content"];
        NSDictionary *author   = [posts valueForKey:@"author"];
        NSString *authorName   = [author valueForKey:@"name"];
        NSString *url      = [posts valueForKey:@"url"];
        
        LHDetailViewController *detailVC = (LHDetailViewController *) segue.destinationViewController;
        
        [detailVC setArticleAuthor:authorName];
        [detailVC setArticleContent:content];
        [detailVC setArticleDate:date];
        [detailVC setArticleTitle:[title kv_decodeHTMLCharacterEntities]];
        [detailVC setArticleUrl:url];
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
