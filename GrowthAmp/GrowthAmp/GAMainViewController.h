//
//  GAMainViewController.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/11/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAViewController.h"

@protocol GAMainViewControllerDelegate;

@interface GAMainViewController : GAViewController

@property (nonatomic, weak) id<GAMainViewControllerDelegate> delegate;

@end

@protocol GAMainViewControllerDelegate <NSObject>

- (void)mainViewController:(GAMainViewController *)controller didTapOnContinueButton:(UIButton *)button;

@end
