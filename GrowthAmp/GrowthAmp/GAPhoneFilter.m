//
//  GAPhoneFilter.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/4/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAPhoneFilter.h"
#import "GAContact.h"

@implementation GAPhoneFilter

- (BOOL)shouldIncludeContact:(GAContact *)contact {
    if (!contact.phoneNumbers.count) {
        return NO;
    }
    return YES;
}

@end
