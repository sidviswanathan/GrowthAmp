//
//  GAAccessViewController.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/11/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAAccessViewController.h"
#import "GADeviceInfo.h"

@interface GAAccessViewController ()

@end

@implementation GAAccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupContent];
}

- (void)setupContent {
    
    self.navigationItem.title = GALocalizedString(@"invite_friends", nil);
    
    NSArray *nibViews = [[GAFrameworkUtils frameworkBundle] loadNibNamed:@"Access" owner:self options:nil];
    UIView *contentView = [nibViews objectAtIndex:0];
    
    contentView.center = self.view.center;
    [self.view addSubview:contentView];
    
    
    for (UILabel *label in contentView.subviews) {
        
        label.text = [label.text stringByReplacingOccurrencesOfString:@"APP_NAME"
                                                           withString:[GADeviceInfo appName]];
    }
    
}

- (void)didTapOnNextButton {
    [self.delegate accessViewController:self didTapOnNextButton:self.nextButton];
}

@end
