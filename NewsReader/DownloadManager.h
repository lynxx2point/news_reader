//
//  DownloadManager.h
//  NewsReader
//
//  Created by Alexandra Seliverstova on 14/11/2019.
//  Copyright © 2019 Alexandra Seliverstova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NewsArticle.h"

@protocol DownloadManagerDelegate <NSObject>

- (void) receivedData: (NSMutableArray<NewsArticle*>*) data;
- (void) errorDescription: (NSString*) text;

@end

@interface DownloadManager: NSObject

@property (weak) id <DownloadManagerDelegate> delegate;

- (void) downloadNews;

@end
