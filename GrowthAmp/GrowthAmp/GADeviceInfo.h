//
//  GADeviceInfo.h
//  GrowthAmp
//
//  Created by DON SHEFER on 9/12/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GADeviceInfo : NSObject

+(NSString*)appID;
+(NSString*)appName;
+(NSString*)deviceID;
+(NSString*)deviceType;
+(NSString*)deviceOS;
+(NSString*)deviceCarrier;
+(NSString*)deviceLocale;
+(NSString*)ipAddress;

+(void)test;
@end
