//
//  LoggerTableViewController.m
//  CAPLogger
//
//  Created by Andrew Donnelly on 12/08/2016.
//  Copyright © 2016 jlr. All rights reserved.
//

#import "LoggerViewController.h"
#import "CAPLogger.h"

@interface LoggerViewController ()
{
    NSDateFormatter *dateFormatter;
    UIButton *trashLogView;
    UITextView *logTextView;
}
@end

@implementation LoggerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    dateFormatter = [[NSDateFormatter alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForNotifications];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    logTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    logTextView.editable = FALSE;
    logTextView.selectable = FALSE;
    [self.view addSubview:logTextView];
    
    trashLogView = [UIButton buttonWithType:UIButtonTypeCustom];
    trashLogView.frame = CGRectMake(self.view.frame.size.width-50, 8, 21, 28);
    trashLogView.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:10.0f];
    [trashLogView setImage:[UIImage imageNamed:@"711-trash"] forState:UIControlStateNormal];
    [trashLogView addTarget:self action:@selector(trashLogs) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:trashLogView];
}

-(void)reloadLogData:(NSNotification *)notification
{
    NSDictionary *eventInfo = [notification.userInfo objectForKey:@"eventInfo"];
    logTextView.text = [NSString stringWithFormat:@"data: %@ \n\n %@", [eventInfo objectForKey:@"eventData"], logTextView.text];
    logTextView.text = [NSString stringWithFormat:@"type: %@ \n %@", [eventInfo objectForKey:@"eventType"], logTextView.text];
    logTextView.text = [NSString stringWithFormat:@"time: %@ \n %@", [eventInfo objectForKey:@"eventTimestamp"], logTextView.text];
    logTextView.text = [NSString stringWithFormat:@"vin:  %@ \n %@", [eventInfo objectForKey:@"vin"], logTextView.text];
    logTextView.text = [NSString stringWithFormat:@"id:   %@ \n %@", [eventInfo objectForKey:@"eventId"], logTextView.text];
}

-(void)trashLogs
{
    [[CAPLogger sharedCAPLogger].displayEvents removeAllObjects];
    logTextView.text = @"";
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

-(void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLogData:) name:kNotificationUpdateEventDisplay object:nil];
}

-(void)unregisterNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUpdateEventDisplay object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
