//
//  MasterViewController.m
//  NewsReader
//
//  Created by Alexandra Seliverstova on 17/11/2019.
//  Copyright © 2019 Alexandra Seliverstova. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "DownloadManager.h"

@interface MasterViewController ()

@property NSMutableArray *articles;
@property UIActivityIndicatorView* loadingIndicator;
@property DownloadManager* dm;

@end

@implementation MasterViewController

NSString* const CELL_ID = @"Cell";
NSString* const NO_IMAGE_CELL_ID = @"NoImgCell";
const double ROW_HEIGHT_PORT = 120.0;
const double ROW_HEIGHT_LAND = 70.0;
const double LOADING_IND_SIZE = 40.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(requestNews)
                  forControlEvents:UIControlEventValueChanged];
    
    [self showIndicator: true];
    [self requestNews];
}

- (void)requestNews {
    if(!self.dm) {
        self.dm = [[DownloadManager alloc] init];
        self.dm.delegate = self;
    }
    [self.dm downloadNews];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)showIndicator:(BOOL)tableLoading {
    if(tableLoading) {
        if(!self.loadingIndicator) {
            UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
            self.loadingIndicator = [[UIActivityIndicatorView alloc]initWithFrame: CGRectMake(0, 0, LOADING_IND_SIZE, LOADING_IND_SIZE)];
            self.loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;
            [window addSubview:self.loadingIndicator];
            self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = false;
            self.loadingIndicator.hidesWhenStopped = true;
            
            NSLayoutConstraint *vertPosConstraint = [NSLayoutConstraint constraintWithItem:self.loadingIndicator attribute:NSLayoutAttributeCenterYWithinMargins relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeCenterYWithinMargins multiplier:1.0 constant:0.0];
            NSLayoutConstraint *horPosConstraint = [NSLayoutConstraint constraintWithItem:self.loadingIndicator attribute:NSLayoutAttributeCenterXWithinMargins relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeCenterXWithinMargins multiplier:1.0 constant:0.0];
            
            [window addConstraints: @[horPosConstraint, vertPosConstraint]];
            
        }
        self.loadingIndicator.hidden = false;
        self.view.userInteractionEnabled = false;
        [self.loadingIndicator startAnimating];
    } else {
        self.view.userInteractionEnabled = true;
        [self.loadingIndicator stopAnimating];
    }
}

- (void) orientationChanged:(NSNotification *)note
{
    [self.tableView reloadData];
}

#pragma mark - DownloadManagerDelegate

- (void) errorDescription: (NSString*) text {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle: @"Error"
                                     message: text
                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle: @"OK"
                                   style: UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.refreshControl endRefreshing];
        }];
        
        [alert addAction: okButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        [self showIndicator:false];
    });
}

- (void) receivedData: (NSMutableArray<NewsArticle*>*) data {
    self.articles = data;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self showIndicator:false];
        [self.refreshControl endRefreshing];
    });
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NewsArticle *article = self.articles[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.detailItem = article;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        self.detailViewController = controller;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsArticle *article = self.articles[indexPath.row];
    NSString* cellIdToChoose;
    if(article.img) {
        cellIdToChoose = CELL_ID;
    } else {
        cellIdToChoose = NO_IMAGE_CELL_ID;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdToChoose forIndexPath:indexPath];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *descrLabel = (UILabel *)[cell viewWithTag:3];
    
    titleLabel.text = article.title;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithData:[article.descriptionText dataUsingEncoding:NSUTF8StringEncoding]
                                                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                              NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                         documentAttributes:nil error:nil];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
    descrLabel.attributedText = attrString;
    
    if(article.img) {
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:2];
        imgView.image = article.img;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] windows].firstObject.windowScene.interfaceOrientation;
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        return ROW_HEIGHT_PORT;
    } else {
        return ROW_HEIGHT_LAND;
    }
}


@end
