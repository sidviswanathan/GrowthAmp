//
//  GADeviceInfo.m
//  GrowthAmp
//
//  Created by DON SHEFER on 9/12/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GADeviceInfo.h"
#import <UIKit/UIKit.h>

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation GADeviceInfo


+(NSString*)appID {
    
    return NSBundle.mainBundle.infoDictionary[@"CFBundleIdentifier"];
}

+(NSString*)appName {
    
    return NSBundle.mainBundle.infoDictionary[@"CFBundleDisplayName"];
}

+(NSString*)deviceID {
    
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+(NSString*)deviceType {
    
    return [UIDevice currentDevice].model;
}

+(NSString*)deviceOS {
    
    return [NSString stringWithFormat:@"%@ %@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];
}

+(NSString*)deviceCarrier {
    
    CTTelephonyNetworkInfo *phoneInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *phoneCarrier = [phoneInfo subscriberCellularProvider];
    
    if ([phoneCarrier carrierName]) {
        
        return [phoneCarrier carrierName];
    
    } else {
        
        return @"<Carrier Not Availble>";
    }
}

+(NSString*)deviceLocale {
    
    return [[NSLocale currentLocale] localeIdentifier];
}

+(NSString*)ipAddress {
    // http://stackoverflow.com/questions/7072989/iphone-ipad-how-to-get-my-ip-address-programmatically
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+(void)test {
    
    NSLog(@"appId: %@",[GADeviceInfo appID]);
    NSLog(@"appName: %@",[GADeviceInfo appName]);
    NSLog(@"deviceId: %@",[GADeviceInfo deviceID]);
    NSLog(@"deviceType: %@",[GADeviceInfo deviceType]);
    NSLog(@"deviceOS: %@",[GADeviceInfo deviceOS]);
    NSLog(@"deviceCarrier: %@",[GADeviceInfo deviceCarrier]);
    NSLog(@"deviceLocale: %@",[GADeviceInfo deviceLocale]);
    NSLog(@"ipAddress: %@",[GADeviceInfo ipAddress]);

}
@end
