//
//  GAHeaderCell.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/3/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAHeaderCell.h"
#import "GAConfigManager.h"

@interface GAHeaderCell()

@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation GAHeaderCell

@synthesize model = _model;
@synthesize status = _status;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        
        self.textLabel.font = [[self class] fontForTitle];
        self.textLabel.numberOfLines = [[self class] numberOfLinesForTitle];
        
        self.detailTextLabel.font = [[self class] fontForSubtitle];
        
        _status = GAHeaderCellStatusSelectAll;
        
        [self setupSelectButton];
    }
    return self;
}

+ (CGFloat)height {
    return 50;
}

+ (UIFont*)fontForTitle {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
}

+ (UIFont*)fontForSubtitle {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSArray *frame = [self contentFrames];
    self.selectButton.frame = [frame[0] CGRectValue];
    self.textLabel.frame = [frame[1] CGRectValue];
    
    CGRect detailTitleFrame = self.detailTextLabel.frame;
    detailTitleFrame.origin.x = self.textLabel.frame.origin.x;
    self.detailTextLabel.frame = detailTitleFrame;
}

- (void)setupSelectButton {
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];

    //UIImage *image = [[GAConfigManager sharedInstance] imageForConfigKey:@"selectButtonImageName" default:@"Select"];
    
    //image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    
    NSString *text = [self textForButton];
    
    //[self.selectButton setBackgroundImage:image forState:UIControlStateNormal];
    self.selectButton.backgroundColor = [UIColor lightGrayColor];
    [self.selectButton setTitle:text forState:UIControlStateNormal];
    [self.selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    self.selectButton.titleLabel.font = font;
    [self.selectButton addTarget:self action:@selector(didTapOnSelectButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.selectButton];
}

- (NSString *)textForButton {
    switch (self.status) {
        case GAHeaderCellStatusSelectAll:
            return GALocalizedString(@"select_all", nil);
            break;
        case GAHeaderCellStatusUnselectAll:
            return GALocalizedString(@"unselect_all", nil);
            break;
        default:
            break;
    }
}

- (NSArray *)contentFrames {
    CGFloat cellWidth = CGRectGetWidth(self.contentView.frame);
    
    // Button frame
    NSString *text = [self textForButton];
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(100, font.lineHeight) lineBreakMode:NSLineBreakByTruncatingTail];
    
    const int padding = 10;
    const int buttonFrameWidth = 68.0;
    CGRect buttonFrame = CGRectMake(cellWidth - (buttonFrameWidth + (padding * 2)), 0, buttonFrameWidth + (padding * 2), [[self class] height]);

    // Title frames
    text = self.model.headerTitle;
    font = [[self class] fontForTitle];
    CGFloat remainingWidth = buttonFrame.origin.x - 5*2;
    size = [text sizeWithFont:font constrainedToSize:CGSizeMake(remainingWidth - 5, font.lineHeight * [[self class] numberOfLinesForTitle]) lineBreakMode:NSLineBreakByTruncatingTail];
    //CGRect titleFrame = CGRectMake(10, 5, size.width, size.height);
    CGRect titleFrame = CGRectMake(10, 5, size.width, size.height);
    
    
    // Subtitle frame
    CGRect subtitleFrame = CGRectNull;
    
    return @[[NSValue valueWithCGRect:buttonFrame],
             [NSValue valueWithCGRect:titleFrame],
             [NSValue valueWithCGRect:subtitleFrame]];
}

+ (NSInteger)numberOfLinesForTitle {
    return 1;
}

- (void)setModel:(GAHeaderModel *)model {
    _model = model;
    
    self.textLabel.text = model.headerTitle;
    self.detailTextLabel.attributedText = model.headerSubTitle;
    [self.selectButton setTitle:[self textForButton] forState:UIControlStateNormal];
}

- (void)setStatus:(GAHeaderCellStatus)status {
    _status = status;
    //[self.selectButton setTitle:[self textForButton] forState:UIControlStateNormal];
    //[self layoutSubviews];
}

- (void)didTapOnSelectButton {
    
    if (!self.status) {

        [[GATrackingManager sharedManager] reportUserActionWithName:kTrackingKeyActionContactsSelectAll
                                                               type:kTrackingKeyTypeAction
                                                               info:nil];
    } else {
        
        [[GATrackingManager sharedManager] reportUserActionWithName:kTrackingKeyActionContactsUnselectAll
                                                               type:kTrackingKeyTypeAction
                                                               info:nil];
    }
    
    
    self.status = !self.status;
    [self.delegate headerCell:self didChangeWithSelectStatus:self.status];
}

@end

@implementation GAHeaderModel

@end