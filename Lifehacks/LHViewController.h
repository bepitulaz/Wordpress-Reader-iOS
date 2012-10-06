//
//  LHViewController.h
//  Lifehacks
//
//  Created by Asep Bagja on 9/24/12.
//  Copyright (c) 2012 Milk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class LHDetailViewController;
@class LoaderView;

@interface LHViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ADBannerViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollImage;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet ADBannerView *adView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *categoryBtn;
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSArray *featuredData;
@property (nonatomic, strong) LoaderView *loader;

@end
