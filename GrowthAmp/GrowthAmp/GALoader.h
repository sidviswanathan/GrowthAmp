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

@property (nonatomic, strong) NSString *trackingCode;
@property (nonatomic, strong) NSString *userFirstName;
@property (nonatomic, strong) NSString *userLastName;
@property (nonatomic, strong) NSString *userEmail;

@property (nonatomic, strong) NSArray *devices;

+ (GALoader *)sharedInstance;

- (void) checkAutoLaunch:(UIViewController *)controller animated:(BOOL)animated showSplash:(BOOL)showSplash;
-(void)fetchSettings;

- (void) presentInvitationsFromController:(UIViewController *)controller animated:(BOOL)animated;

- (void) presentInvitationsFromController:(UIViewController *)controller animated:(BOOL)animated showSplash:(BOOL)showSplash;

- (void) presentInvitationsFromController:(UIViewController *)controller animated:(BOOL)animated showSplash:(BOOL)showSplash
                            trackingCode:(NSString*)trackingCode;
@end
