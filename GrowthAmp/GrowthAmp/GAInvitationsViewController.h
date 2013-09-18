//
//  GAInvitationsViewController.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GATableViewController.h"
#import "GAHeaderCell.h"
#import <MessageUI/MessageUI.h>

@interface GAInvitationsViewController : GATableViewController <GAHeaderCellDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) NSString *headerSubTitle;
@property (nonatomic) NSInteger maxNumberOfContacts;
@property (nonatomic) BOOL selectAllEnabled;

- (id)initWithContacts:(NSArray *)contacts;

@end

