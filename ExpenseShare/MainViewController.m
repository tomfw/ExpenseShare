//
//  MainViewController.m
//  ExpenseShare
//
//  Created by Thomas Williams on 11/2/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import "MainViewController.h"
#import "Group.h"
#import "AddExpenseViewController.h"
#import "ReimburseViewController.h"
#import "ExpenseChart.h"
#import "ESPacket.h"

@interface MainViewController ()

@end

@implementation MainViewController
- (void)readPacket:(ESPacket *)packet onConnection:(ESSConnection *)connection {

}

- (void)updateMadeOnConnection:(ESSConnection *)connection {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chart setNeedsDisplay];
    });
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [ESSConnection connection].delegate = self;
    [[ESSConnection connection] reload];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.group.grpName];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.chart setNeedsDisplay];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegToAddExpenseView"]) {
        AddExpenseViewController *dest = segue.destinationViewController;
        dest.userID = [[ESSConnection connection] userID];
        dest.grpID = self.group.grpID;
    }

    if ([segue.identifier isEqualToString:@"SegToReimburseView"]) {
        ReimburseViewController *dest = segue.destinationViewController;
        dest.userID = [[ESSConnection connection] userID];
        dest.grpID = self.group.grpID;
        dest.group = self.group;
    }

    if ([segue.identifier isEqualToString:@"SegToReportView"]) {
        NSLog(@"Reporting on some stuff!");
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
