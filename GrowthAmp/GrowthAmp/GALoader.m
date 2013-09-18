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
#import "GADeviceInfo.h"

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
        
        //[GADeviceInfo test];
    }
    return self;
}

-(void)loadConfig {
    
    self.config = [[GAConfig alloc] init];
    
    // Load GAConfig.json
    NSDictionary *configDict = [NSDictionary dictionaryWithNameOfJSONFile:@"GAConfig.json"];
    
    if (configDict) {

        self.config.sdkVersion = [configDict objectForKey:@"sdkVersion"];
        
        self.config.isAutoLaunchEnabled = [[configDict valueForKey:@"isAutoLaunchEnabled"] boolValue];
        self.config.appLaunchedUntil1stAutoLaunch = [[configDict valueForKey:@"appLaunchedUntil1stAutoLaunch"] integerValue];
        self.config.daysUntil2ndAutoLaunch = [[configDict valueForKey:@"daysUntil2ndAutoLaunch"] integerValue];
        
        self.config.selectAllEnabled = [[configDict valueForKey:@"selectAllEnabled"] integerValue];
        self.config.maxNumberOfContacts = [[configDict valueForKey:@"maxNumberOfContacts"] integerValue];

        self.config.apiPostURL = [configDict objectForKey:@"apiPostURL"];
        self.config.trackingPostURL = [configDict objectForKey:@"trackingPostURL"];
        self.config.userPostURL = [configDict objectForKey:@"userPostURL"];
        self.config.sessionPostURL = [configDict objectForKey:@"sessionPostURL"];
        self.config.invitationURL = [configDict objectForKey:@"invitationURL"];
        
    
    } else {
        
        NSLog(@"GAConfig.json appears to be missing from the project. Using defaults");
        
        // Default configuration values
        self.config.sdkVersion = @"1.0";
        
        self.config.isAutoLaunchEnabled = NO;
        self.config.appLaunchedUntil1stAutoLaunch = 3;
        self.config.daysUntil2ndAutoLaunch = 30;
        
        self.config.selectAllEnabled = YES;
        self.config.maxNumberOfContacts = 10;
        
    }
    
    
}

-(void)checkAutoLaunch:(UIViewController *)controller animated:(BOOL)animated showSplash:(BOOL)showSplash {
 
    if (!self.config.isAutoLaunchEnabled) {
        
        return;
    }
    
    int currentAppLaunchCount = [[GAUserPreferences getObjectOfTypeKey:@"appLaunchCount"] intValue];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *dateOfAutolaunch = [GAUserPreferences getObjectOfTypeKey:@"autolaunchDate"];
    int daysSinceLasttAutolaunch = 0;
    if (dateOfAutolaunch) {
        
        daysSinceLasttAutolaunch = [gregorianCalendar daysWithinEraFromDate:dateOfAutolaunch toDate:[NSDate date]];
    }
    
    if (!dateOfAutolaunch && (currentAppLaunchCount >= self.config.appLaunchedUntil1stAutoLaunch)) {
        
        [self presentInvitationsFromController:controller animated:animated showSplash:showSplash trackingCode:@"first_autolaunch"];
        
        [GAUserPreferences setObjectOfTypeKey:@"autolaunchDate" object:[NSDate date]];
        
        // Spoof date for testing
        //NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //[dateFormat setDateFormat:@"yyMMdd"];
        //[GAUserPreferences setObjectOfTypeKey:@"autolaunchDate" object:[dateFormat dateFromString:@"130801"]];
        
        
    } else if (daysSinceLasttAutolaunch >= self.config.daysUntil2ndAutoLaunch) {
    
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
                invitationsController.maxNumberOfContacts = self.config.maxNumberOfContacts;
                invitationsController.selectAllEnabled = self.config.selectAllEnabled;
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
                invitationsController.maxNumberOfContacts = self.config.maxNumberOfContacts;
                invitationsController.selectAllEnabled = self.config.selectAllEnabled;
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
                invitationsController.maxNumberOfContacts = self.config.maxNumberOfContacts;
                [controller.navigationController pushViewController:invitationsController animated:YES];
            }
        });
    }];
}

@end
