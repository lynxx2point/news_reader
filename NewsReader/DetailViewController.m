//
//  DetailViewController.m
//  NewsReader
//
//  Created by Alexandra Seliverstova on 17/11/2019.
//  Copyright © 2019 Alexandra Seliverstova. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;

@end

@implementation DetailViewController

const double IMAGE_HEIGHT = 170;

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        
        UILabel *titleLabel = (UILabel *)[self.view viewWithTag:1];
        UILabel *descrLabel = (UILabel *)[self.view viewWithTag:3];
        UIImageView *imgView = (UIImageView *)[self.view viewWithTag:2];
        
        descrLabel.attributedText = [[NSAttributedString alloc] initWithData:[self.detailItem.descriptionText dataUsingEncoding:NSUTF8StringEncoding]
                   options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                             NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
        documentAttributes:nil error:nil];
        
        titleLabel.text = self.detailItem.title;
        
        if(self.detailItem.img) {
            self.imageHeightConstraint.constant = IMAGE_HEIGHT;
            imgView.image = self.detailItem.img;
        } else {
            self.imageHeightConstraint.constant = 0;
            imgView.image = nil;
        }
        [imgView layoutIfNeeded];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(NewsArticle *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}


@end
