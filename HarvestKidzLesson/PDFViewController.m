//
//  PDFViewController.m
//  HarvestKidzLesson
//
//  Created by Lawrence Tan on 24/10/15.
//  Copyright © 2015 Lawrence Tan. All rights reserved.
//

#import "PDFViewController.h"
#import "LessonQuizTableViewController.h"

@interface PDFViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) UIBarButtonItem *activityBarButton;
@property (strong, nonatomic) UIBarButtonItem *barButtonLeft;
@property (strong, nonatomic) UIBarButtonItem *barButtonRight;
@end

@implementation PDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self loadPDF];
}

- (void)setup {
    self.barButtonLeft = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navbar_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    self.barButtonRight = [[UIBarButtonItem alloc]initWithTitle:@"Take Quiz" style:UIBarButtonItemStylePlain target:self action:@selector(onQuiz)];
    self.navigationController.navigationBar.barTintColor = [UIColor navBarColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                       NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"NexaBlack" size:20.0f],
                                                                       }];
    self.title = self.lessonId;
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityView.frame = CGRectMake(0, 0, 22, 22);
    self.activityBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.activityView];
    self.navigationItem.leftBarButtonItem = self.barButtonLeft;
}

- (void)loadPDF {
    
    self.navigationItem.rightBarButtonItem = self.activityBarButton;
    [self.activityView startAnimating];
    
    PFQuery *query = [PFQuery queryWithClassName:@"LessonFile" predicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"lessonId == '%@'", self.lessonId]]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * foundLessonItem, NSError *error) {
        
        if (!error) {
            
            PFFile *lessonItemFile = [foundLessonItem objectForKey:@"lessonFileItem"];
            NSString *urlString = lessonItemFile.url;
            NSURL *targetURL = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
            [self.webView loadRequest:request];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error occured" message:@"Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error occured" message:@"Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityView stopAnimating];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = self.barButtonRight;
}

- (void)onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onQuiz {
    LessonQuizTableViewController *dst = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"LessonQuizTableViewController"];
    dst.lessonId = self.lessonId;
    [self.navigationController pushViewController:dst animated:YES];
}

@end
