//
//  GARoundedCorners.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/2/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GARoundedCorners.h"

@implementation GARoundedCorners

+ (UIImage *)imageForPositionMask:(GACellPosition)mask isDown:(BOOL)isDown isBlue:(BOOL)isBlue {
    NSString *formatString = nil;
    if ((mask & GACellPositionTop) && (mask & GACellPositionBottom)) {
        formatString = @"container%@_full%@";
    }
    else if (mask & GACellPositionTop) {
        formatString = @"container%@_top%@";
    }
    else if (mask & GACellPositionBottom) {
        formatString = @"container%@_bottom%@";
    }
    else {
        formatString = @"container%@_center%@";
    }
    
    NSString *imageName = [NSString stringWithFormat:formatString, (isDown ? @"_down" : @""), (isBlue ? @"_blue" : @"")];
    UIImage *cornerImage = GAImage(imageName);
    CGSize size = cornerImage.size;
    int left = floorf(size.width / 2) - 1;
    int top = floorf(size.height / 2) - 1;
    UIImage *stretch = [cornerImage resizableImageWithCapInsets:
                        UIEdgeInsetsMake(top, left, size.height-top-1, size.width-left-1)];
    
    return stretch;
}
 
+ (UIImage *)stretchableWhiteBackgroundViewForCellPosition:(GACellPosition)mask {
    return [self imageForPositionMask:mask isDown:NO isBlue:NO];
}

+ (UIImage *)stretchableWhitePressedBackgroundViewForCellPosition:(GACellPosition)mask {
    return [self imageForPositionMask:mask isDown:YES isBlue:NO];
}

+ (UIImage *)stretchableBlueBackgroundViewForCellPosition:(GACellPosition)mask {
    return [self imageForPositionMask:mask isDown:NO isBlue:YES];
}

+ (UIImage *)stretchableBluePressedBackgroundViewForCellPosition:(GACellPosition)mask {
    return [self imageForPositionMask:mask isDown:YES isBlue:YES];
}

@end
