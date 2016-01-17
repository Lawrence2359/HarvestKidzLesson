//
//  Lesson.h
//  HarvestKidzLesson
//
//  Created by Lawrence Tan on 24/10/15.
//  Copyright © 2015 Lawrence Tan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lesson : NSObject
@property (copy, nonatomic) NSString * lessonYear;
@property (copy, nonatomic) NSString * lessonSeries;
@property (copy, nonatomic) NSNumber * lessonMonth;
@property (copy, nonatomic) NSNumber * lessonDay;
@end
