//
//  GAABImport.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GAABImport : NSObject

+ (void)contactsWithCompletion:(void(^)(NSArray *, NSError*))completion;

@end