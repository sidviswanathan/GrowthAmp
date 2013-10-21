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

#define kAPIPostURL      @"http://"
#define kTrackingPostURL @"http://"
#define kUserPostURL     @"http://"
#define kSessionPostURL  @"http://"


#define kSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

typedef enum {
    GACellPositionTop = 0x1,
    GACellPositionBottom = 0x2
} GACellPosition;

#define kMaxRecipients 50

