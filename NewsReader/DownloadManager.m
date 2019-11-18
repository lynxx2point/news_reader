//
//  DownloadManager.m
//  NewsReader
//
//  Created by Alexandra Seliverstova on 14/11/2019.
//  Copyright © 2019 Alexandra Seliverstova. All rights reserved.
//

#import "DownloadManager.h"

@implementation DownloadManager

NSString* const API_KEY = @"40a4f3f4aac74971a45de30e03208787";
NSString* const URL_STRING = @"https://newsapi.org/v2/top-headlines?country=ru&apiKey=";

- (void) downloadNews {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@%@", URL_STRING, API_KEY]]];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError* parseError = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                   options:0
                                                     error:&parseError];
            
            if(parseError) {
                [self.delegate errorDescription: connectionError.localizedDescription];
                return;
            }
            
            NSMutableArray<NewsArticle *>* articles = [NSMutableArray array];
            for (NSDictionary *articleData in json[@"articles"]) {
                NewsArticle* article = [[NewsArticle alloc] init];
                NSDictionary *source = articleData[@"source"];
                article.sourceId = [self nilOrValue:source[@"id"]];
                article.sourceName = [self nilOrValue:source[@"name"]];
                article.author = [self nilOrValue:articleData[@"author"]];
                article.title = [self nilOrValue:articleData[@"title"]];
                article.descriptionText = [self nilOrValue:articleData[@"description"]];
                article.url = [self nilOrValue:articleData[@"url"]];
                article.urlToImage = [self nilOrValue:articleData[@"urlToImage"]];
                article.publishedAt = [self nilOrValue:articleData[@"publishedAt"]];
                article.content = [self nilOrValue:articleData[@"content"]];
                [articles addObject:article];
            }
            
            for (NewsArticle* article in articles) {
                if([article.urlToImage length] != 0) {
                    UIImage* img = [self downloadImage:article.urlToImage];
                    article.img = img;
                }
            }
            
            [self.delegate receivedData: articles];
        } else {
            [self.delegate errorDescription: connectionError.localizedDescription];
        }
    }];
    [dataTask resume];
}

- (id) nilOrValue:(id)sourceValue {
    if(sourceValue == [NSNull null]) {
        return nil;
    } else {
        return sourceValue;
    }
}

- (UIImage*) downloadImage:(NSString*)urlString {
    NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlString]];
    return [UIImage imageWithData: data];
}

@end
