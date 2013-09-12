//
//  NSCalendar+MySpecialCalculation.m
//  GrowthAmp
//
//  Created by DON SHEFER on 9/12/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "NSCalendar+MySpecialCalculation.h"

@implementation NSCalendar (MySpecialCalculation)

-(NSInteger)daysWithinEraFromDate:(NSDate *) startDate toDate:(NSDate *) endDate
{
    NSInteger startDay=[self ordinalityOfUnit:NSDayCalendarUnit
                                       inUnit: NSEraCalendarUnit forDate:startDate];
    NSInteger endDay=[self ordinalityOfUnit:NSDayCalendarUnit
                                     inUnit: NSEraCalendarUnit forDate:endDate];
    return endDay-startDay;
}
@end
