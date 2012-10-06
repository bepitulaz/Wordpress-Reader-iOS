//
//  LHCategoryViewController.h
//  Lifehacks
//
//  Created by Asep Bagja on 9/26/12.
//  Copyright (c) 2012 Milk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class LoaderView;

@interface LHCategoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) IBOutlet ADBannerView *adView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *kembaliBtn;
@property (nonatomic, strong) LoaderView *loader;

- (IBAction)kembaliAction:(id)sender;

@end
