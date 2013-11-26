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
#import "UIColor+HexString.h"
#import "GALoader.h"

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
    
    if( kSystemVersion >= 7 ) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.nextButton.hidden = YES;
    
    [self setupBackground];   
    [self setupContinueButton];
    [self setupContent];
    
    
    [[GATrackingManager sharedManager] reportUserActionWithName:kTrackingKeyPageSplash
                                                           type:kTrackingKeyTypeFull
                                                           info:nil];
}

- (void)setupBackground {
    
    UIImage *BGImage = [[GAConfigManager sharedInstance] imageForConfigKey:@"splashImageName" default:@"splash_background"];
    UIImageView *BGImageView = [[UIImageView alloc] initWithImage:BGImage];
    BGImageView.frame = self.view.frame;
    [self.view addSubview:BGImageView];
    
    //    self.view.layer.contents = (id)[[GAConfigManager sharedInstance] imageForConfigKey:@"splashImageName" default:@"splash_background"].CGImage;
}

- (void)setupContinueButton {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    self.continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *image = [[GAConfigManager sharedInstance] imageForConfigKey:@"splashContinueButtonImageName" default:@"Continue"];
    
    NSString *text = GALocalizedString(@"continue", nil);
    
    [self.continueButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.continueButton setTitle:text forState:UIControlStateNormal];
    
    UIColor *continueTextColor = [[GAConfigManager sharedInstance] colorForConfigKey:@"splashContinueButtonTextColor" default:@"#FFFFFF"];
    
    [self.continueButton setTitleColor:continueTextColor forState:UIControlStateNormal];
    
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
    float titleFontSize = [[GAConfigManager sharedInstance] floatForConfigKey:@"splashTitleTextSize" default:@"22"];
    titleLabel.font = [UIFont boldSystemFontOfSize:titleFontSize];
    UIColor *textColor = [[GAConfigManager sharedInstance] colorForConfigKey:@"splashTextColor" default:@"#00FFFF"];
    titleLabel.textColor = textColor;
    //titleLabel.backgroundColor = [UIColor blueColor];

    [self.view addSubview:titleLabel];
    
    UILabel *bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width*textInsetWidth,screenSize.height*0.58,screenSize.width*(1-textInsetWidth*2),screenSize.height*0.2)];
    bodyLabel.text = [[GAConfigManager sharedInstance] stringForConfigKey:@"splashBodyText" default:@"Invite your friends."];
    bodyLabel.textAlignment = NSTextAlignmentCenter;
    float bodyFontSize = [[GAConfigManager sharedInstance] floatForConfigKey:@"splashBodyTextSize" default:@"16"];
    bodyLabel.font = [UIFont systemFontOfSize:bodyFontSize];
    bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    bodyLabel.numberOfLines = 0;
    bodyLabel.textColor = textColor;
    //bodyLabel.backgroundColor = [UIColor blueColor];
    [bodyLabel sizeToFit];
    
    [self.view addSubview:bodyLabel];
    
    
}
#pragma mark - Navigation buttons
- (void)didTapOnCloseButton {
    
    [[GATrackingManager sharedManager] reportUserActionWithName:kTrackingKeyActionSplashX
                                                           type:kTrackingKeyTypeAction
                                                           info:nil];
    
    [super didTapOnCloseButton];
}
- (void)didTapOnContinueButton {
    
    [[GATrackingManager sharedManager] reportUserActionWithName:kTrackingKeyActionSplashContinue
                                                           type:kTrackingKeyTypeAction
                                                           info:nil];
    
    [[GALoader sharedInstance] presentInvitationsFromController:self.navigationController];

}

@end
