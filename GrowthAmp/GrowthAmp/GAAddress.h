//
//  GAAddress.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GAAddress : NSObject

@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *type;

@end
