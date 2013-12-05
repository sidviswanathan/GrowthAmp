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
#import "GASessionManager.h"
#import "GATrackingManager.h"
#import "GAContact.h"

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

#pragma mark - User/ API

+ (void)sendUserInfoWithContacts:(NSArray*)contacts {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:
                           @{@"secret"          : [[GAConfigManager sharedInstance] stringForConfigKey:@"secret" default:@""],
                             @"customer_id"     : [GAUserPreferences getObjectOfTypeKey:kCustomerIDKey],
                             @"device_id"       : [GADeviceInfo deviceID],
                             @"device_type"     : [GADeviceInfo deviceType],
                             @"device_os"       : [GADeviceInfo deviceOS],
                             @"device_carrier"  : [GADeviceInfo deviceCarrier],
                             @"sdk_version"     : @(kSDKVersion),
                             @"device_locale"   : [GADeviceInfo deviceLocale],
                             @"ip_address"      : [GADeviceInfo ipAddress],
                            }];
    
    if (![[GASessionManager sharedManager] usingSampleData]) {
        NSMutableArray *contactsArr = [NSMutableArray array];
        for (GAContact *obj in contacts) {
            
            [contactsArr addObject:[obj dictionary]];
        }
        
        [params setObject:contactsArr forKey:@"contacts"];
    }
    
    [GAAPIClient sendUserInfoRetryingNumberOfTimes:kMaxAPIRetries
                                        parameters:params
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                               
                                               if ([[GAConfigManager sharedInstance] boolForConfigKey:@"enableJSONOutput" default:@"NO"]) {
                                                   
                                                   NSLog(@"JSON Response: %@", responseObject);
                                               }
                                               
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

+ (void)sendSessionInfo:(NSDictionary*)aParams {

    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"secret"          : [[GAConfigManager sharedInstance] stringForConfigKey:@"secret" default:@""],
                                                                                  @"user_id"         : [GAUserPreferences getObjectOfTypeKey:kUserIDKey],
                                                                                  @"customer_id"     : [GAUserPreferences getObjectOfTypeKey:kCustomerIDKey],
                                                                                  }];
    
    [params addEntriesFromDictionary:aParams];

    [GAAPIClient sendSessionInfoRetryingNumberOfTimes:kMaxAPIRetries
                                        parameters:params
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                   
                                                if ([[GAConfigManager sharedInstance] boolForConfigKey:@"enableJSONOutput" default:@"NO"]) {
                                                    
                                                    NSLog(@"JSON Response: %@", responseObject);
                                                }
                                               
                                               [[GASessionManager sharedManager] setSessionID:responseObject[@"details"][@"session_id"]];
                                               [[GATrackingManager sharedManager] sendTrackingDataToServer];
                                                   
                                        }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                NSLog(@"Error: %@", error);
                                                   
                                                // If failure, sechedule again for later
                                                   
                                            }];
    
}
    
+ (void)sendSessionInfoRetryingNumberOfTimes:(NSUInteger)nTimes
                                 parameters:(NSDictionary*)params
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
    {
        
        if (nTimes <= 0) {
            if (failure) {
                NSError *error = [NSError errorWithDomain: @"sendSessionInfo: Max number of retries reached."
                                                     code:1 userInfo:nil];
                failure(nil,error);
            }
        } else {
            
            NSLog(@"SendSessionInfo Attempt: %d",(kMaxAPIRetries - nTimes)+1);
            

                
                [[GAAPIClient sharedClient] POST:kSessionEndPoint parameters:params
                                         success:success
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             
                                             [GAAPIClient sendSessionInfoRetryingNumberOfTimes:nTimes - 1
                                                                                    parameters:params
                                                                                       success:success
                                                                                       failure:failure];
                                         }];
            }
            
        
    }


@end
