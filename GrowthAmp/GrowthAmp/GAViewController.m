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

    /*
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
    */
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:58.0f/255.0f green:125.0f/255.0f blue:3.0f/255.0f alpha:1.0f]];
//    self.view.backgroundColor = [UIColor whiteColor];

    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:58.0f/255.0f green:125.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
        self.navigationController.navigationBar.translucent = NO;
        self.view.backgroundColor = [UIColor whiteColor];
    }else {
        self.navigationController.navigationBar.tintColor = [UIColor redColor];
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
    //UIImage *enabledBackgroundImage = [[GAConfigManager sharedInstance] imageForConfigKey:@"nextButtonImageName" default:@"next"];
    
    //enabledBackgroundImage = [enabledBackgroundImage stretchableImageWithLeftCapWidth:enabledBackgroundImage.size.width/2 topCapHeight:enabledBackgroundImage.size.height/2];
    
    NSString *text = GALocalizedString(@"next", nil);
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:text
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(didTapOnNextButton)];
    
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)didTapOnCloseButton {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    
    [[GASessionManager sharedManager] endSession];
}

- (void)didTapOnNextButton {
}

@end
