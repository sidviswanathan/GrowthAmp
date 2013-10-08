//
//  GALoader.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GALoader.h"
#import "GAInvitationsViewController.h"
#import "GAMainViewController.h"
#import "GAImport.h"
#import "GAAccessViewController.h"
#import "GAFrameworkUtils.h"
#import "NSDictionary+JSONCategories.h"
#import "GAUserPreferences.h"
#import "NSCalendar+MySpecialCalculation.h"
#import "GADeviceInfo.h"
#import "GAConfigManager.h"

@interface GALoader () <GAMainViewControllerDelegate, GGAAccessViewControllerDelegate>

@end

@implementation GALoader

+ (GALoader *)sharedInstance {
    static dispatch_once_t pred;
    static GALoader *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init {
    self = [super init];
    if (self) {
        
        [[GAConfigManager sharedInstance] loadConfig];
        
        //[GADeviceInfo test];
    }
    return self;
}


-(void)checkAutoLaunch:(UIViewController *)controller animated:(BOOL)animated showSplash:(BOOL)showSplash {
 
    if (![[GAConfigManager sharedInstance] isAutoLaunchEnabled]) {
        
        return;
    }
    
    int currentAppLaunchCount = [[GAUserPreferences getObjectOfTypeKey:@"appLaunchCount"] intValue];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *dateOfAutolaunch = [GAUserPreferences getObjectOfTypeKey:@"autolaunchDate"];
    int daysSinceLasttAutolaunch = 0;
    if (dateOfAutolaunch) {
        
        daysSinceLasttAutolaunch = [gregorianCalendar daysWithinEraFromDate:dateOfAutolaunch toDate:[NSDate date]];
    }
    
    if (!dateOfAutolaunch && (currentAppLaunchCount >= [[GAConfigManager sharedInstance] appLaunchedUntil1stAutoLaunch])) {
        
        [self presentInvitationsFromController:controller animated:animated showSplash:showSplash trackingCode:@"first_autolaunch"];
        
        [GAUserPreferences setObjectOfTypeKey:@"autolaunchDate" object:[NSDate date]];
        
        // Spoof date for testing
        //NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //[dateFormat setDateFormat:@"yyMMdd"];
        //[GAUserPreferences setObjectOfTypeKey:@"autolaunchDate" object:[dateFormat dateFromString:@"130801"]];
        
        
    } else if (daysSinceLasttAutolaunch >= [[GAConfigManager sharedInstance] daysUntil2ndAutoLaunch]) {
    
        [self presentInvitationsFromController:controller animated:animated showSplash:showSplash trackingCode:@"second_autolaunch"];
        
        [GAUserPreferences setObjectOfTypeKey:@"autolaunchDate" object:[NSDate date]];

    } else {
    
        [GAUserPreferences setObjectOfTypeKey:@"appLaunchCount" object:@(currentAppLaunchCount+1)];
        
    }
    
    
}

- (void)presentInvitationsFromController:(UIViewController *)controller animated:(BOOL)animated showSplash:(BOOL)showSplash
                            trackingCode:(NSString*)trackingCode {
    
    self.trackingCode = trackingCode;
    [self presentInvitationsFromController:controller animated:animated showSplash:showSplash];
}


- (void)presentInvitationsFromController:(UIViewController *)controller animated:(BOOL)animated showSplash:(BOOL)showSplash {
    if (showSplash) {
        GAMainViewController *mainViewController = [[GAMainViewController alloc] init];
        mainViewController.delegate = self;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        [controller presentViewController:navController animated:animated completion:nil];
    } else {
        [self presentInvitationsFromController:controller animated:animated];
    }
}

- (void)presentInvitationsFromController:(UIViewController *)controller animated:(BOOL)animated {
    // Get the contacts
    [GAImport contactsWithCompletion:^(NSArray *contacts, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                GAAccessViewController *accessController = [[GAAccessViewController alloc] init];
                accessController.delegate = self;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:accessController];
                [controller presentViewController:navController animated:animated completion:nil];
            } else {
                GAInvitationsViewController *invitationsController = [[GAInvitationsViewController alloc] initWithContacts:contacts];
                invitationsController.headerTitle = [[GAConfigManager sharedInstance] stringForConfigKey:@"selectHeaderTitleText" default:@"Spread the Love"];
                invitationsController.headerSubTitle = self.headerSubTitle;
                invitationsController.maxNumberOfContacts = [[GAConfigManager sharedInstance] maxNumberOfContacts];
                invitationsController.selectAllEnabled = [[GAConfigManager sharedInstance] selectAllEnabled];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:invitationsController];
                [controller presentViewController:navController animated:animated completion:nil];
            }
        });
    }];
}

- (void)mainViewController:(GAMainViewController *)controller didTapOnContinueButton:(UIButton *)button {
    // Get the contacts
    [GAImport contactsWithCompletion:^(NSArray *contacts, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                GAAccessViewController *accessController = [[GAAccessViewController alloc] init];
                accessController.delegate = self;
                [controller.navigationController pushViewController:accessController animated:YES];
            } else {
                GAInvitationsViewController *invitationsController = [[GAInvitationsViewController alloc] initWithContacts:contacts];
                invitationsController.headerTitle = [[GAConfigManager sharedInstance] stringForConfigKey:@"selectHeaderTitleText" default:@"Spread the Love"];
                invitationsController.headerSubTitle = self.headerSubTitle;
                invitationsController.maxNumberOfContacts = [[GAConfigManager sharedInstance] maxNumberOfContacts];
                invitationsController.selectAllEnabled = [[GAConfigManager sharedInstance] selectAllEnabled];
                [controller.navigationController pushViewController:invitationsController animated:YES];
            }
        });
    }];
}

- (void)accessViewController:(GAAccessViewController *)controller didTapOnNextButton:(UIButton *)button {
    // Get the contacts
    [GAImport contactsWithCompletion:^(NSArray *contacts, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
            } else {
                GAInvitationsViewController *invitationsController = [[GAInvitationsViewController alloc] initWithContacts:contacts];
                invitationsController.headerTitle = [[GAConfigManager sharedInstance] headerTitle];
                invitationsController.headerSubTitle = self.headerSubTitle;
                invitationsController.maxNumberOfContacts = [[GAConfigManager sharedInstance] maxNumberOfContacts];
                [controller.navigationController pushViewController:invitationsController animated:YES];
            }
        });
    }];
}

@end
