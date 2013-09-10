//
//  GAAccessViewController.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/11/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAViewController.h"

@protocol GGAAccessViewControllerDelegate;

@interface GAAccessViewController : GAViewController

@property (nonatomic, retain) IBOutlet UIView *view;
@property (nonatomic, weak) id<GGAAccessViewControllerDelegate> delegate;

@end

@protocol GGAAccessViewControllerDelegate <NSObject>

- (void)accessViewController:(GAAccessViewController *)controller didTapOnNextButton:(UIButton *)button;

@end
