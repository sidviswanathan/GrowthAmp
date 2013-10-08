//
//  GAImport.h
//  GrowthAmp
//
//  Created by DON SHEFER on 10/8/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GAImport : NSObject

+ (void)contactsWithCompletion:(void(^)(NSArray *, NSError*))completion;

@end
