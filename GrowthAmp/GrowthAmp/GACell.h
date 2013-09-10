//
//  GACell.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/2/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GACell : UITableViewCell

@property (nonatomic) NSUInteger cellPosition;

+ (CGFloat)height;
+ (NSString *)reuseIdentifier;
+ (CGFloat)leftMargin;
+ (CGFloat)rightMargin;

- (NSArray *)contentFrames;

@end
