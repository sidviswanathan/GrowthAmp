//
//  NSDictionary+JSONCategories.m
//  GrowthAmp
//
//  Created by DON SHEFER on 9/11/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "NSDictionary+JSONCategories.h"

@implementation NSDictionary (JSONCategories)

+(NSDictionary*)dictionaryWithNameOfJSONFile:(NSString*)fileName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions error:&error];
    // Be careful here. You add this as a category to NSDictionary
    // but you get an id back, which means that result
    // might be an NSArray as well!
    if (error != nil) return nil;
    return result;
}

@end
