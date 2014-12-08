//
//  AddExpenseViewController.m
//  ExpenseShare
//
//  Created by Thomas Williams on 11/2/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import "AddExpenseViewController.h"
#import "Expense.h"
#import "ESSConnection.h"
#import "ESPacket.h"

@interface AddExpenseViewController () <ESSConnectionDelegate, UITextFieldDelegate>
@property(nonatomic) BOOL readOnly;
@end

@implementation AddExpenseViewController
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return !self.readOnly;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)readPacket:(ESPacket *)packet onConnection:(ESSConnection *)connection {
    if(packet.code == ESPACKET_OK) {
        NSLog(@"We wrote an expense!");

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (IBAction)addExpensePressed:(id)sender {
    Expense *new;
    ESSConnection *connection = [ESSConnection connection];
    connection.delegate = self;
    NSNumber *amt = [[NSNumberFormatter new] numberFromString:self.amtField.text];

    if (self.displayExpense) { //we want to resave the expense we are editing
        self.displayExpense.item = self.itemField.text;
        self.displayExpense.amount = amt.doubleValue;
        self.displayExpense.memo = self.memoField.text;

        [connection sendPacket:[ESPacket packetWithCode:ESPACKET_UPDATE_OBJECT object:self.displayExpense]];
        [self.navigationController popViewControllerAnimated:YES];

    } else { //save the new expense
        new = [Expense expenseInGroup:self.grpID byUser:self.userID];

        new.amount = amt.doubleValue;
        new.item = self.itemField.text;
        new.memo = self.memoField.text;

        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
        new.month = components.month;
        new.year  = components.year;

        [connection sendPacket:[ESPacket packetWithCode:ESPACKET_ADD_EXPENSE object:new]];
        [connection readPacket];
    }
}

- (IBAction)cancelPressed:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.displayExpense) {

        if (self.displayExpense.userID != [[ESSConnection connection] userID]) {
           self.readOnly = YES;
           self.addButton.enabled = NO;
        }

        self.itemField.text = self.displayExpense.item;
        self.amtField.text = [NSString stringWithFormat:@"%.2f", self.displayExpense.amount];
        self.memoField.text = self.displayExpense.memo;
        [self.addButton setTitle:@"Save" forState:UIControlStateNormal];

    }
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
