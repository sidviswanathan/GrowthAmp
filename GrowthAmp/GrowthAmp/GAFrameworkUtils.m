//
//  GAUtils.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/11/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAFrameworkUtils.h"

@implementation GAFrameworkUtils

+ (NSBundle *)frameworkBundle {
    static NSBundle* frameworkBundle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
        NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:@"GrowthAmpResources.bundle"];
        frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
    });
    return frameworkBundle;
}

+ (NSString *)localizedStringFromFrameworkBundleForKey:(NSString*)key andComment:(NSString*)comment {
    static NSBundle* bundle = nil;
    if (!bundle)
    {
        NSBundle *libraryBundle = [self frameworkBundle];
        NSString *langID        = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *path          = [libraryBundle pathForResource:langID ofType:@"lproj"];
        bundle                  = [NSBundle bundleWithPath:path];
    }
    return [bundle localizedStringForKey:key value:@"" table:nil];
}

@end
