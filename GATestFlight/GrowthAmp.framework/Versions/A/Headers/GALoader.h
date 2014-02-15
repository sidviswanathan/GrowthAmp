//
//  GALoader.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GALoader : NSObject

@property (nonatomic, strong) NSDictionary *userContact;

+ (GALoader*) sharedInstance;

- (void) fetchSettings;

- (void) checkAutoLaunch:(UIViewController *)controller
              showSplash:(BOOL)showSplash;

- (void) presentInvitationsFromController:(UIViewController*)controller
                               showSplash:(BOOL)showSplash
                              sessionType:(NSString*)sessionType;

- (void)presentInvitationsFromController:(UIViewController *)controller;

@end
