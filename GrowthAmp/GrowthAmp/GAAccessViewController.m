//
//  GAAccessViewController.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/11/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAAccessViewController.h"

@interface GAAccessViewController ()

@end

@implementation GAAccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didTapOnNextButton {
    [self.delegate accessViewController:self didTapOnNextButton:self.nextButton];
}

@end
