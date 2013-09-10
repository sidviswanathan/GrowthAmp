//
//  GAFilter.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/4/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAFilter.h"
#import "GAContact.h"
#import "GAFilterProtocol.h"

@implementation GAFilter

+ (dispatch_queue_t)queue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.growthamp.filter.queue", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

- (void)filterContacts:(NSArray *)contacts usingFilters:(NSArray *)filters completion:(void(^)(NSArray *, NSError *))completion {
    dispatch_async([[self class] queue], ^{
        
        NSMutableArray *filteredContacts = [[NSMutableArray alloc] init];
        
        for (Class filterClass in filters) {
            NSObject<GAFilterProtocol> *filter = [[filterClass alloc] init];
            
            for (GAContact *contact in contacts) {
                if ([filter shouldIncludeContact:contact]) {
                    [filteredContacts addObject:contact];
                }
            }
        }
        
        completion(filteredContacts, nil);
    });
}

@end
