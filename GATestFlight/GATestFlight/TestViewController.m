//
//  TestViewController.m
//  Sample
//
//  Created by Kirollos Risk on 8/11/13.
//
//

#import "TestViewController.h"
#import <GrowthAmp/GrowthAmp.h>

#define BUTTON_HEIGHT 44

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self createButtonOne];
    [self createButtonTwo];
}

- (void)createButtonOne {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Splash" forState:UIControlStateNormal];
    
    [button setFrame:CGRectMake(20, 20, screenSize.width-20*2, BUTTON_HEIGHT)];
    [button addTarget:self action:@selector(buttonOneClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)createButtonTwo {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Invite Friends" forState:UIControlStateNormal];
    
    [button setFrame:CGRectMake(20, BUTTON_HEIGHT * 2, screenSize.width-20*2, BUTTON_HEIGHT)];
    [button addTarget:self action:@selector(buttonTwoClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)buttonOneClicked {

    // Optionally set user contact information before presenting invitation view controller
    [GALoader sharedInstance].userContact = @{@"firstName" : @"",
                                              @"lastName"  : @"",
                                              @"email"     : @""};
                           
    // Invoke the Growth Amp invitation view controller
	[[GALoader sharedInstance] presentInvitationsFromController:self
                                                     showSplash:YES
                                                    sessionType:@"test_button_1"];
}

- (void)buttonTwoClicked {

    // Optionally set user contact information before presenting invitation view controller
    [GALoader sharedInstance].userContact = @{@"firstName" : @"",
                                              @"lastName"  : @"",
                                              @"email"     : @""};

    // Invoke the Growth Amp invitation view controller
    [[GALoader sharedInstance] presentInvitationsFromController:self
                                                     showSplash:NO
                                                    sessionType:@"test_button_2"];
}

@end
