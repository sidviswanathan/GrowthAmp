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
#import "GAABImport.h"
#import "GAAccessViewController.h"
#import "GAFrameworkUtils.h"
#import "NSDictionary+JSONCategories.h"
#import "GAUserPreferences.h"
#import "NSCalendar+MySpecialCalculation.h"

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
        
        [self loadConfig];
    }
    return self;
}

-(void)loadConfig {
    
    // Load GAConfig.json
    NSDictionary *configDict = [NSDictionary dictionaryWithNameOfJSONFile:@"GAConfig.json"];
    
    if (configDict) {

        self.sdkVersion = [configDict objectForKey:@"sdkVersion"];
        
        self.isAutoLaunchEnabled = [[configDict valueForKey:@"isAutoLaunchEnabled"] boolValue];
        self.appLaunchedUntil1stAutoLaunch = [[configDict valueForKey:@"appLaunchedUntil1stAutoLaunch"] integerValue];
        self.daysUntil2ndAutoLaunch = [[configDict valueForKey:@"daysUntil2ndAutoLaunch"] integerValue];
        
        self.isContactSelectEnabled = [[configDict valueForKey:@"isContactSelectEnabled"] integerValue];
        self.maxNumberOfContacts = [[configDict valueForKey:@"maxNumberOfContacts"] integerValue];

        self.apiPostURL = [configDict objectForKey:@"apiPostURL"];
        self.trackingPostURL = [configDict objectForKey:@"trackingPostURL"];
        self.userPostURL = [configDict objectForKey:@"userPostURL"];
        self.sessionPostURL = [configDict objectForKey:@"sessionPostURL"];
        self.invitationURL = [configDict objectForKey:@"invitationURL"];
        
    
    } else {
        
        NSLog(@"GAConfig.json appears to be missing from the project. Using defaults");
        
        // Default configuration values
        self.sdkVersion = @"1.0";
        
        self.isAutoLaunchEnabled = NO;
        self.appLaunchedUntil1stAutoLaunch = 3;
        self.daysUntil2ndAutoLaunch = 30;
        
        self.isContactSelectEnabled = YES;
        self.maxNumberOfContacts = 10;
        
    }
    
    
}

-(void)checkAutoLaunch:(UIViewController *)controller animated:(BOOL)animated showSplash:(BOOL)showSplash {
 
    if (!self.isAutoLaunchEnabled) {
        
        return;
    }
    
    int currentAppLaunchCount = [[GAUserPreferences getObjectOfTypeKey:@"appLaunchCount"] intValue];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *dateOfFirstAutolaunch = [GAUserPreferences getObjectOfTypeKey:@"firstAutolaunchDate"];
    int daysSince1stAutolaunch = 0;
    if (dateOfFirstAutolaunch) {
        
        daysSince1stAutolaunch = [gregorianCalendar daysWithinEraFromDate:dateOfFirstAutolaunch toDate:[NSDate date]];
    }
    
    if (!dateOfFirstAutolaunch && (currentAppLaunchCount >= self.appLaunchedUntil1stAutoLaunch)) {
        
        [self presentInvitationsFromController:controller animated:animated showSplash:showSplash trackingCode:@"first_autolaunch"];
        
        [GAUserPreferences setObjectOfTypeKey:@"firstAutolaunchDate" object:[NSDate date]];
        
        // Spoof date for testing
        //NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //[dateFormat setDateFormat:@"yyMMdd"];
        //[GAUserPreferences setObjectOfTypeKey:@"firstAutolaunchDate" object:[dateFormat dateFromString:@"130901"]];
        
        
    } else if (![[GAUserPreferences getObjectOfTypeKey:@"secondAutolaunch"] boolValue] && (daysSince1stAutolaunch >= self.daysUntil2ndAutoLaunch)) {
    
        [self presentInvitationsFromController:controller animated:animated showSplash:showSplash trackingCode:@"second_autolaunch"];
        
        [GAUserPreferences setObjectOfTypeKey:@"secondAutolaunch" object:[NSNumber numberWithBool:YES]];

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
    [GAABImport contactsWithCompletion:^(NSArray *contacts, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                GAAccessViewController *accessController = [[GAAccessViewController alloc] init];
                accessController.delegate = self;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:accessController];
                [controller presentViewController:navController animated:animated completion:nil];
            } else {
                GAInvitationsViewController *invitationsController = [[GAInvitationsViewController alloc] initWithContacts:contacts];
                invitationsController.headerTitle = self.headerTitle;
                invitationsController.headerSubTitle = self.headerSubTitle;
                invitationsController.maxNumberOfContacts = self.maxNumberOfContacts;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:invitationsController];
                [controller presentViewController:navController animated:animated completion:nil];
            }
        });
    }];
}

- (void)mainViewController:(GAMainViewController *)controller didTapOnContinueButton:(UIButton *)button {
    // Get the contacts
    [GAABImport contactsWithCompletion:^(NSArray *contacts, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                GAAccessViewController *accessController = [[GAAccessViewController alloc] init];
                accessController.delegate = self;
                [controller.navigationController pushViewController:accessController animated:YES];
            } else {
                GAInvitationsViewController *invitationsController = [[GAInvitationsViewController alloc] initWithContacts:contacts];
                invitationsController.headerTitle = self.headerTitle;
                invitationsController.headerSubTitle = self.headerSubTitle;
                invitationsController.maxNumberOfContacts = self.maxNumberOfContacts;
                [controller.navigationController pushViewController:invitationsController animated:YES];
            }
        });
    }];
}

- (void)accessViewController:(GAAccessViewController *)controller didTapOnNextButton:(UIButton *)button {
    // Get the contacts
    [GAABImport contactsWithCompletion:^(NSArray *contacts, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
            } else {
                GAInvitationsViewController *invitationsController = [[GAInvitationsViewController alloc] initWithContacts:contacts];
                invitationsController.headerTitle = self.headerTitle;
                invitationsController.headerSubTitle = self.headerSubTitle;
                invitationsController.maxNumberOfContacts = self.maxNumberOfContacts;
                [controller.navigationController pushViewController:invitationsController animated:YES];
            }
        });
    }];
}

@end
