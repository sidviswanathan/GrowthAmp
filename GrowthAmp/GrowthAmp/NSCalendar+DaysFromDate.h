//
//  NSCalendar+MySpecialCalculation.h
//  GrowthAmp
//
//  Created by DON SHEFER on 9/12/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (DaysFromDate)

-(NSInteger)daysWithinEraFromDate:(NSDate *) startDate toDate:(NSDate *) endDate;

@end
