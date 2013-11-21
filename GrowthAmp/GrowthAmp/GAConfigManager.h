//
//  GAConfig.h
//  GrowthAmp
//
//  Created by Don Shefer on 9/17/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GAConfigManager : NSObject

@property (nonatomic,assign) BOOL isAutoLaunchEnabled;
@property (nonatomic,assign) NSInteger appLaunchedUntil1stAutoLaunch;
@property (nonatomic,assign) NSInteger daysUntil2ndAutoLaunch;

@property (nonatomic,assign) BOOL selectAllEnabled;
@property (nonatomic,assign) NSInteger maxNumberOfContacts;

@property (nonatomic,strong) NSDictionary *configDictionary;


+ (id)sharedInstance;
-(void)loadConfig;
-(UIImage*)imageForConfigKey:(NSString*)key default:(NSString*)defaultStr;
-(NSString*)stringForConfigKey:(NSString*)key default:(NSString*)defaultStr;
-(UIColor*)colorForConfigKey:(NSString*)key default:(NSString*)defaultStr;
-(float)floatForConfigKey:(NSString*)key default:(NSString*)defaultStr;
-(BOOL)boolForConfigKey:(NSString*)key default:(NSString*)defaultStr;

@end
