//
//  GAFilterProtocol.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/4/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GAContact;

@protocol GAFilterProtocol <NSObject>

- (BOOL)shouldIncludeContact:(GAContact *)contact;

@end
