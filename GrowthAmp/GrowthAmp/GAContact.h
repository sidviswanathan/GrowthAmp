//
//  GAContact.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GAContact : NSObject

@property (nonatomic) NSInteger identifier;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *jobTitle;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) NSDate *dateModified;
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, strong) NSArray *sites;
@property (nonatomic, strong) NSArray *emails;
@property (nonatomic, strong) NSArray *phoneNumbers;
@property (nonatomic, strong) NSArray *addresses;
@property (nonatomic, strong) NSArray *socialProfiles;
@property (nonatomic, strong) NSData *imageData;

- (NSDictionary*)dictionary;

@end
