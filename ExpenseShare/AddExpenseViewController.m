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

@interface AddExpenseViewController () <ESSConnectionDelegate>
@end

@implementation AddExpenseViewController
- (IBAction)stoppedEditing:(id)sender {
    [sender resignFirstResponder];
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
    Expense *new = [Expense expenseInGroup:self.grpID byUser:self.userID];

    NSNumber *amt = [[NSNumberFormatter new] numberFromString:self.amtField.text];
    new.amount = amt.doubleValue;

    NSLog(@"Amount: %@",self.amtField.text);
    new.item = self.itemField.text;
    new.memo = self.memoField.text;
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
    new.month = components.month;
    new.year = components.year;

    ESSConnection *connection = [ESSConnection connection];
    connection.delegate = self;
    [connection sendPacket:[ESPacket packetWithCode:ESPACKET_ADD_EXPENSE object:new]];
    [connection readPacket];
}

- (IBAction)cancelPressed:(id)sender {
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
