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
#import "GAConfig.h"

@interface GALoader () <GAMainViewControllerDelegate, GGAAccessViewControllerDelegate> {
    
    GAConfig *_config;
}


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
    
    _config = [[GAConfig alloc] init];
    
    // Load GAConfig.json
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GAConfig" ofType:@"plist"];
    NSDictionary *configDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    if (configDict) {

        _config.sdkVersion = [configDict objectForKey:@"sdkVersion"];
        
        _config.isAutoLaunchEnabled = [[configDict valueForKey:@"isAutoLaunchEnabled"] boolValue];
        _config.appLaunchedUntil1stAutoLaunch = [[configDict valueForKey:@"appLaunchedUntil1stAutoLaunch"] integerValue];
        _config.daysUntil2ndAutoLaunch = [[configDict valueForKey:@"daysUntil2ndAutoLaunch"] integerValue];
        
        _config.selectAllEnabled = [[configDict valueForKey:@"selectAllEnabled"] integerValue];
        _config.maxNumberOfContacts = [[configDict valueForKey:@"maxNumberOfContacts"] integerValue];

        _config.apiPostURL = [configDict objectForKey:@"apiPostURL"];
        _config.trackingPostURL = [configDict objectForKey:@"trackingPostURL"];
        _config.userPostURL = [configDict objectForKey:@"userPostURL"];
        _config.sessionPostURL = [configDict objectForKey:@"sessionPostURL"];
        _config.invitationURL = [configDict objectForKey:@"invitationURL"];
 
    
    } else {
        
        NSLog(@"GAConfig.json appears to be missing from the project. Using defaults");

        _config.sdkVersion = @"1.0";
        
        // Default configuration values
        _config.isAutoLaunchEnabled = NO;
        _config.appLaunchedUntil1stAutoLaunch = 3;
        _config.daysUntil2ndAutoLaunch = 30;
        
        _config.selectAllEnabled = YES;
        _config.maxNumberOfContacts = 10;
        
        _config.invitationURL = @"http://bit.ly/sample";

    }
    
    
}

-(void)checkAutoLaunch:(UIViewController *)controller animated:(BOOL)animated showSplash:(BOOL)showSplash {
 
    if (!_config.isAutoLaunchEnabled) {
        
        return;
    }
    
    int currentAppLaunchCount = [[GAUserPreferences getObjectOfTypeKey:@"appLaunchCount"] intValue];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *dateOfAutolaunch = [GAUserPreferences getObjectOfTypeKey:@"autolaunchDate"];
    int daysSinceLasttAutolaunch = 0;
    if (dateOfAutolaunch) {
        
        daysSinceLasttAutolaunch = [gregorianCalendar daysWithinEraFromDate:dateOfAutolaunch toDate:[NSDate date]];
    }
    
    if (!dateOfAutolaunch && (currentAppLaunchCount >= _config.appLaunchedUntil1stAutoLaunch)) {
        
        [self presentInvitationsFromController:controller animated:animated showSplash:showSplash trackingCode:@"first_autolaunch"];
        
        [GAUserPreferences setObjectOfTypeKey:@"autolaunchDate" object:[NSDate date]];
        
        // Spoof date for testing
        //NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //[dateFormat setDateFormat:@"yyMMdd"];
        //[GAUserPreferences setObjectOfTypeKey:@"autolaunchDate" object:[dateFormat dateFromString:@"130801"]];
        
        
    } else if (daysSinceLasttAutolaunch >= _config.daysUntil2ndAutoLaunch) {
    
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
                invitationsController.maxNumberOfContacts = _config.maxNumberOfContacts;
                invitationsController.selectAllEnabled = _config.selectAllEnabled;
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
                invitationsController.maxNumberOfContacts = _config.maxNumberOfContacts;
                invitationsController.selectAllEnabled = _config.selectAllEnabled;
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
                invitationsController.maxNumberOfContacts = _config.maxNumberOfContacts;
                [controller.navigationController pushViewController:invitationsController animated:YES];
            }
        });
    }];
}

@end
