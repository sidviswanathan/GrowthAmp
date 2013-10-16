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

typedef enum {
    GACellPositionTop = 0x1,
    GACellPositionBottom = 0x2
} GACellPosition;

#define kMaxRecipients 50

@interface GAConstants : NSObject

@end