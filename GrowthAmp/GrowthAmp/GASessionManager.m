//
//  GASessionManager.m
//  GrowthAmp
//
//  Created by Don Shefer on 11/4/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GASessionManager.h"
#import "GAAPIClient.h"

@implementation GASessionManager {
    
    NSDate *sessionStart;
}

+ (id)sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

-(void)startSession {
        
    if (!sessionStart) {

        NSLog(@"Start GA Session");
        sessionStart = [NSDate date];
    
        [GAAPIClient sendUserInfo];
    
    } else {
        
        NSLog(@"GA session already started");

    }
    
    
}

-(void)endSession {
    
    NSTimeInterval sessionLength = [[NSDate date] timeIntervalSinceDate:sessionStart];
    NSLog(@"sessionLen: %f",sessionLength);
    
    
    [GAAPIClient sendSessionInfo:@{@"session_length" : @(sessionLength)}];
    
    
    sessionStart = nil;
}


@end
