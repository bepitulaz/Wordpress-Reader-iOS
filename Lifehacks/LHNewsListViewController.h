//
//  LHNewsListViewController.h
//  Lifehacks
//
//  Created by Asep Bagja on 9/27/12.
//  Copyright (c) 2012 Milk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class LoaderView;

@interface LHNewsListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, readwrite) NSString *categoryID;
@property (nonatomic, readwrite) NSString *categorySlug;
@property (nonatomic, readwrite) NSString *categoryTitle;
@property (nonatomic, strong) IBOutlet ADBannerView *adView;
@property (nonatomic, strong) LoaderView *loader;

@end
