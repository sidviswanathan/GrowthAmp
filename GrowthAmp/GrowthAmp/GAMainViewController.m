//
//  GAMainViewController.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/11/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAMainViewController.h"
#import "GAABImport.h"
#import "GAInvitationsViewController.h"

@interface GAMainViewController ()

@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation GAMainViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nextButton.hidden = YES;
    
    [self setupBackground];   
    [self setupContinueButton];
    [self setupContent];
}

- (void)setupBackground {
    UIImage *image = GAImage(@"splash_background");
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)setupContinueButton {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    self.continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *image = GAImage(@"Continue");
        
    NSString *text = GALocalizedString(@"continue", nil);
    
    [self.continueButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.continueButton setTitle:text forState:UIControlStateNormal];
    [self.continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.continueButton.frame = CGRectMake(screenSize.width/2 - image.size.width/2, screenSize.height - image.size.height * 3, image.size.width, image.size.height);
    
    UIFont *font = [UIFont boldSystemFontOfSize:22];
    self.continueButton.titleLabel.font = font;
    
    self.continueButton.titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:.3];
    self.continueButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    
    [self.continueButton addTarget:self action:@selector(didTapOnContinueButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.continueButton];
}

- (void)setupContent {
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.text = @"Spread the Love!";
}

- (void)didTapOnContinueButton {
    [self.delegate mainViewController:self didTapOnContinueButton:self.continueButton];
}

@end
