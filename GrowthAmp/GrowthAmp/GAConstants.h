//
//  GAConstants.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+GAUtils.h"
#include "TargetConditionals.h"

#define kSDKVersion 0.9

#define kMaxAPIRetries 3

#define kAPIBaseURL      @"http://www.growthamp.com"
#define kSettingsEndPoint @"settings/"
#define kTrackingEndPoint @"tracking/"
#define kUserEndPoint     @"user/"
#define kSessionEndPoint  @"session"


#define kSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define kCustomerIDKey @"customerID"
#define kUserIDKey @"userID"
#define kAppLaunchCountKey @"appLaunchCount"
#define kAutoLaunchDateKey @"autolaunchDate"
#define kFirstLaunchKey @"first_autolaunch"
#define kSecondLaunchKey @"second_autolaunch"


typedef enum {
    GACellPositionTop = 0x1,
    GACellPositionBottom = 0x2
} GACellPosition;

#define kMaxRecipients 50

