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
        
        self.sdkVersion = [self.configDictionary objectForKey:@"sdkVersion"];
        
        self.isAutoLaunchEnabled = [[self.configDictionary valueForKey:@"isAutoLaunchEnabled"] boolValue];
        self.appLaunchedUntil1stAutoLaunch = [[self.configDictionary valueForKey:@"appLaunchedUntil1stAutoLaunch"] integerValue];
        self.daysUntil2ndAutoLaunch = [[self.configDictionary valueForKey:@"daysUntil2ndAutoLaunch"] integerValue];
        
        self.selectAllEnabled = [[self.configDictionary valueForKey:@"selectAllEnabled"] integerValue];
        self.maxNumberOfContacts = [[self.configDictionary valueForKey:@"maxNumberOfContacts"] integerValue];
        
        self.apiPostURL = [self.configDictionary objectForKey:@"apiPostURL"];
        self.trackingPostURL = [self.configDictionary objectForKey:@"trackingPostURL"];
        self.userPostURL = [self.configDictionary objectForKey:@"userPostURL"];
        self.sessionPostURL = [self.configDictionary objectForKey:@"sessionPostURL"];
        
        
    } else {
        
        NSLog(@"GAConfig.json appears to be missing from the project. Using defaults");
        
        self.sdkVersion = @"1.0";
        
        // Default configuration values
        self.isAutoLaunchEnabled = NO;
        self.appLaunchedUntil1stAutoLaunch = 3;
        self.daysUntil2ndAutoLaunch = 30;
        
        self.selectAllEnabled = YES;
        self.maxNumberOfContacts = 10;
        
    }
}

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

@end
