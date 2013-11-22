//
//  GAContactsCache.m
//  GrowthAmp
//
//  Created by Don Shefer on 11/21/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAContactsCache.h"

@implementation GAContactsCache

+ (id)sharedCache
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

-(void) invalidate {
    
    self.contacts = nil;
}


- (void)contactsWithCompletion:(void(^)(NSArray *, NSError*))completion {
    
    completion(self.contacts, nil);
    
}


@end
