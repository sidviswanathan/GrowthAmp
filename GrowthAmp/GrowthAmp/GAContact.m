//
//  GAContact.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAContact.h"
#import "GASite.h"
#import "GAPhoneNumber.h"
#import "GAAddress.h"
#import "GASocialProfile.h"

@implementation GAContact

- (BOOL)isEqual:(id)other {
    if ([other isKindOfClass:[self class]] ) {
        return self.identifier == ((GAContact *)other).identifier;
    }
    return NO;
}

- (NSUInteger)hash {
    return self.identifier;
}


- (NSDictionary*)dictionary {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:@{ @"identifier" : @(self.identifier) } ];
    
    if (self.firstName) { [result setObject:self.firstName forKey:@"firstName"]; }
    if (self.middleName) { [result setObject:self.middleName forKey:@"middleName"]; }
    if (self.lastName) { [result setObject:self.lastName forKey:@"lastName"]; }
    if (self.jobTitle) { [result setObject:self.jobTitle forKey:@"jobTitle"]; }
    if (self.companyName) { [result setObject:self.companyName forKey:@"companyName"]; }
    if (self.note) { [result setObject:self.note forKey:@"note"]; }
    if (self.birthday) { [result setObject:self.birthday forKey:@"birthday"]; }
    if (self.dateModified) { [result setObject:self.dateModified forKey:@"dateModified"]; }
    if (self.dateCreated) { [result setObject:self.dateCreated forKey:@"dateCreated"]; }
    if (self.emails) { [result setObject:self.emails forKey:@"emails"]; }
    
    if (self.sites) {
        NSMutableArray *sitesArr = [NSMutableArray array];
        for (GASite *obj in self.sites) {
            
            [sitesArr addObject:[obj dictionaryWithValuesForKeys:@[@"label",@"url"]]];
        }
        [result setObject:sitesArr forKey:@"sites"];
    }
    
    if (self.phoneNumbers) {
        NSMutableArray *phoneNumbersArr = [NSMutableArray array];
        for (GAPhoneNumber *obj in self.phoneNumbers) {
            
            [phoneNumbersArr addObject:[obj dictionaryWithValuesForKeys:@[@"label",@"number"]]];
        }
        [result setObject:phoneNumbersArr forKey:@"phoneNumbers"];
    }

    if (self.addresses) {
        NSMutableArray *addressesArr = [NSMutableArray array];
        for (GAAddress *obj in self.addresses) {
            
            [addressesArr addObject:[obj dictionaryWithValuesForKeys:@[@"street",@"city",@"state",@"zip",@"country",@"type"]]];
        }
        [result setObject:addressesArr forKey:@"addresses"];
    }
    
    if (self.socialProfiles) {
        NSMutableArray *socialProfilesArr = [NSMutableArray array];
        for (GASocialProfile *obj in self.socialProfiles) {
            
            [socialProfilesArr addObject:@{@"service" : obj.service,
                                           @"url"     : obj.url
                                           }];
        }
        [result setObject:socialProfilesArr forKey:@"socialProfiles"];
    }
    
    return result;
}

@end
