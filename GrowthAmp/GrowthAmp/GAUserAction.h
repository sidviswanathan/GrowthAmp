//
//  GAUserAction.h
//  GrowthAmp
//
//  Created by DON SHEFER on 10/24/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GAUserAction : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,retain) NSString *actionType;
@property (nonatomic,retain) NSDate *timestamp;
@property (nonatomic,retain) NSDictionary *trackingInfo;

-(id) initWithName:(NSString *)name;

@end
