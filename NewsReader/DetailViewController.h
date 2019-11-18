//
//  DetailViewController.h
//  NewsReader
//
//  Created by Alexandra Seliverstova on 17/11/2019.
//  Copyright © 2019 Alexandra Seliverstova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsArticle.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NewsArticle *detailItem;

@end

