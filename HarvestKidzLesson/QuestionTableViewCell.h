//
//  QuestionTableViewCell.h
//  HarvestKidzLesson
//
//  Created by Lawrence Tan on 27/10/15.
//  Copyright © 2015 Lawrence Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;
@property (weak, nonatomic) IBOutlet UITextField *txtAnswer;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *myView;

@end
