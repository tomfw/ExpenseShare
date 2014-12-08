//
//  ReimburseViewController.m
//  ExpenseShare
//
//  Created by Thomas Williams on 11/2/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import "ReimburseViewController.h"
#import "Reimbursement.h"
#import "Group.h"
#import "ESSConnection.h"
#import "ESPacket.h"
#import "User.h"

@interface ReimburseViewController () <UITextFieldDelegate>
@property (strong, nonatomic) User *selected;
@property (strong, nonatomic) NSArray *members;
@property (nonatomic) NSInteger whoIndex;
@property (nonatomic) BOOL readOnly;
@end

@implementation ReimburseViewController
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return !self.readOnly;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)readPacket:(ESPacket *)packet onConnection:(ESSConnection *)connection {
    if(packet.code == ESPACKET_OK) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (IBAction)whoPressed:(id)sender {
    if(!self.members)
        [self getMembers];

    self.selected = self.members[(NSUInteger) self.whoIndex];
    [self.whoButton setTitle:self.selected.userName forState:UIControlStateNormal];

    self.whoIndex++;
    if(self.whoIndex == self.members.count) self.whoIndex = 0;
   if (self.selected.userID == [[ESSConnection connection] userID] && self.members.count > 1) {
       [self whoPressed:self];
    }
}

-(NSInteger)indexOfMemberWithID:(NSInteger)userID {
    NSInteger index = -1;

    for (NSUInteger i = 0; i < self.members.count; i++) {
        User *mem = self.members[i];
        if(mem.userID == userID) {
            index = i;
            NSLog(@"Found er at %u", i);
        }
    }

    return index;
}

- (void)getMembers {
    NSMutableArray *mems = [NSMutableArray array];
    for (NSNumber* key in self.group.users) {
        [mems addObject:[self.group.users objectForKey:key]];
    }
    self.members = [mems copy];
}

- (IBAction)savePressed:(id)sender {
    Reimbursement *new;
    ESSConnection *connection = [ESSConnection connection];
    connection.delegate = self;

    if(self.display) {
        self.display.amount = [[[NSNumberFormatter new] numberFromString:self.amtField.text] doubleValue];
        self.display.memo = self.memoField.text;

        [connection sendPacket:[ESPacket packetWithCode:ESPACKET_UPDATE_OBJECT object:self.display]];
        [self.navigationController popViewControllerAnimated:YES];

    } else {
        new = [Reimbursement reimbursementFrom:self.userID to:self.selected.userID inGroup:self.group.grpID];
        new.amount = [[[NSNumberFormatter new] numberFromString:self.amtField.text] doubleValue];
        new.memo   = self.memoField.text;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
        new.month = components.month;
        new.year  = components.year;

        [connection sendPacket:[ESPacket packetWithCode:ESPACKET_ADD_REIMBURSMENT object:new]];
        [connection readPacket];
    }
}

- (void)viewDidLoad {
   [super viewDidLoad];
    self.group = [[ESSConnection connection] group];
    [self whoPressed:self];
    if (self.display) {

        if (self.display.payerID != [[ESSConnection connection] userID]) {
            self.readOnly = YES;
            self.whoButton.enabled = NO;
            self.saveButton.enabled = NO;
        }

        NSInteger idx = [self indexOfMemberWithID:self.display.payeeID];
        self.selected = self.members[(NSUInteger) idx];
        [self.whoButton setTitle:self.selected.userName forState:UIControlStateNormal | UIControlStateDisabled];
        self.whoIndex = idx;

        self.amtField.text = [NSString stringWithFormat:@"%.2f", self.display.amount];
        self.memoField.text = self.display.memo;

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
