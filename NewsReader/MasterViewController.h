//
//  MasterViewController.h
//  NewsReader
//
//  Created by Alexandra Seliverstova on 17/11/2019.
//  Copyright © 2019 Alexandra Seliverstova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsArticle.h"
#import "DownloadManager.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <DownloadManagerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@end

