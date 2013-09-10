//
//  NSString+GAUtils.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/3/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "NSString+GAUtils.h"

@implementation NSString (GAUtils)

+ (NSString *)i18nWithFormatString:(NSString *)formatString andData:(NSDictionary *)data {
    NSString *newString = [formatString copy];
    
    for (NSString *key in data) {
        NSString *keyStr = [NSString stringWithFormat:@"{%@}", key];
        NSString *dataStr = [NSString stringWithFormat:@"%@", data[key]];
        newString = [newString stringByReplacingOccurrencesOfString:keyStr withString:dataStr];
    }
    
    return newString;
}


@end
