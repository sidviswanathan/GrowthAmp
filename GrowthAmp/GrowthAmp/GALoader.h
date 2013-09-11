//
//  GALoader.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GALoaderDelegate.h"
#import <UIKit/UIKit.h>

@interface GALoader : NSObject

@property (nonatomic, weak) id<GALoaderDelegate> delegate;
@property (nonatomic, weak) UIViewController *mainViewController;

@property (nonatomic, strong) NSString *navigationTitle;
@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) NSString *headerSubTitle;

@property (nonatomic, strong) NSArray *devices;

@property (nonatomic,retain) NSString *sdkVersion;
@property (nonatomic,assign) BOOL isAutoLaunchEnabled;
@property (nonatomic,assign) NSInteger appLaunchedUntil1stAutoLaunch;
@property (nonatomic,assign) NSInteger daysUntil2ndAutoLaunch;

@property (nonatomic,assign) BOOL isContactSelectEnabled;
@property (nonatomic,assign) NSInteger maxNumberOfContacts;

@property (nonatomic,retain) NSString *apiPostURL;
@property (nonatomic,retain) NSString *trackingPostURL;
@property (nonatomic,retain) NSString *userPostURL;
@property (nonatomic,retain) NSString *sessionPostURL;
@property (nonatomic,retain) NSString *invitationURL;

+ (GALoader *)sharedInstance;
- (void)presentInvitationsFromController:(UIViewController *)controller animated:(BOOL)animated;
- (void)presentInvitationsFromController:(UIViewController *)controller animated:(BOOL)animated showSplash:(BOOL)showSplash;

@end
