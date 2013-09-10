//
//  GAViewController.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/11/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GAViewController : UIViewController

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *nextButton;

- (void)didTapOnCloseButton;
- (void)didTapOnNextButton;

@end
