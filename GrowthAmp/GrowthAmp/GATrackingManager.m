//
//  GATrackingManager.m
//  GrowthAmp
//
//  Created by Don Shefer on 9/17/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GATrackingManager.h"
#import "GAUserAction.h"
#import "GAConfigManager.h"
#import "GAAPIClient.h"
#import "GAUserPreferences.h"
#import "GASessionManager.h"
#import "GAConstants.h"

@implementation GATrackingManager {
    
    NSMutableArray *_userActionStore;
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

-(void)reportUserActionWithName:(NSString*)name
                           type:(NSString*)type
                           info:(NSDictionary*)info
{
    if (!_userActionStore) {
        _userActionStore = [NSMutableArray array];
    }
    
    GAUserAction *newAction = [[GAUserAction alloc] initWithName:name];
    newAction.actionType = type;
    newAction.timestamp = [NSDate date];
    newAction.trackingInfo = info;
    
    [_userActionStore addObject:newAction];
    
    NSLog(@"User action: %@",name);
}


-(void)sendTrackingDataToServer {
    
    if ([_userActionStore count] > 0) {

       
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:
                                       @{@"secret" : [[GAConfigManager sharedInstance] stringForConfigKey:@"secret" default:@""],
                                         @"user_id"         : [GAUserPreferences getObjectOfTypeKey:kUserIDKey],
                                         @"customer_id"     : [GAUserPreferences getObjectOfTypeKey:kCustomerIDKey],
                                         @"session_id"      : [[GASessionManager sharedManager] sessionID],
                                         }];
      

        NSMutableArray *actionArr = [NSMutableArray array];
        for (GAUserAction *obj in _userActionStore) {
            
            NSMutableDictionary *actionDict = [NSMutableDictionary dictionaryWithDictionary:
                                                @{@"name": obj.name,
                                                 @"type": obj.actionType,
                                                 @"timestamp": obj.timestamp,
                                                  }];
            
            [actionDict addEntriesFromDictionary:obj.trackingInfo];
            
            [actionArr addObject:actionDict];
        }
        
        [params setObject:actionArr forKey:@"page_keys"];
        
        [[GAAPIClient sharedClient] POST:kTrackingEndPoint parameters:params
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
                                     
            if ([[GAConfigManager sharedInstance] boolForConfigKey:@"enableJSONOutput" default:@"NO"]) {
       
                NSLog(@"JSON Response: %@", responseObject);
            }

       
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"Error: %@", error);
                                    
       
       
                                 }];
        
    }
}


@end
