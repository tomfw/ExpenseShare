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

@interface ReimburseViewController ()
@property (strong, nonatomic) User *selected;
@property (strong, nonatomic) NSArray *members;
@property (nonatomic) NSInteger whoIndex;
@end

@implementation ReimburseViewController
- (void)readPacket:(ESPacket *)packet onConnection:(ESSConnection *)connection {
    if(packet.code == ESPACKET_OK) {
        NSLog(@"We saved our reimbursement!");
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
}

- (void)getMembers {
    NSMutableArray *mems = [NSMutableArray array];
    for (NSNumber* key in self.group.users) {
        [mems addObject:[self.group.users objectForKey:key]];
    }
    for (User *mem in mems) {
        NSLog(@"%@",mem.userName);
    }
    self.members = [mems copy];
}

- (IBAction)savePressed:(id)sender {
    Reimbursement *new = [Reimbursement reimbursementFrom:self.userID to:self.selected.userID inGroup:self.group.grpID];
    new.amount = [[[NSNumberFormatter new] numberFromString:self.amtField.text] doubleValue];
    new.memo = self.memoField.text;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
    new.month = components.month;
    new.year = components.year;

    ESSConnection *connection = [ESSConnection connection];
    [connection sendPacket:[ESPacket packetWithCode:ESPACKET_ADD_REIMBURSMENT object:new]];
    [connection readPacket];
    connection.delegate = self;
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
