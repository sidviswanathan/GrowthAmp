//
//  GAConfig.h
//  GrowthAmp
//
//  Created by Don Shefer on 9/17/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GAConfig : NSObject

@property (nonatomic,retain) NSString *sdkVersion;
@property (nonatomic,assign) BOOL isAutoLaunchEnabled;
@property (nonatomic,assign) NSInteger appLaunchedUntil1stAutoLaunch;
@property (nonatomic,assign) NSInteger daysUntil2ndAutoLaunch;

@property (nonatomic,assign) BOOL selectAllEnabled;
@property (nonatomic,assign) NSInteger maxNumberOfContacts;

@property (nonatomic,retain) NSString *apiPostURL;
@property (nonatomic,retain) NSString *trackingPostURL;
@property (nonatomic,retain) NSString *userPostURL;
@property (nonatomic,retain) NSString *sessionPostURL;
@property (nonatomic,retain) NSString *invitationURL;

@end
