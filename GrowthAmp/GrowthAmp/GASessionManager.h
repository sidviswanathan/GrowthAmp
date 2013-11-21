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

+ (id)sharedManager;

-(void)startSession;
-(void)endSession;

@end
