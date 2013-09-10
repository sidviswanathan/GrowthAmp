//
//  GAInvitationsViewController.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAInvitationsViewController.h"
#import "GAContact.h"
#import "GAPhoneNumber.h"
#import "GAContactCell.h"
#import "NSString+GAUtils.h"
#import "GAABImport.h"
#import "GAFilter.h"
#import "GASorter.h"
#import "GAPhoneFilter.h"

#define kGAHeader @"header"

@interface GAInvitationsViewController ()

@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, strong) NSArray *allContacts;
@property (nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic, strong) NSMutableSet *selectedContacts;
@property (nonatomic) BOOL allSelected;

@property (nonatomic) BOOL shouldRelaodTableView;

@end

@implementation GAInvitationsViewController

- (id)initWithContacts:(NSArray *)contacts {
    self = [super init];
    if (self) {
        // Custom initialization
        self.contacts = [contacts mutableCopy];
        self.items = [[NSMutableArray alloc] init];
        self.selectedContacts = [[NSMutableSet alloc] init];
        self.navigationItem.title = GALocalizedString(@"invite_friends", nil);
        
        self.allSelected = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nextButton.enabled = self.selectedContacts.count > 0;
    
    [self parseContacts];
}

- (void)parseContacts {
    self.searchBar.hidden = YES;
    self.nextButton.enabled = NO;
    [self.spinner startAnimating];
    
    // (1) Filter them
    GAFilter *filter = [[GAFilter alloc] init];
    [filter filterContacts:self.contacts usingFilters:@[[GAPhoneFilter class]] completion:^(NSArray *contacts, NSError *error) {
        // (2) Sort them
        GASorter *sorter = [[GASorter alloc] init];
        [sorter sortContacts:contacts completion:^(NSArray *contacts, NSError *error) {
            // (3) Present them
            dispatch_async(dispatch_get_main_queue(), ^{
                self.allContacts = contacts;
                if (contacts.count > self.maxNumberOfContacts) {
                    self.contacts = [[contacts subarrayWithRange:NSMakeRange(0, self.maxNumberOfContacts)] mutableCopy];
                } else {
                    self.contacts = [contacts mutableCopy];
                }
                [self.items addObject:kGAHeader];
                [self.items addObjectsFromArray:self.contacts];
                
                if (self.allSelected) {
                    for (GAContact *contact in self.contacts) {
                        [self.selectedContacts addObject:contact];
                    }
                }
                
                self.nextButton.enabled = self.selectedContacts.count > 0;
                
                [self.spinner stopAnimating];
                self.searchBar.hidden = NO;
                [self.tableView reloadData];
            });
        }];
    }];
}

#pragma mark -
#pragma mark Helpers

- (GAHeaderModel *)headerModel {
    GAHeaderModel *model = [[GAHeaderModel alloc] init];
    model.headerTitle = self.headerTitle;
    
    NSDictionary *data = @{@"count": @(MIN(self.contacts.count, self.maxNumberOfContacts))};
    model.headerSubTitle = GALocalizedFormattedString(@"tap_next_to_invite_friends", data);
    
    return model;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        arr = self.searchResults;
    } else {
        arr = self.items;
    }
    
    id item = arr[indexPath.row];
    if ([item isKindOfClass:[NSString class]]) {
        return [GAHeaderCell height];
    } else {
        return [GAContactCell height];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier;
    GACell *cell;
    
    NSArray *arr;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        arr = self.searchResults;
    } else {
        arr = self.items;
    }
    
    id item = arr[indexPath.row];
    
    if ([item isKindOfClass:[NSString class]]) {
        reuseIdentifier = [GAHeaderCell reuseIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[GAHeaderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        }
        cell.cellPosition = [self positionForCellAtIndexPath:indexPath inArray:arr];
        ((GAHeaderCell *)cell).status = self.allSelected;
        ((GAHeaderCell *)cell).delegate = self;
        ((GAHeaderCell *)cell).model = [self headerModel];
    } else {
        reuseIdentifier = [GAContactCell reuseIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[GAContactCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        }
        cell.cellPosition = [self positionForCellAtIndexPath:indexPath inArray:arr];
        
        GAContact *contact = (GAContact *)item;
        if ([self.selectedContacts containsObject:contact]) {
            ((GAContactCell *)cell).checked = YES;
        } else {
            ((GAContactCell *)cell).checked = NO;
        }
        
        ((GAContactCell *)cell).contact = (GAContact *)item;
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
    } else {
        return [self.items count];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)headerCell:(GAHeaderCell *)cell didChangeWithSelectStatus:(GAHeaderCellStatus)status {
    self.allSelected = status;
    if (self.allSelected) {
        for (GAContact *contact in self.contacts) {
            [self.selectedContacts addObject:contact];
        }
    } else {
        [self.selectedContacts removeAllObjects];
    }
    [self.tableView reloadData];
    
    self.nextButton.enabled = self.selectedContacts.count > 0;
}

- (void)searchBar:(UISearchBar *)search textDidChange:(NSString *)text {
    [self filterContentForSearchText:text];
}

- (BOOL)compareSearchText:(NSString*)searchText withString:(NSString*)str {
	NSRange range;
	range = [str rangeOfString:searchText options:NSDiacriticInsensitiveSearch|NSCaseInsensitiveSearch];
	return range.location != NSNotFound;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *items;
    
    BOOL inSearch = tableView == self.searchDisplayController.searchResultsTableView;
    
    items = inSearch ? self.searchResults : self.items;

    id item = items[indexPath.row];
    if (![item isKindOfClass:[GAContact class]]) {
        return;
    }
    
    BOOL reload = NO;
    GAContact *contact = (GAContact *)item;
    if ([self.selectedContacts containsObject:contact]) {
        [self.selectedContacts removeObject:contact];
        self.allSelected = NO;
        if (self.selectedContacts.count == 0) {
            reload = YES;
        }
    } else {
        [self.selectedContacts addObject:contact];
        if (self.selectedContacts.count == self.contacts.count) {
            self.allSelected = YES;
            reload = YES;
        }
        
        if (inSearch && [self.contacts indexOfObject:contact] == NSNotFound) {
            [self.contacts insertObject:contact atIndex:0];
            if (self.contacts.count > self.maxNumberOfContacts) {
                [self.contacts removeObjectAtIndex:self.contacts.count - 1];
            }
            self.items = [[NSMutableArray alloc] init];
            [self.items addObject:kGAHeader];
            [self.items addObjectsFromArray:self.contacts];
        }
    }
    
    if (reload) {
        [tableView reloadData];
    } else {
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
    }
        
    if (inSearch) {
        self.shouldRelaodTableView = YES;
    }
    
    self.nextButton.enabled = self.selectedContacts.count > 0;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
    if (self.shouldRelaodTableView) {
        self.shouldRelaodTableView = NO;
        [self.tableView reloadData];
    }
}

- (void)filterContentForSearchText:(NSString*)text {
    // [searchTimer invalidate];
    // searchTimer = nil;
    
    [self.searchResults removeAllObjects];
    
    self.searchResults = [[NSMutableArray alloc] init];
    
    for (GAContact *contact in self.allContacts) {
        if ((contact.firstName && [self compareSearchText:text withString:contact.firstName]) ||
            (contact.lastName && [self compareSearchText:text withString:contact.lastName])) {
            
            [self.searchResults addObject:contact];
        }
    }
    
    UITableView *searchResultTableView = self.searchDisplayController.searchResultsTableView;
    [searchResultTableView reloadData];
    
    [searchResultTableView setContentOffset:CGPointZero animated:YES];
}

#pragma mark -
#pragma mark Navigation Buttons

- (void)didTapOnNextButton {
    [super didTapOnNextButton];
    
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        NSMutableArray *numbers = [[NSMutableArray alloc] init];
        for (GAContact *contact in [self.selectedContacts allObjects]) {
            GAPhoneNumber *phoneNumber = (GAPhoneNumber*)contact.phoneNumbers[0];
            [numbers addObject:phoneNumber.number];
        }
        picker.recipients = numbers;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
