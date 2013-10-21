//
//  GAHeaderCell.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 8/3/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GACell.h"

@class GAHeaderModel;
@protocol GAHeaderCellDelegate;

typedef enum {
    GAHeaderCellStatusSelectAll = 0,
    GAHeaderCellStatusUnselectAll = 1
} GAHeaderCellStatus;

@interface GAHeaderCell : GACell

@property (nonatomic, strong) GAHeaderModel *model;
@property (nonatomic) GAHeaderCellStatus status;
@property (nonatomic, weak) id<GAHeaderCellDelegate> delegate;

@end

@interface GAHeaderModel : NSObject

@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) NSAttributedString *headerSubTitle;

@end

@protocol GAHeaderCellDelegate <NSObject>

- (void)headerCell:(GAHeaderCell *)cell didChangeWithSelectStatus:(GAHeaderCellStatus)status;

@end
