//
//  GAAccessViewController.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/11/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAAccessViewController.h"
#import "GADeviceInfo.h"
#import "GAConfigManager.h"
@interface GAAccessViewController ()

@end

@implementation GAAccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupContent];
    
    [[GATrackingManager sharedManager] reportUserActionWithName:kTrackingKeyPageEnable
                                                           type:kTrackingKeyTypeFull
                                                           info:nil];
}

- (void)setupContent {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = GALocalizedString(@"invite_friends", nil);
    titleLabel.textColor = [[GAConfigManager sharedInstance] colorForConfigKey:@"navBarTextColor" default:@"#FFFFFF"];
    self.navigationItem.titleView = titleLabel;
    
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
