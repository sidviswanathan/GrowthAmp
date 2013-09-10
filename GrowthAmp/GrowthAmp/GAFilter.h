//
//  GAFilter.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/4/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GAFilter : NSObject

- (void)filterContacts:(NSArray *)contacts usingFilters:(NSArray *)filters completion:(void(^)(NSArray *, NSError *))completion;

@end
