//
//  GATableViewController.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/4/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GATableViewController.h"

@interface GATableViewController ()

@property (nonatomic, strong) UISearchDisplayController *searchController;

@end

@implementation GATableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackground];
    [self setupSearchbar];
    [self setupSpinner];
    
    self.searchDisplayController.searchResultsTableView.delegate = self;
}

- (void)setupBackground {
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)setupSearchbar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
    
    [self.searchBar sizeToFit];
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.delegate = self;
    
    [self.view addSubview:self.searchBar];
    
    CGFloat height = CGRectGetHeight(self.searchBar.frame);
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.origin.y = height;
    tableFrame.size.height -= height;
    self.tableView.frame = tableFrame;
}

- (void)loadView {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height - 88)];
    contentView.autoresizesSubviews = YES;
    contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    contentView.backgroundColor = [UIColor yellowColor];
    
    self.view = contentView;
    
    self.tableView = [[UITableView alloc] initWithFrame:contentView.frame style:UITableViewStylePlain];
    self.tableView.autoresizesSubviews = YES;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    [self addEmptyHeader];
}

- (void)addEmptyHeader {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
    self.tableView.tableHeaderView = sectionView;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
    self.tableView.tableFooterView = view;
}

- (GACellPosition)positionForCellAtIndexPath:(NSIndexPath *)indexPath inArray:(NSArray *)array {
    NSUInteger position = 0;
    if (indexPath.row == 0) {
        position |= GACellPositionTop;
    }
    if (indexPath.row == array.count - 1) {
        position |= GACellPositionBottom;
    }
    return position;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
    UIImage *image = GAImage(@"background");
    tableView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
    tableView.tableHeaderView = sectionView;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupSpinner {
    CGSize size = self.tableView.frame.size;
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    spinner.center = CGPointMake(size.width / 2, size.height / 2);

    [self.view addSubview:spinner];
    
    self.spinner = spinner;
}

@end
