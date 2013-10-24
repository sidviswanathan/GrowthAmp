//
//  GAAPIManager.m
//  GroethAmp
//
//  Created by DON SHEFER on 9/30/13.
//  Copyright (c) 2013 Don Shefer. All rights reserved.
//

#import "GAAPIClient.h"
#import "GAUserPreferences.h"

@implementation GAAPIClient

+ (id)sharedClient
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURL]];
    });
    return _sharedObject;
}

@end
