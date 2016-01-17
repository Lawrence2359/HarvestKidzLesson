//
//  LessonQuizTableViewController.m
//  HarvestKidzLesson
//
//  Created by Lawrence Tan on 27/10/15.
//  Copyright © 2015 Lawrence Tan. All rights reserved.
//

#import "LessonQuizTableViewController.h"
#import "Question.h"
#import "QuestionTableViewCell.h"

@interface LessonQuizTableViewController () <UITextFieldDelegate>
@property (strong, nonatomic) NSMutableArray *questions;
@property (strong, nonatomic) NSMutableArray *qnStatusImg;
@property (strong, nonatomic) NSMutableArray *qnAnswersTxt;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) UIBarButtonItem *activityBarButton;
@property (strong, nonatomic) UIBarButtonItem *barButtonLeft;
@property (strong, nonatomic) UIBarButtonItem *barButtonRight;
@end

@implementation LessonQuizTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self loadQuestions];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)setup {
    self.barButtonLeft = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navbar_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    self.navigationController.navigationBar.barTintColor = [UIColor navBarColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"NexaBlack" size:20.0f],}];
    self.barButtonRight = [[UIBarButtonItem alloc]initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(onSubmit)];
    self.title = self.lessonId;
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityView.frame = CGRectMake(0, 0, 22, 22);
    self.activityBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.activityView];
    self.navigationItem.leftBarButtonItem = self.barButtonLeft;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 150.0;
    self.tableView.backgroundColor = [UIColor navBarColor];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)loadQuestions {
    self.questions = [[NSMutableArray alloc]init];
    self.qnStatusImg = [[NSMutableArray alloc]init];
    self.qnAnswersTxt = [[NSMutableArray alloc]init];
    self.navigationItem.rightBarButtonItem = self.activityBarButton;
    [self.activityView startAnimating];
    PFQuery *query = [PFQuery queryWithClassName:@"Question" predicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"questionLessonId == '%@'", self.lessonId]]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (!error) {
            for (PFObject *foundQuestion in objects) {
                Question *newQuestion = [[Question alloc]init];
                newQuestion.questionLessonId = [foundQuestion objectForKey:@"questionLessonId"];
                newQuestion.questionText = [foundQuestion objectForKey:@"questionText"];
                newQuestion.questionAnswer = [foundQuestion objectForKey:@"questionAnswer"];
                [self.questions addObject:newQuestion];
            }
            [self.tableView reloadData];
            [self.activityView stopAnimating];
            self.navigationItem.rightBarButtonItem = self.barButtonRight;
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error occured" message:@"Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questions.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionTableViewCell" forIndexPath:indexPath];
    
    Question *currQn = self.questions[indexPath.row];
    
    // border radius
    [cell.myView.layer setCornerRadius:15.0f];
    
    // border
    [cell.myView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [cell.myView.layer setBorderWidth:1.5f];
    
    // drop shadow
    [cell.myView.layer setShadowColor:[UIColor blackColor].CGColor];
    [cell.myView.layer setShadowOpacity:0.8];
    [cell.myView.layer setShadowRadius:3.0];
    [cell.myView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    // Configure the cell...
    cell.lblQuestion.text = currQn.questionText;
    [cell.lblQuestion setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.lblQuestion setMinimumScaleFactor:12.0/[UIFont labelFontSize]];
    cell.txtAnswer.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.qnStatusImg addObject:cell.imgView];
    [self.qnAnswersTxt addObject:cell.txtAnswer];
    return cell;
}

- (void)onSubmit{
    int i=0;
    for (Question *qn in self.questions) {
        UITextField *currTxtField = self.qnAnswersTxt[i];
        NSString *ans = qn.questionAnswer;
        UIImageView *currImg = self.qnStatusImg[i];
        
        if ( [ans caseInsensitiveCompare:currTxtField.text] == NSOrderedSame) {
            [currImg setImage:[UIImage imageNamed:@"tick"]];
        }else{
            [currImg setImage:[UIImage imageNamed:@"cross"]];
        }
        i++;
    }
    [self.tableView reloadData];
}

- (void)onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
