//
//  GAContactCell.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/2/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GACell.h"

@class GAContact;

@interface GAContactCell : GACell

@property (nonatomic, strong) GAContact *contact;
@property (nonatomic) BOOL checked;

@end