//
//  GAUtils.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/11/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GAFrameworkUtils : NSObject

+ (NSBundle *)frameworkBundle;
+ (NSString *)localizedStringFromFrameworkBundleForKey:(NSString*)key andComment:(NSString*)comment;

@end

#define GALocalizedString(key, comment) \
    [GAFrameworkUtils localizedStringFromFrameworkBundleForKey:key andComment:comment]

#define GALocalizedFormattedString(key, data) \
    [NSString i18nWithFormatString:GALocalizedString(key, nil) andData:data];

#define GAImage(name) \
    [UIImage imageWithContentsOfFile:[[GAFrameworkUtils frameworkBundle] pathForResource:name ofType:@"png"]];