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


#define kSampleDataThreshold 10

@implementation GAImport

+ (void)contactsWithCompletion:(void(^)(NSArray *, NSError*))completion {
    
    BOOL useSampleData = [[[GAConfigManager sharedInstance] stringForConfigKey:@"useSampleData" default:@"YES"] boolValue];
    
#ifdef CONFIGURATION_Release
    useSampleData = NO;
#endif
    
    if (useSampleData) {
        
        [GAABImport contactsWithCompletion:^(NSArray *contacts, NSError *error) {

            if (contacts.count < kSampleDataThreshold) {

                [GASampleDataImport contactsWithCompletion:completion];
            
            } else {
                
                [GAABImport contactsWithCompletion:completion];
            }
            
        }];


        
    } else {
        
        [GAABImport contactsWithCompletion:completion];
    }
}

@end
