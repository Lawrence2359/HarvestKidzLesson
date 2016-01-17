//
//  Question.h
//  HarvestKidzLesson
//
//  Created by Lawrence Tan on 27/10/15.
//  Copyright © 2015 Lawrence Tan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject
@property (copy, nonatomic) NSString * questionLessonId;
@property (copy, nonatomic) NSString * questionText;
@property (copy, nonatomic) NSString * questionAnswer;
@end
