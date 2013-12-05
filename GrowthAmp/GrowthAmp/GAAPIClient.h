//
//  GAAPIManager.h
//  GrowthAmp
//
//  Created by DON SHEFER on 9/30/13.
//  Copyright (c) 2013 Don Shefer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@interface GAAPIClient : AFHTTPRequestOperationManager

+ (id)sharedClient;

+ (void)sendUserInfoWithContacts:(NSArray*)contacts;
+ (void)sendUserInfoRetryingNumberOfTimes:(NSUInteger)nTimes
                              parameters:(NSDictionary*)params
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)sendSessionInfo:(NSDictionary*)params;
+ (void)sendSessionInfoRetryingNumberOfTimes:(NSUInteger)nTimes
                                  parameters:(NSDictionary*)params
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
