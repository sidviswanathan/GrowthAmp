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
#import "NSCalendar+DaysFromDate.h"
#import "GADeviceInfo.h"
#import "GAConfigManager.h"
#import "GASessionManager.h"
#import "GAContactsCache.h"

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


-(void)checkAutoLaunch:(UIViewController *)controller showSplash:(BOOL)showSplash {
 
    
    [[GAContactsCache sharedCache] invalidate];
    
    if (![[GAConfigManager sharedInstance] isAutoLaunchEnabled]) {
        
        return;
    }
    
    int currentAppLaunchCount = [[GAUserPreferences getObjectOfTypeKey:kAppLaunchCountKey] intValue];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *dateOfAutolaunch = [GAUserPreferences getObjectOfTypeKey:kAutoLaunchDateKey];
    int daysSinceLasttAutolaunch = 0;
    if (dateOfAutolaunch) {
        
        daysSinceLasttAutolaunch = [gregorianCalendar daysWithinEraFromDate:dateOfAutolaunch toDate:[NSDate date]];
    }
    
    if (!dateOfAutolaunch && (currentAppLaunchCount >= [[GAConfigManager sharedInstance] appLaunchedUntil1stAutoLaunch])) {
        
        [self presentInvitationsFromController:controller showSplash:showSplash sessionType:kFirstLaunchKey];
        
        [GAUserPreferences setObjectOfTypeKey:kAutoLaunchDateKey object:[NSDate date]];
        
        // Spoof date for testing
        //NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //[dateFormat setDateFormat:@"yyMMdd"];
        //[GAUserPreferences setObjectOfTypeKey:@"autolaunchDate" object:[dateFormat dateFromString:@"130801"]];
        
        
    } else if (daysSinceLasttAutolaunch >= [[GAConfigManager sharedInstance] daysUntil2ndAutoLaunch]) {
    
        [self presentInvitationsFromController:controller showSplash:showSplash sessionType:kSecondLaunchKey];
        
        [GAUserPreferences setObjectOfTypeKey:kAutoLaunchDateKey object:[NSDate date]];

    } else {
    
        [GAUserPreferences setObjectOfTypeKey:kAppLaunchCountKey object:@(currentAppLaunchCount+1)];
        
    }
    
    
}

-(void)fetchSettings {
    
    [[GAConfigManager sharedInstance] fetchSettings];
}

- (void) setUserContact:(NSDictionary*)userContact {
    
    [[GASessionManager sharedManager] setUserContact:userContact];
}

- (void)presentInvitationsFromController:(UIViewController *)controller
                              showSplash:(BOOL)showSplash
                             sessionType:(NSString*)sessionType {

    [[GASessionManager sharedManager] setSessionType:sessionType];
    [[GASessionManager sharedManager] startSession];
    
    if (showSplash) {
        GAMainViewController *mainViewController = [[GAMainViewController alloc] init];
        mainViewController.delegate = self;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        [controller presentViewController:navController animated:YES completion:nil];
    } else {
        // Get the contacts
        [GAImport contactsWithCompletion:^(NSArray *contacts, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    GAAccessViewController *accessController = [[GAAccessViewController alloc] init];
                    accessController.delegate = self;
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:accessController];
                    [controller presentViewController:navController animated:YES completion:nil];
                } else {
                    GAInvitationsViewController *invitationsController = [[GAInvitationsViewController alloc] initWithContacts:contacts];
                    invitationsController.headerTitle = [[GAConfigManager sharedInstance] stringForConfigKey:@"selectHeaderTitleText" default:@"Spread the Love"];
                    invitationsController.headerSubTitle = self.headerSubTitle;
                    invitationsController.maxNumberOfContacts = [[GAConfigManager sharedInstance] maxNumberOfContacts];
                    invitationsController.selectAllEnabled = [[GAConfigManager sharedInstance] selectAllEnabled];
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:invitationsController];
                    [controller presentViewController:navController animated:YES completion:nil];
                }
            });
        }];
    }
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
