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

+ (void)sendUserInfo;
+ (void)sendSessionInfo:(NSDictionary*)params;

@end
