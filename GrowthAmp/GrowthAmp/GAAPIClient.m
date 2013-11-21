//
//  GAAPIManager.m
//  GrowthAmp
//
//  Created by DON SHEFER on 9/30/13.
//  Copyright (c) 2013 Don Shefer. All rights reserved.
//

#import "GAAPIClient.h"
#import "GAUserPreferences.h"
#import "GADeviceInfo.h"
#import "GAConfigManager.h"

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

+ (void)sendUserInfo {
    
    NSDictionary *params = @{@"secret"          : [[GAConfigManager sharedInstance] stringForConfigKey:@"secret" default:@""],
                             @"customer_id"     : [GAUserPreferences getObjectOfTypeKey:kCustomerIDKey],
                             @"device_id"       : [GADeviceInfo deviceID],
                             @"device_type"     : [GADeviceInfo deviceType],
                             @"device_os"       : [GADeviceInfo deviceOS],
                             @"device_carrier"  : [GADeviceInfo deviceCarrier],
                             @"sdk_version"     : @(kSDKVersion),
                             @"device_locale"   : [GADeviceInfo deviceLocale],
                             @"ip_address"      : [GADeviceInfo ipAddress],
                            };
    
    [GAAPIClient sendUserInfoRetryingNumberOfTimes:kMaxAPIRetries
                                        parameters:params
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                               NSLog(@"JSON: %@", responseObject);
                                               
                                               [GAUserPreferences setObjectOfTypeKey:kUserIDKey object:responseObject[@"details"][@"user_id"]];
                                                   
                                            }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                NSLog(@"Error: %@", error);
                                                   
                                                // If failure, sechedule again for later
                                                   
                                            }];
}

+(void)sendUserInfoRetryingNumberOfTimes:(NSUInteger)nTimes
                              parameters:(NSDictionary*)params
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    if (nTimes <= 0) {
        if (failure) {
            NSError *error = [NSError errorWithDomain: @"sendUserInfo: Max number of retries reached."
                                                 code:1 userInfo:nil];
            failure(nil,error);
        }
    } else {
        
        NSLog(@"SendUserInfo Attempt: %d",(kMaxAPIRetries - nTimes)+1);
        
        id user_id = [GAUserPreferences getObjectOfTypeKey:kUserIDKey];
        
        if (user_id) {
            
            NSString *endPointPath = [NSString stringWithFormat:@"%@\%@",kUserEndPoint,[user_id stringValue]];

            [[GAAPIClient sharedClient] PUT:endPointPath parameters:params
                                     success:success
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         
                                         [GAAPIClient sendUserInfoRetryingNumberOfTimes:nTimes - 1
                                                                                 parameters:params
                                                                                    success:success
                                                                                    failure:failure];
                                     }];

            
        } else {
            
            [[GAAPIClient sharedClient] POST:kUserEndPoint parameters:params
                                     success:success
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         
                                         [GAAPIClient sendUserInfoRetryingNumberOfTimes:nTimes - 1
                                                                                 parameters:params
                                                                                    success:success
                                                                                    failure:failure];
                                     }];
        }

        
        
       
    }
}

+ (void)sendSessionInfo:(NSDictionary*)params {

}


@end
