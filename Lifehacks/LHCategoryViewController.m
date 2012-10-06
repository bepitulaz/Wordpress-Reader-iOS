//
//  LHCategoryViewController.m
//  Lifehacks
//
//  Created by Asep Bagja on 9/26/12.
//  Copyright (c) 2012 Milk. All rights reserved.
//

#import "LHCategoryViewController.h"
#import "AFNetworking.h"
#import "LHNewsListViewController.h"
#import "LoaderView.h"

@interface LHCategoryViewController()
- (void)loadCategoryList;
@end

@implementation LHCategoryViewController

@synthesize tableData = _tableData;
@synthesize tableView = _tableView;
@synthesize adView    = _adView;
@synthesize kembaliBtn=_kembaliBtn;
@synthesize loader    = _loader;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // setup the toolbar
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"bg_toolbar_only.png"] forBarMetrics:UIBarMetricsDefault];
    [_kembaliBtn setTintColor:UIColorFromRGB(0xcead8a)];
    
    // add loader view
    _loader = [[LoaderView alloc] init];
    
    [self loadCategoryList];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //[self setTableData:nil];
    [self setTableView:nil];
    [self setKembaliBtn:nil];
}

- (IBAction)kembaliAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
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
        [self loadCategoryList];
    }
}

#pragma mark - Custom method
- (void)loadCategoryList
{
    //handle the data table
    //Get the data from the server
    NSString *baseURL = (BASEAPIURL @"?json=get_category_index");
    NSURL *url = [NSURL URLWithString:baseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _tableData = [[NSArray alloc] init];
    
    [self.view addSubview:_loader];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        _tableData = [JSON objectForKey:@"categories"];
        
        [_tableView setHidden:NO];
        [_tableView reloadData];
        
        [_loader removeFromSuperview];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Error pengambilan data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
    [operation start];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"categoryCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    // parsing the json file
    NSDictionary *categories = [_tableData objectAtIndex:indexPath.row];
    NSString *title = [categories valueForKey:@"title"];
    
    [[cell textLabel] setText:title];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"newsSegue"]) {
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        NSDictionary *categories = [_tableData objectAtIndex:indexPath.row];
        NSString *catID    = [categories valueForKey:@"id"];
        NSString *catSlug  = [categories valueForKey:@"slug"];
        NSString *catTitle = [categories valueForKey:@"title"];
        
        LHNewsListViewController *newsVC = (LHNewsListViewController *) segue.destinationViewController;
        
        [newsVC setCategoryID:catID];
        [newsVC setCategorySlug:catSlug];
        [newsVC setCategoryTitle:catTitle];
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
