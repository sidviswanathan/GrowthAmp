//
//  GAContactsCache.h
//  GrowthAmp
//
//  Created by Don Shefer on 11/21/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GAContactsCache : NSObject

@property (nonatomic,copy) NSArray *contacts;

+ (id)sharedCache;

- (void)invalidate;
- (void)contactsWithCompletion:(void(^)(NSArray *, NSError*))completion;

@end

