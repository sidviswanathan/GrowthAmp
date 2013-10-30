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
#import "GAConfigManager.h"

#define kGAHeader @"header"

@interface GAInvitationsViewController ()

@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, strong) NSArray *allContacts;
@property (nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic, strong) NSMutableSet *selectedContacts;

@property (nonatomic) BOOL shouldRelaodTableView;

@end

@implementation GAInvitationsViewController {
    
    UIActivityIndicatorView *_spinner;
}

- (id)initWithContacts:(NSArray *)contacts {
    self = [super init];
    if (self) {
        // Custom initialization
        self.contacts = [contacts mutableCopy];
        self.items = [[NSMutableArray alloc] init];
        self.selectedContacts = [[NSMutableSet alloc] init];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = GALocalizedString(@"invite_friends", nil);
        titleLabel.textColor = [[GAConfigManager sharedInstance] colorForConfigKey:@"navBarTextColor" default:@"#FFFFFF"];
        self.navigationItem.titleView = titleLabel;
        
        self.selectAllEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if( kSystemVersion >= 7 ) {

        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.nextButton.enabled = self.selectedContacts.count > 0;
    
    _spinner = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(100,150,120,120)];
    _spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    
    [self parseContacts];
    
    [[GATrackingManager sharedManager] reportUserActionWithName:kTrackingKeyPageContacts
                                                           type:kTrackingKeyTypeFull
                                                           info:nil];
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
                
                if (self.selectAllEnabled) {
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
    
    [_spinner stopAnimating];
}

#pragma mark -
#pragma mark Helpers

- (GAHeaderModel *)headerModel {
    GAHeaderModel *model = [[GAHeaderModel alloc] init];
    model.headerTitle = self.headerTitle;
    
    int count = MIN(self.selectedContacts.count, self.maxNumberOfContacts);
    
    NSString *subtitleStr = [NSString stringWithFormat:@"Tap next to invite %d friends",count];
    
    NSMutableAttributedString *notifyingStr = [[NSMutableAttributedString alloc] initWithString:subtitleStr];
    [notifyingStr beginEditing];
    [notifyingStr addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:14.0f]
                         range:NSMakeRange(18,3) ];
    [notifyingStr endEditing];
    
    
    model.headerSubTitle = notifyingStr;
    
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
        ((GAHeaderCell *)cell).status = self.selectAllEnabled;
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [[GATrackingManager sharedManager] reportUserActionWithName:kTrackingKeyActionContactsScroll
                                                           type:kTrackingKeyTypeAction
                                                           info:nil];
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
    self.selectAllEnabled = status;
    if (self.selectAllEnabled) {
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
    BOOL didSelect = NO;
    BOOL didUnselect = NO;
    
    items = inSearch ? self.searchResults : self.items;

    id item = items[indexPath.row];
    if (![item isKindOfClass:[GAContact class]]) {
        return;
    }
    
    BOOL reload = NO;
    GAContact *contact = (GAContact *)item;
    if ([self.selectedContacts containsObject:contact]) {
        [self.selectedContacts removeObject:contact];
        didUnselect = YES;
        self.selectAllEnabled = NO;
        if (self.selectedContacts.count == 0) {
            reload = YES;
        }
    } else {
        [self.selectedContacts addObject:contact];
        didSelect = YES;
        if (self.selectedContacts.count == self.contacts.count) {
            self.selectAllEnabled = YES;
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
        if (!inSearch) {
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        [tableView endUpdates];
    }
        
    if (inSearch) {
        self.shouldRelaodTableView = YES;
    }
    
    self.nextButton.enabled = self.selectedContacts.count > 0;
    
    // Track action
    NSString *trackingKey;
    
    if (didUnselect) {
        
         trackingKey = inSearch ? kTrackingKeyActionContactsSearchUnselect : kTrackingKeyActionContactsUnselect;
    }
    
    if (didSelect) {
        
        trackingKey = inSearch ? kTrackingKeyActionContactsSearchSelect : kTrackingKeyActionContactsSelect;
    }
    
    if (trackingKey) {

        [[GATrackingManager sharedManager] reportUserActionWithName:trackingKey
                                                               type:kTrackingKeyTypeAction
                                                               info:nil];
    }
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

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
        [[GATrackingManager sharedManager] reportUserActionWithName:kTrackingKeyActionContactsSearch
                                                         type:kTrackingKeyTypeAction
                                                         info:nil];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
   
    [[GATrackingManager sharedManager] reportUserActionWithName:kTrackingKeyActionContactsSearchCancel
                                                           type:kTrackingKeyTypeAction
                                                           info:nil];
}

#pragma mark -
#pragma mark Navigation Buttons

- (void)didTapOnCloseButton {
    
    [[GATrackingManager sharedManager] reportUserActionWithName:kTrackingKeyActionContactsX
                                                           type:kTrackingKeyTypeAction
                                                           info:nil];
    
    [super didTapOnCloseButton];
}


- (void)didTapOnNextButton {
    
    [[GATrackingManager sharedManager] reportUserActionWithName:kTrackingKeyActionContactsNext
                                                           type:kTrackingKeyTypeAction
                                                           info:nil];

    [super didTapOnNextButton];
    
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        NSMutableArray *numbers = [[NSMutableArray alloc] init];
        for (GAContact *contact in [self.selectedContacts allObjects]) {
            GAPhoneNumber *phoneNumber = (GAPhoneNumber*)contact.phoneNumbers[0];
            [numbers addObject:phoneNumber.number];
        }
        // limit sms to 50 recipient
        if ([numbers count] > kMaxRecipients) {
            numbers = (NSMutableArray*)[numbers subarrayWithRange:NSMakeRange(0, kMaxRecipients)];
        }
        picker.recipients = numbers;
        picker.body = [[GAConfigManager sharedInstance] stringForConfigKey:@"invitationText" default:@""];
        [self presentViewController:picker animated:YES completion:nil];
        
        [[GATrackingManager sharedManager] reportUserActionWithName:kTrackingKeyPageSMS
                                                               type:kTrackingKeyTypeFull
                                                               info:nil];
    } else {
        
        NSLog(@"SMS is not supported!");

#if (TARGET_IPHONE_SIMULATOR)

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SMS messaging functionality not supported"
                                                        message:@"SMS messaging functionality is not supported in the iOS simulator, please rebuild the app to a device to test the SMS messaging component of the SDK. "
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        
#endif
        
    }
}

#pragma mark -
#pragma mark MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString *trackingKey;
    switch (result) {
        case MessageComposeResultCancelled:
            trackingKey = kTrackingKeyActionSMSCancel;
            break;
        case MessageComposeResultSent:
            trackingKey = kTrackingKeyActionSMSSend;
            break;
        case MessageComposeResultFailed:
            trackingKey = kTrackingKeyActionSMSFailed;
            break;
            
    }
    
    [[GATrackingManager sharedManager] reportUserActionWithName:trackingKey
                                                           type:kTrackingKeyTypeAction
                                                           info:nil];
    
}

@end
