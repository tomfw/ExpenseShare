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
#import "ESPacket.h"
#import "AddExpenseViewController.h"
#import "ReimburseViewController.h"

@interface ReportViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *objects;
@property(nonatomic, strong) id selection;
@end

@implementation ReportViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id obj = self.objects[(NSUInteger) indexPath.row];
    self.selection = obj;
    if ([obj isKindOfClass:[Expense class]]) {
        [self performSegueWithIdentifier:@"SegToEditExpense" sender:self];
    } else if ([obj isKindOfClass:[Reimbursement class]]) {
        [self performSegueWithIdentifier:@"SegToEditReimbursement" sender:self];
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    id obj = self.objects[(NSUInteger) indexPath.row];
    if(![self isOurs:obj]) return UITableViewCellEditingStyleNone;
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    ESSConnection *connection = [ESSConnection connection];
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *objs = [NSMutableArray arrayWithArray:self.objects];
        id obj = self.objects[(NSUInteger) indexPath.row];
        [objs removeObjectAtIndex:(NSUInteger) indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.objects = [objs copy];
        [connection sendPacket:[ESPacket packetWithCode:ESPACKET_DELETE_OBJECT object:obj]];
        [connection reload];
    }
    [tableView endUpdates];

}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Total Expenses: $%.2f",[[ESSConnection connection] totalExpenses]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!self.objects)
        [self getObjects];
    return self.objects ? self.objects.count : 0;
}

-(BOOL)isOurs:(id)object {
    ESSConnection *connection = [ESSConnection connection];

    if ([object isKindOfClass:[Expense class]]) {
        Expense *obj = object;
        if (obj.userID == connection.userID) {
            return YES;
        }
    }

    if ([object isKindOfClass:[Reimbursement class]]) {
        Reimbursement *obj = object;
        if (obj.payerID == connection.userID) {
            return YES;
        }
    }

    return NO;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegToEditExpense"]) {
        AddExpenseViewController *dest = segue.destinationViewController;
        dest.displayExpense = (Expense *)self.selection;
    } else if ([segue.identifier isEqualToString:@"SegToEditReimbursement"]) {
        ReimburseViewController *dest = segue.destinationViewController;
        dest.display = (Reimbursement *)self.selection;
    }

}


@end
