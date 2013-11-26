//
//  GAViewController.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/11/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAViewController.h"
#import "GAConfigManager.h"
#import "GASessionManager.h"

@interface GAViewController ()

@end

@implementation GAViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [[GAConfigManager sharedInstance] imageForConfigKey:@"navBarImageName" default:@"Header"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    NSString *imageName = [[GAConfigManager sharedInstance] stringForConfigKey:@"selectBGImageName" default:@""];
    NSString *colorName = [[GAConfigManager sharedInstance] stringForConfigKey:@"selectBGColor" default:@"#FFFFFF"];
    
    if (imageName.length) {
    
        self.view.backgroundColor = [UIColor colorWithPatternImage:[[GAConfigManager sharedInstance] imageForConfigKey:@"selectBGImageName" default:@""]];
    
    } else if (colorName.length) {
        
    
        self.view.backgroundColor = [[GAConfigManager sharedInstance] colorForConfigKey:@"selectBGColor" default:@"#FFFFFF"];
    
    } else {
        
        UIImage *image = GAImage(@"background");
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    
    [self setupCloseButton];
    [self setupNextButton];
}

#pragma mark -
#pragma mark Navigation Buttons

-(void)setupCloseButton {
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [[GAConfigManager sharedInstance] imageForConfigKey:@"cancelButtonImageName" default:@"x"];
    self.closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(5, 0, image.size.width, image.size.height);
    [self.closeButton addSubview:imageView];
    
    [self.closeButton addTarget:self action:@selector(didTapOnCloseButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.closeButton.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    
    UIBarButtonItem *barButonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
    self.navigationItem.leftBarButtonItem = barButonItem;
}

- (void)setupNextButton {
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *enabledBackgroundImage = [[GAConfigManager sharedInstance] imageForConfigKey:@"nextButtonImageName" default:@"next"];
    
    enabledBackgroundImage = [enabledBackgroundImage stretchableImageWithLeftCapWidth:enabledBackgroundImage.size.width/2 topCapHeight:enabledBackgroundImage.size.height/2];
    
    NSString *text = GALocalizedString(@"next", nil);
    
    [self.nextButton setBackgroundImage:enabledBackgroundImage forState:UIControlStateNormal];
    [self.nextButton setTitle:text forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    self.nextButton.titleLabel.font = font;
    self.nextButton.titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:.3];
    self.nextButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    [self.nextButton addTarget:self action:@selector(didTapOnNextButton) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(100, font.lineHeight) lineBreakMode:NSLineBreakByTruncatingTail];
    
    const int padding = 10;
    self.nextButton.frame = CGRectMake(0, 0, size.width + (padding * 2), 60/2);
    
    UIBarButtonItem *barButonItem = [[UIBarButtonItem alloc] initWithCustomView:self.nextButton];
    self.navigationItem.rightBarButtonItem = barButonItem;
}

- (void)didTapOnCloseButton {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    
    [[GASessionManager sharedManager] endSession];
    [[GATrackingManager sharedManager] sendTrackingDataToServer];
}

- (void)didTapOnNextButton {
}

@end
