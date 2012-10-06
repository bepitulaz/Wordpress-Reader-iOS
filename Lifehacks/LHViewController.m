//
//  LHViewController.m
//  Lifehacks
//
//  Created by Asep Bagja on 9/24/12.
//  Copyright (c) 2012 Milk. All rights reserved.
//

#import "LHViewController.h"
#import "AFNetworking.h"
#import "LHCustomCell.h"
#import "NSString+HTML.h"
#import "LHDetailViewController.h"
#import "LoaderView.h"

@interface LHViewController ()
- (void)loadRecentPosts;
- (void)loadFeaturedPosts;
- (void)handleSingleTapImage:(UITapGestureRecognizer*)sender;
@end

@implementation LHViewController

@synthesize tableView    = _tableView;
@synthesize scrollImage  = _scrollImage;
@synthesize pageControl  = _pageControl;
@synthesize tableData    = _tableData;
@synthesize featuredData = _featuredData;
@synthesize adView       = _adView;
@synthesize categoryBtn  = _categoryBtn;
@synthesize loader       = _loader;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // setup the toolbar
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"bg_toolbar.png"] forBarMetrics:UIBarMetricsDefault];
    [_categoryBtn setTintColor:UIColorFromRGB(0xcead8a)];
    [[self view] setBackgroundColor:UIColorFromRGB(0x8e785f)];
    
    //loader view
    _loader = [[LoaderView alloc] initWithFrame:CGRectZero];
	
    // Start load the data from the server.
    [self loadFeaturedPosts];
    [self loadRecentPosts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setTableData:nil];
    [self setTableView:nil];
    [self setScrollImage:nil];
    [self setPageControl:nil];
    [self setAdView:nil];
    [self setCategoryBtn:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    // setup the toolbar
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"bg_toolbar.png"] forBarMetrics:UIBarMetricsDefault];
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
        [self loadFeaturedPosts];
        [self loadRecentPosts];
    }
}

#pragma mark - Private method implementation
- (void)loadRecentPosts
{
    //handle the data table
    //Get the data from the server
    NSString *baseURL = (BASEAPIURL @"?json=get_recent_posts");
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

- (void)loadFeaturedPosts
{
    NSString *baseURL = (BASEAPIURL @"?json=get_tag_posts&tag_slug=featured&count=5");
    NSURL *url = [NSURL URLWithString:baseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _featuredData = [[NSArray alloc] init];
    
    [self.view addSubview:_loader];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        _featuredData = [JSON objectForKey:@"posts"];
        
        // determine the page control and setup the scrollview
        [_pageControl setNumberOfPages:[_featuredData count]];
        [_scrollImage setPagingEnabled:YES];
        [_scrollImage setDelegate:self];
        [_scrollImage setShowsHorizontalScrollIndicator:NO];
        
        // start looping the data
        for(NSUInteger i=0;i<[_featuredData count];i++) {
            [_scrollImage setContentSize:CGSizeMake(_scrollImage.frame.size.width*[_featuredData count], _scrollImage.frame.size.height)];
            NSDictionary *postsData = [_featuredData objectAtIndex:i];
            NSArray *attachment = [[[[postsData valueForKey:@"attachments"] valueForKey:@"images"] valueForKey:@"medium"] valueForKey:@"url"];
            
            // load the image
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapImage:)];
            [singleTap setNumberOfTapsRequired:1];
            
            
            UIImageView *imageFeatured = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollImage.frame.size.width*i, 0, _scrollImage.frame.size.width, _scrollImage.frame.size.height)];
            if([attachment count] > 0) {
                [imageFeatured setImageWithURL:[NSURL URLWithString:[attachment objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            } else {
                [imageFeatured setImage:[UIImage imageNamed:@"placeholder.png"]];
            }
            
            [imageFeatured setTag:i];
            [imageFeatured addGestureRecognizer:singleTap];
            [imageFeatured setUserInteractionEnabled:YES];
            [_scrollImage addSubview:imageFeatured];
            
            // add title to the image
            NSString *title = [postsData objectForKey:@"title"];
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(_scrollImage.frame.size.width*i, 0, 270, 52)];
            [titleLbl setLineBreakMode:NSLineBreakByWordWrapping];
            [titleLbl setNumberOfLines:0];
            [titleLbl setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
            [titleLbl setText:title];
            [titleLbl setTextColor:[UIColor whiteColor]];
            [titleLbl setTextAlignment:NSTextAlignmentCenter];
            [_scrollImage addSubview:titleLbl];
        }
        
        [_loader removeFromSuperview];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Error pengambilan data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
    [operation start];
}

- (void) handleSingleTapImage:(UITapGestureRecognizer *)sender
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LHDetailViewController *detailVC = [storyBoard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    NSDictionary *posts = [_featuredData objectAtIndex:sender.view.tag];
    NSString *title    = [posts valueForKey:@"title"];
    NSString *date     = [posts valueForKey:@"date"];
    NSString *content  = [posts valueForKey:@"content"];
    NSDictionary *author   = [posts valueForKey:@"author"];
    NSString *authorName   = [author valueForKey:@"name"];
    NSString *url      = [posts valueForKey:@"url"];
    
    [detailVC setArticleAuthor:authorName];
    [detailVC setArticleContent:content];
    [detailVC setArticleDate:date];
    [detailVC setArticleTitle:[title kv_decodeHTMLCharacterEntities]];
    [detailVC setArticleUrl:url];
    
    [[self navigationController] pushViewController:detailVC animated:YES];
}

#pragma mark - Table Delegation Method
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
    static NSString *cellIdentifier = @"Cell";
    LHCustomCell *cell = (LHCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[LHCustomCell alloc] init];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    // parsing the json file
    NSDictionary *posts = [_tableData objectAtIndex:indexPath.row];
    NSString *title = [posts objectForKey:@"title"];
    NSString *date  = [posts objectForKey:@"date"];
   
    [[cell thumbnail] setImageWithURL:[NSURL URLWithString:[posts objectForKey:@"thumbnail"]]];
    [[cell title] setText:[title kv_decodeHTMLCharacterEntities]];
    [[cell subtitle] setText:date];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"homeSegue"]) {
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

#pragma  mark - Scrollview delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // determine the current page
    CGFloat pageWidth = _scrollImage.frame.size.width;
    int currentPage   = floor((_scrollImage.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [_pageControl setCurrentPage:currentPage];
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
