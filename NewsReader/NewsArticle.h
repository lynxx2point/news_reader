//
//  NewsArticle.h
//  NewsReader
//
//  Created by Alexandra Seliverstova on 17/11/2019.
//  Copyright © 2019 Alexandra Seliverstova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsArticle : NSObject

@property NSString* sourceId;
@property NSString* sourceName;
@property NSString* author;
@property NSString* title;
@property NSString* descriptionText;
@property NSString* url;
@property NSString* urlToImage;
@property NSString* content;
@property NSString* publishedAt;
@property UIImage* img;

@end

NS_ASSUME_NONNULL_END
