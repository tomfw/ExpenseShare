//
//  ReportViewController.m
//  ExpenseShare
//
//  Created by Thomas Williams on 11/2/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import "ReportViewController.h"
#import "ESSConnection.h"
#import "Expense.h"
#import "Reimbursement.h"
#import "ReimbursementCell.h"
#import "ExpenseCell.h"
#import "Group.h"
#import "User.h"
#import "TotalCell.h"

@interface ReportViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *objects;
@end

@implementation ReportViewController
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Total Expenses: $%.2f",[[ESSConnection connection] totalExpenses]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!self.objects)
        [self getObjects];
    return self.objects ? self.objects.count : 0;
}

- (void)getObjects {
    NSMutableArray *objs = [NSMutableArray array];
    ESSConnection *connection = [ESSConnection connection];
    double totalExpenses = connection.totalExpenses;

    for (NSNumber *userID in connection.group.users) {
        User *user = [connection.group.users objectForKey:userID];

        for (Expense *expense in connection.expenses) {
            if (expense.userID == user.userID) {
                [objs addObject:expense];
            }
        }
        for (Reimbursement *reimbursement in connection.reimbursements) {
            if (reimbursement.payerID == user.userID) {
                [objs addObject:reimbursement];
            }
        }
        double userAmount = [connection expensesForUser:user.userID];
        double userShare = userAmount / totalExpenses * 100;
        TotalCell *cell = [[NSBundle mainBundle] loadNibNamed:@"TotalCell" owner:self options:nil].firstObject;
        [cell setAmount:userAmount userName:user.userName share:userShare];
        [objs addObject:cell];
    }

    if(objs.count > 0)
        self.objects = objs;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESSConnection *connection = [ESSConnection connection];
    UITableViewCell *cell;
    id object = self.objects[(NSUInteger) indexPath.row];
    if ([object isKindOfClass:[Expense class]]) {
        Expense *expense = self.objects[(NSUInteger) indexPath.row];
        ExpenseCell *expenseCell = [tableView dequeueReusableCellWithIdentifier:@"ExpenseCell"];
        if(!expenseCell)
            expenseCell = [[NSBundle mainBundle] loadNibNamed:@"ExpenseCell" owner:self options:nil].firstObject;
        expenseCell.expense = expense;
        cell = expenseCell;
    } else if ([object isKindOfClass:[Reimbursement class]]) {
        Reimbursement *reimbursement = self.objects[(NSUInteger) indexPath.row];
        ReimbursementCell *reimbursementCell = [tableView dequeueReusableCellWithIdentifier:@"ReimbursementCell"];
        if(!reimbursementCell)
            reimbursementCell = [[NSBundle mainBundle] loadNibNamed:@"ReimbursementCell" owner:self options:nil].firstObject;

        reimbursementCell.reimbursement = reimbursement;
        cell = reimbursementCell;
    } else {
        cell = self.objects[(NSUInteger) indexPath.row]; // total cell already prepared!
    }
   /* if(indexPath.row < connection.expenses.count ) {
        Expense *expense = connection.expenses[(NSUInteger) indexPath.row];
        ExpenseCell *expenseCell = [tableView dequeueReusableCellWithIdentifier:@"ExpenseCell"];
        if(!expenseCell)
            expenseCell = [[NSBundle mainBundle] loadNibNamed:@"ExpenseCell" owner:self options:nil].firstObject;
        expenseCell.expense = expense;
        cell = expenseCell;
    } else {
        Reimbursement *reimbursement = connection.reimbursements[(NSUInteger) indexPath.row - connection.expenses.count];
        ReimbursementCell *reimbursementCell = [tableView dequeueReusableCellWithIdentifier:@"ReimbursementCell"];
        if(!reimbursementCell)
            reimbursementCell = [[NSBundle mainBundle] loadNibNamed:@"ReimbursementCell" owner:self options:nil].firstObject;

        reimbursementCell.reimbursement = reimbursement;
        cell = reimbursementCell;
    }*/
    return cell;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
