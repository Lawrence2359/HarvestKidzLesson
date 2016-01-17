//
//  LessonsTableViewController.m
//  HarvestKidzLesson
//
//  Created by Lawrence Tan on 24/10/15.
//  Copyright © 2015 Lawrence Tan. All rights reserved.
//

#import "LessonsTableViewController.h"
#import "PDFViewController.h"
#import "LessonItemTableViewCell.h"
#import "Lesson.h"
#import "NSString+Additions.h"

@interface LessonsTableViewController ()
@property (strong, nonatomic) NSMutableArray *lessons;
@property (strong, nonatomic) NSMutableArray *months;
@property (strong, nonatomic) NSMutableDictionary *monthLessons;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) UIBarButtonItem *activityBarButton;
@property (strong, nonatomic) NSMutableDictionary *lessonCollections;
@property (strong, nonatomic) NSArray *keys;
@end

@implementation LessonsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self loadLessonItems];
}

- (void)setup {
    self.navigationController.navigationBar.barTintColor = [UIColor navBarColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                       NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"NexaBlack" size:20.0f],
                                                                       }];
    self.title = @"HK Lessons Listing";
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityView.frame = CGRectMake(0, 0, 22, 22);
    self.activityBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.activityView];
}

- (void)loadLessonItems {
    self.navigationItem.rightBarButtonItem = self.activityBarButton;
    [self.activityView startAnimating];
    self.lessons = [[NSMutableArray alloc]init];
    self.months = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"Lesson"];

    [query orderByDescending:@"lessonDay"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            for (PFObject *currObj in objects) {
                Lesson *newItem = [[Lesson alloc]init];
                newItem.lessonSeries = [currObj objectForKey:@"lessonSeries"];
                newItem.lessonYear = [currObj objectForKey:@"lessonYear"];
                newItem.lessonMonth = [NSNumber numberWithInt:[[currObj objectForKey:@"lessonMonth"] intValue]];
                newItem.lessonDay = [NSNumber numberWithInt:[[currObj objectForKey:@"lessonDay"] intValue]];
                [self.lessons addObject:newItem];
            }
            [self processData];
            [self.activityView stopAnimating];
            self.navigationItem.rightBarButtonItem = nil;
            [self.tableView reloadData];
        }
    }];
}

- (void)processData {
    self.lessonCollections = [[NSMutableDictionary alloc]init];
    for (Lesson *item in self.lessons) {
        id array = [self.lessonCollections objectForKey:item.lessonMonth];
        
        if (![array isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *newArray = [[NSMutableArray alloc]init];
            [newArray addObject:item];
            [self.lessonCollections setObject:newArray forKey:item.lessonMonth];
        }else{
            NSMutableArray *tempArray = [self.lessonCollections objectForKey:item.lessonMonth];
            [tempArray addObject:item];
            [self.lessonCollections setObject:tempArray forKey:item.lessonMonth];
        }
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *months = [self.lessonCollections allKeys];
    return months.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *months = [self.lessonCollections allKeys];
    NSNumber *key = months[section];
    NSMutableArray *days = [self.lessonCollections objectForKey:key];
    return days.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, tableView.frame.size.width-8, 44)];
    [label setFont:[UIFont fontWithName:@"NexaBlack" size:15]];
    NSArray *months = [self.lessonCollections allKeys];
    NSNumber *key = months[section];
    /* Section header is in 0th index... */
    [label setText:[NSString getMonthStringFromMonthNum:key]];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LessonItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LessonItemTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *months = [self.lessonCollections allKeys];
    NSNumber *key = months[indexPath.section];
    NSMutableArray *days = [self.lessonCollections objectForKey:key];
    Lesson *currLesson = [days objectAtIndex:indexPath.row];
    cell.lblTitle.text = [NSString stringWithFormat:@"%@ %@ %zd - %@", currLesson.lessonYear, [NSString getMonthStringFromMonthNum:currLesson.lessonMonth], [currLesson.lessonDay intValue], currLesson.lessonSeries];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *months = [self.lessonCollections allKeys];
    NSNumber *key = months[indexPath.section];
    NSMutableArray *days = [self.lessonCollections objectForKey:key];
    Lesson *currLesson = [days objectAtIndex:indexPath.row];
    PDFViewController *dst = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PDFViewController"];
    dst.lessonId = [NSString stringWithFormat:@"%@-%@-%zd", currLesson.lessonYear, [NSString getMonthStringFromMonthNum:currLesson.lessonMonth], [currLesson.lessonDay intValue]];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:dst animated:NO];
}

@end
