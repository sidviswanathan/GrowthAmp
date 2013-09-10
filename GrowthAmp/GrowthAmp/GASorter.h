//
//  GASorter.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GASorter : NSObject

- (void)sortContacts:(NSArray *)contacts completion:(void(^)(NSArray *, NSError *))completion;

@end
