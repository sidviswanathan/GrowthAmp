//
//  UIAlertView+GABlock.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIActionAlertViewCallBackHandler)(UIAlertView *alertView, NSInteger buttonIndex);

@interface UIAlertView (GABlock) <UIAlertViewDelegate>

- (void)showAlerViewWithHandler:(UIActionAlertViewCallBackHandler)handler;

@end
