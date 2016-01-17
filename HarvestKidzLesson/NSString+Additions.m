//
//  NSString+Additions.m
//  HarvestKidzLesson
//
//  Created by Lawrence Tan on 24/10/15.
//  Copyright © 2015 Lawrence Tan. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

+ (NSString*)getMonthStringFromMonthNum :(NSNumber*)month {
    int monthInt = [month intValue];
    switch (monthInt) {
        case 1:
            return @"Jan";
            break;
        case 2:
            return @"Feb";
            break;
        case 3:
            return @"Mar";
            break;
        case 4:
            return @"Apr";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"Jun";
            break;
        case 7:
            return @"Jul";
            break;
        case 8:
            return @"Aug";
            break;
        case 9:
            return @"Sep";
            break;
        case 10:
            return @"Oct";
            break;
        case 11:
            return @"Nov";
            break;
        case 12:
            return @"Dec";
            break;
        default:
            return @"NA";
            break;
    }
    return @"NA";
}

@end
