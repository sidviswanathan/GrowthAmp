//
//  GADeviceInfo.h
//  GrowthAmp
//
//  Created by DON SHEFER on 9/12/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GADeviceInfo : NSObject

+(NSString*)appId;
+(NSString*)appName;
+(NSString*)deviceId;
+(NSString*)deviceType;
+(NSString*)deviceOS;
+(NSString*)deviceCarrier;
+(NSString*)deviceLocale;
+(NSString*)ipAddress;

+(void)test;
@end
