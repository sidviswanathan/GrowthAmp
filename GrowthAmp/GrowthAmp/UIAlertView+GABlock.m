//
//  UIAlertView+GABlock.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "UIAlertView+GABlock.h"
#import <objc/runtime.h>

@implementation UIAlertView (GABlock)

//Runtime association key.
static NSString *handlerRunTimeAccosiationKey = @"alertViewBlocksDelegate";

- (void)showAlerViewWithHandler:(UIActionAlertViewCallBackHandler)handler {
    //set runtime accosiation of object
    //param -  sourse object for association, association key, association value, policy of association
    objc_setAssociatedObject(self, (__bridge const void *)(handlerRunTimeAccosiationKey), handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setDelegate:self];
    [self show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIActionAlertViewCallBackHandler completionHandler = objc_getAssociatedObject(self, (__bridge  const void *)(handlerRunTimeAccosiationKey));
    
    if (completionHandler != nil) {
        
        completionHandler(alertView, buttonIndex);
    }
}

@end
