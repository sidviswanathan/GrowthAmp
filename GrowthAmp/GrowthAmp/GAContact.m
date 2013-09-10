//
//  GAContact.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAContact.h"

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

@end
