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
#import "GAConfigManager.h"

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
    UIImage *image = [[GAConfigManager sharedInstance] imageForConfigKey:@"splashImageName" default:@"splash_background"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)setupContinueButton {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    self.continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *image = [[GAConfigManager sharedInstance] imageForConfigKey:@"continueButtonImageName" default:@"Continue"];
    
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

#define textInsetWidth 0.1

- (void)setupContent {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,screenSize.height*0.5,screenSize.width,36)];
    titleLabel.text = [[GAConfigManager sharedInstance] stringForConfigKey:@"splashTitleText" default:@"Spread the Love!"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = [UIColor whiteColor];
    //titleLabel.backgroundColor = [UIColor blueColor];

    [self.view addSubview:titleLabel];
    
    UILabel *bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width*textInsetWidth,screenSize.height*0.58,screenSize.width*(1-textInsetWidth*2),screenSize.height*0.2)];
    bodyLabel.text = [[GAConfigManager sharedInstance] stringForConfigKey:@"splashBodyText" default:@"Invite your friends."];
    bodyLabel.textAlignment = NSTextAlignmentCenter;
    bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    bodyLabel.numberOfLines = 0;
    bodyLabel.font = [UIFont systemFontOfSize:16];
    bodyLabel.textColor = [UIColor whiteColor];
    //bodyLabel.backgroundColor = [UIColor blueColor];
    [bodyLabel sizeToFit];
    
    [self.view addSubview:bodyLabel];
    
    
}

- (void)didTapOnContinueButton {
    [self.delegate mainViewController:self didTapOnContinueButton:self.continueButton];
}

@end
