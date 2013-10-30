//
//  GAConfig.m
//  GrowthAmp
//
//  Created by Don Shefer on 9/17/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAConfigManager.h"
#import <UIKit/UIKit.h>
#import "UIColor+HexString.h"
#import "GAAPIClient.h"
#import "GAUserPreferences.h"
#import "GADeviceInfo.h"

@implementation GAConfigManager

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

-(void)loadConfig {
    
    // Load GAConfig.json
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GAConfig" ofType:@"plist"];
    self.configDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    if (self.configDictionary) {
        
        self.isAutoLaunchEnabled = [[self.configDictionary valueForKey:@"isAutoLaunchEnabled"] boolValue];
        self.appLaunchedUntil1stAutoLaunch = [[self.configDictionary valueForKey:@"appLaunchedUntil1stAutoLaunch"] integerValue];
        self.daysUntil2ndAutoLaunch = [[self.configDictionary valueForKey:@"daysUntil2ndAutoLaunch"] integerValue];
        
        self.selectAllEnabled = [[self.configDictionary valueForKey:@"selectAllEnabled"] integerValue];
        self.maxNumberOfContacts = [[self.configDictionary valueForKey:@"maxNumberOfContacts"] integerValue];
        
    } else {
        
        NSLog(@"GAConfig.json appears to be missing from the project. Using defaults");
        
        // Default configuration values
        self.isAutoLaunchEnabled = NO;
        self.appLaunchedUntil1stAutoLaunch = 3;
        self.daysUntil2ndAutoLaunch = 30;
        
        self.selectAllEnabled = YES;
        self.maxNumberOfContacts = 10;
        
    }
}
#pragma mark - Accessor methods

-(UIImage*)imageForConfigKey:(NSString*)key default:(NSString*)defaultStr {
    
    NSString *imageName = [self.configDictionary objectForKey:key];
    
    UIImage *result = [UIImage imageNamed:imageName];
    
    if (!result) {
        
        result = GAImage(defaultStr);
    }
    
    return result;
}

-(NSString*)stringForConfigKey:(NSString*)key default:(NSString*)defaultStr {
    
    NSString *result = [self.configDictionary objectForKey:key];
    
    if (!result) {
        
        result = defaultStr;
    }
    
    return result;
}

-(UIColor*)colorForConfigKey:(NSString*)key default:(NSString*)defaultStr {
    
    NSString *colorStr = [self.configDictionary objectForKey:key];
    
    if (colorStr && (colorStr.length > 0)) {
        
        return [UIColor colorWithHexString:colorStr];
    }
    
    return [UIColor colorWithHexString:defaultStr];
}

-(float)floatForConfigKey:(NSString*)key default:(NSString*)defaultStr {
    
    NSString *floatStr = [self.configDictionary objectForKey:key];
    
    if (floatStr && (floatStr.length > 0)) {
        
        return [floatStr floatValue];
    }
    
    return [defaultStr floatValue];
}

#pragma mark - Server
-(void)fetchSettings {
    
    // GET /settings example
    //     www.growthamp.com/settings/1?secret=529720bd2ea1cd
    //     http://www.growthamp.com/settings/?secret=529720bd2ea1cd
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"secret" : [[GAConfigManager sharedInstance] stringForConfigKey:@"secret" default:@""],
                                     @"app_id" : [GADeviceInfo appID],
                                     @"app_name" : [GADeviceInfo appName],
                                     }];

    [[GAAPIClient sharedClient] POST:kSettingsEndPoint parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           NSLog(@"JSON: %@", responseObject);
           
           [GAUserPreferences setObjectOfTypeKey:kCustomerIDKey object:responseObject[@"details"][@"customer_id"]];
           [self updateSettingsFromServer:responseObject];
           
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"Error: %@", error);
           
       }];
}

-(void)updateSettingsFromServer:(NSDictionary*)settingsDict {
    
    for (NSString *key in settingsDict) {
        
        // update settings
    }
    
}


@end
