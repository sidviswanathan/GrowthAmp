//
//  GAImport.m
//  GrowthAmp
//
//  Created by DON SHEFER on 10/8/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAImport.h"
#import "GASampleDataImport.h"
#import "GAABImport.h"
#import "GAConfigManager.h"
#import "GAContactsCache.h"

#define kSampleDataThreshold 10

@implementation GAImport

+ (void)contactsWithCompletion:(void(^)(NSArray *, NSError*))completion {
    
    // If cache exists, use it
    if ([[GAContactsCache sharedCache] contacts]) {
        
        [[GAContactsCache sharedCache] contactsWithCompletion:completion];
        return;
    }
    
    BOOL useSampleData = [[[GAConfigManager sharedInstance] stringForConfigKey:@"useSampleData" default:@"YES"] boolValue];
    
#ifdef CONFIGURATION_Release
    // If this is a realease build, override configuration and don't show sample data
    useSampleData = NO;
#endif
    
    if (useSampleData) {
        
        [GAABImport contactsWithCompletion:^(NSArray *contacts, NSError *error) {

            if (contacts.count < kSampleDataThreshold) {

                [[GAContactsCache sharedCache] invalidate];
                [GASampleDataImport contactsWithCompletion:completion];
            
            } else {
                
                // Already fetched, use cache
                 [[GAContactsCache sharedCache] contactsWithCompletion:completion];
            }
            
        }];


        
    } else {
        
        [GAABImport contactsWithCompletion:completion];
    }
}

@end
