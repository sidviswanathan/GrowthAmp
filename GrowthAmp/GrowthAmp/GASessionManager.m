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
    
    NSDate *_sessionStart;
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

-(void)startSessionOfType:(NSString*)sessionType {
        

    NSLog(@"Start GA Session");
    _userContact = nil;
    _numContacts = 0;
    _sessionID = nil;
    
    _sessionType = sessionType;
    _sessionStart = [NSDate date];

}

-(void)endSession {
    
    NSTimeInterval sessionLength = [[NSDate date] timeIntervalSinceDate:_sessionStart];
    NSLog(@"sessionLen: %f",sessionLength);
    
    [GAAPIClient sendSessionInfo:@{@"session_length" : @(sessionLength),
                                   @"num_invited_contacts" : @(self.numContacts),
                                   @"session_type" : self.sessionType
                                   }];
    
    
    _sessionStart = nil;
}


@end
