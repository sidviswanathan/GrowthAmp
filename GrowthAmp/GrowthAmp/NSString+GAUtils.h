//
//  NSString+GAUtils.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/3/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GAUtils)

+ (NSString *)i18nWithFormatString:(NSString *)formatString andData:(NSDictionary *)data;

@end
