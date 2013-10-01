//
//  UIColor+HexString.h
//  GrowthAmp
//
//  Created by DON SHEFER on 10/1/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)

+ (UIColor *) colorWithHexString: (NSString *) hexString;
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;

@end
