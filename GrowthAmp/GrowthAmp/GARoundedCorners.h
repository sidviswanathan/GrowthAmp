//
//  GARoundedCorners.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/2/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GAConstants.h"

@interface GARoundedCorners : NSObject

+ (UIImage *)imageForPositionMask:(GACellPosition)mask isDown:(BOOL)isDown isBlue:(BOOL)isBlue;

@end
