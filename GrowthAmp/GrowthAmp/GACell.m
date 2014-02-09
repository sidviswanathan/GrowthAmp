//
//  GACell.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/2/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GACell.h"
#import "GARoundedCorners.h"

@interface GACell()

@property (nonatomic, strong) UIImageView *backgroundCornersView;
@property (nonatomic, strong) UIView *dividerView;

@end

@implementation GACell

@synthesize cellPosition = _cellPosition;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
        
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        
        // Background corners
        self.backgroundCornersView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.backgroundCornersView];

        // Separator
        self.dividerView = [[UIView alloc] init];
        self.dividerView.backgroundColor = [UIColor colorWithRed:205.0/255 green:205.0/255 blue:205.0/255 alpha:1];
        [self.contentView addSubview:self.dividerView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)prepareForReuse {
    self.dividerView.frame = CGRectMake(0, 0, 0, 0);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateContent];
    [self updateBackground];
}

- (void)updateContent {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    CGSize size;
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        size = CGSizeMake(screenSize.width, screenSize.height);
    } else {
        size = CGSizeMake(screenSize.height, screenSize.width);
    }
    
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.origin.x = 0;
    contentViewFrame.size.width = size.width;
    self.contentView.frame = contentViewFrame;
    
    if (self.cellPosition ^ GACellPositionBottom) {
        self.dividerView.frame = CGRectMake(0, [[self class] height] - 0.5, CGRectGetWidth(self.contentView.frame), 0.5);
    }
}

- (void)updateBackground {
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    self.backgroundCornersView.frame = CGRectMake(0, 0, width, [[self class] height]);
    //UIImage *corners = [GARoundedCorners imageForPositionMask:self.cellPosition isDown:NO isBlue:NO];
    self.backgroundCornersView.backgroundColor = [UIColor whiteColor];
}

- (NSArray *)contentFrames {
    return nil;
}

/*
 - (void)drawRect:(CGRect)rect {
 [super drawRect:rect];
 
 UIColor *color = [UIColor colorWithRed:205.0/255 green:205.0/255 blue:205.0/255 alpha:1];
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGContextSetStrokeColorWithColor(context, color.CGColor);
 // Draw them with a 2.0 stroke width so they are a bit more visible.
 CGContextSetLineWidth(context, 1.0);
 CGContextMoveToPoint(context, [[self class] leftMargin], 0); //start at this point
 CGContextAddLineToPoint(context, CGRectGetWidth(self.contentView.frame), 0); //draw to this point
 // and now draw the Path!
 CGContextStrokePath(context);
 }
 */

+ (CGFloat)height {
    return 44;
}

+ (CGFloat)leftMargin {
    return 15;
}

+ (CGFloat)rightMargin {
    return 15;
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}

- (void)setCellPosition:(NSUInteger)cellPosition {
    _cellPosition = cellPosition;
    [self setNeedsDisplay];
}

@end