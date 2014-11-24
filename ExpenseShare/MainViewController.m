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
#import "ESSConnection.h"
#import "ReimburseViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.group.grpName];
    NSLog(@"%@ has %u users: %@",self.group.grpName,self.group.users.count,self.group.users);
    [[ESSConnection connection] setGrpID:self.group.grpID];
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
    NSLog(@"Segue: %@",segue.identifier);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
