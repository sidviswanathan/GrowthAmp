//
//  GAContactCell.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/2/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAContactCell.h"
#import "GAContact.h"
#import "GAPhoneNumber.h"
#import <QuartzCore/QuartzCore.h>
#import "GAConfigManager.h"

@interface GAContactCell()

@property (nonatomic, strong) UIImageView *checkmarkImageView;

@end

@implementation GAContactCell

@synthesize contact = _contact;
@synthesize checked = _checked;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *image = [[GAConfigManager sharedInstance] imageForConfigKey:@"checkMarkImageName" default:@"Checkmark"];
        self.checkmarkImageView = [[UIImageView alloc] initWithImage:image];
        
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        [self.contentView addSubview:self.checkmarkImageView];
        
        self.textLabel.font = [[self class] fontForTitle];
        self.detailTextLabel.font = [[self class] fontForSubtitle];
    }
    return self;
}

+ (CGFloat)height {
    return 60;
}

+ (UIFont*)fontForTitle {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
}

+ (UIFont*)fontForSubtitle {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.checkmarkImageView.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSArray *frame = [self contentFrames];
    self.imageView.frame = [frame[0] CGRectValue];
    self.textLabel.frame = [frame[1] CGRectValue];
    self.detailTextLabel.frame = [frame[2] CGRectValue];
    self.checkmarkImageView.frame = [frame[3] CGRectValue];
}

- (NSArray *)contentFrames {
    CGFloat cellWidth = CGRectGetWidth(self.contentView.frame);
    CGFloat cellHeight = [[self class] height];
    
    // Image
    const CGFloat padding = 10;
    CGFloat height = cellHeight - (padding*2);
    CGRect imageFrame = CGRectMake(padding, padding, height, height);
    
    // Checkmark
    CGRect checkmarkFrame = CGRectZero;
    CGFloat offset = 0;
    if (self.checked) {
        UIImage *image = [[GAConfigManager sharedInstance] imageForConfigKey:@"checkMarkImageName" default:@"Checkmark"];
        CGSize size = image.size;
        checkmarkFrame = CGRectMake(cellWidth - size.width - 25, cellHeight/2 - size.height/2, size.width, size.height);
        offset = checkmarkFrame.size.width;
    }
    
    // Name
    CGRect textFrame = self.textLabel.frame;
    CGRect detailsFrame = self.detailTextLabel.frame;
    if (self.contact.imageData) {
        CGFloat left = imageFrame.origin.x + imageFrame.size.width + padding;
        textFrame.origin.x = left;
        textFrame.size.width = cellWidth - left - [[self class] rightMargin];
        detailsFrame.origin.x = textFrame.origin.x;
        detailsFrame.size.width = textFrame.size.width;
    } else {
        textFrame.size.width = cellWidth - [[self class] rightMargin] - [[self class] leftMargin];
        detailsFrame.size.width = textFrame.size.width;
    }

    textFrame.size.width -= offset;
    detailsFrame.size.width -= offset;

    return @[[NSValue valueWithCGRect:imageFrame],
             [NSValue valueWithCGRect:textFrame],
             [NSValue valueWithCGRect:detailsFrame],
             [NSValue valueWithCGRect:checkmarkFrame]];
}

- (void)setChecked:(BOOL)checked {
    _checked = checked;
}

- (void)setContact:(GAContact *)contact {
    _contact = contact;
    
    NSMutableArray *names = [[NSMutableArray alloc] init];
    if (contact.firstName) {
        [names addObject:contact.firstName];
    }
    if (contact.lastName) {
        [names addObject:contact.lastName];
    }
    self.textLabel.text = [names componentsJoinedByString:@" "];
    self.detailTextLabel.text = ((GAPhoneNumber *)contact.phoneNumbers[0]).number;
    
    if (contact.imageData) {
        self.imageView.image = [UIImage imageWithData:contact.imageData];
        
        CALayer *l = [self.imageView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:5];
        
        // You can even add a border
        //[l setBorderWidth:4.0];
        //[l setBorderColor:[[UIColor whiteColor] CGColor]];
    }
    
    if (self.checked) {
        self.checkmarkImageView.hidden = NO;
    }
}

@end

