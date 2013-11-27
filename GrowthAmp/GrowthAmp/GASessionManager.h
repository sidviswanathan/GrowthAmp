//
//  GASessionManager.h
//  GrowthAmp
//
//  Created by Don Shefer on 11/4/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GASessionManager : NSObject

@property (nonatomic, strong) NSString *sessionType;
@property (nonatomic, strong) NSDictionary *userContact;
@property (nonatomic,assign) int numContacts;
@property (nonatomic,retain) NSString *sessionID;

+ (id)sharedManager;

-(void)startSessionOfType:(NSString*)sessionType;
-(void)endSession;

@end

