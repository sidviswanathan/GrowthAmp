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


#import "GAFrameworkUtils.h"
#import "NSDictionary+JSONCategories.h"
#import "GAUserPreferences.h"
#import "NSCalendar+DaysFromDate.h"
#import "GADeviceInfo.h"
#import "GAConfigManager.h"
#import "GASessionManager.h"
#import "GAContactsCache.h"
#import "GAConstants.h"

@protocol GALoaderDelegate <NSObject>

@end

@interface GALoader ()

@property (nonatomic, weak) id<GALoaderDelegate> delegate;
@property (nonatomic, weak) UIViewController *mainViewController;

@property (nonatomic, strong) NSString *navigationTitle;
@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) NSString *headerSubTitle;


@property (nonatomic, strong) NSArray *devices;

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

    
    [[GASessionManager sharedManager] startSessionOfType:sessionType];
    
    if (showSplash) {
        GAMainViewController *mainViewController = [[GAMainViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        [controller presentViewController:navController animated:YES completion:nil];
    } else {
        
        [self presentInvitationsFromController:controller];
    
    }
}


- (void)presentInvitationsFromController:(UIViewController *)controller {
    
    
    GAInvitationsViewController *invitationsController = [[GAInvitationsViewController alloc] init];
    invitationsController.headerTitle = [[GAConfigManager sharedInstance] stringForConfigKey:@"selectHeaderTitleText" default:@"Spread the Love"];
    invitationsController.headerSubTitle = self.headerSubTitle;
    invitationsController.maxNumberOfContacts = [[GAConfigManager sharedInstance] maxNumberOfContacts];
    invitationsController.selectAllEnabled = [[GAConfigManager sharedInstance] selectAllEnabled];
    
    
    if ([controller isKindOfClass:[UINavigationController class]]) {

        UINavigationController *navCon = (UINavigationController*)controller;
        [navCon pushViewController:invitationsController animated:YES];

    } else {
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:invitationsController];
        [controller presentViewController:navController animated:YES completion:nil];
    }

    
}

@end
