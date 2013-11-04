//
//  GAAPIManager.m
//  GroethAmp
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
    
    // retry example https://github.com/AFNetworking/AFNetworking/issues/393
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"secret" : [[GAConfigManager sharedInstance] stringForConfigKey:@"secret" default:@""],
                                     @"customer_id" : [GAUserPreferences getObjectOfTypeKey:kCustomerIDKey],
                                     @"device_id" : [GADeviceInfo deviceID],
                                     @"device_type" : [GADeviceInfo deviceType],
                                     @"device_os" : [GADeviceInfo deviceOS],
                                     @"device_carrier" : [GADeviceInfo deviceCarrier],
                                     @"sdk_version" : @(kSDKVersion),
                                     @"device_locale" : [GADeviceInfo deviceLocale],
                                     @"ip_address" : [GADeviceInfo ipAddress],
                                     }];
    
    id user_id = [GAUserPreferences getObjectOfTypeKey:kUserIDKey];
    
    if (user_id) {
        
        NSString *endPointPath = [NSString stringWithFormat:@"%@\%@",kUserEndPoint,[user_id stringValue]];
        [[GAAPIClient sharedClient] PUT:endPointPath parameters:params
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     NSLog(@"JSON: %@", responseObject);
                                     
                                     [GAUserPreferences setObjectOfTypeKey:kUserIDKey object:responseObject[@"details"][@"user_id"]];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"Error: %@", error);
                                     
                                     // If failure, sechedule again for later
                                     
                                 }];

    
    } else {
        
        [[GAAPIClient sharedClient] POST:kUserEndPoint parameters:params
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     NSLog(@"JSON: %@", responseObject);
                                     
                                      [GAUserPreferences setObjectOfTypeKey:kUserIDKey object:responseObject[@"details"][@"user_id"]];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"Error: %@", error);
                                     
                                     // If failure, sechedule again for later
                                     
                                 }];
    }
}

+ (void)sendSessionInfo:(NSDictionary*)params {

}

@end
