//
//  AddGroupViewController.m
//  ExpenseShare
//
//  Created by Thomas Williams on 11/4/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import "AddGroupViewController.h"
#import "ESSConnection.h"
#import "ESPacket.h"
#import "Group.h"

@interface AddGroupViewController () <ESSConnectionDelegate, UITextFieldDelegate>

@end

@implementation AddGroupViewController

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)readPacket:(ESPacket *)packet onConnection:(ESSConnection *)connection {
    if(packet.code == ESPACKET_OK) {
        NSLog(@"Added a group!");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } else {
        NSLog(@"Something strange has happened");
    }
}

- (IBAction)addPressed:(id)sender {
    if(self.groupNameField.text ) {
        ESSConnection *connection = [ESSConnection connection];
        connection.delegate = self;
        [connection sendPacket:[ESPacket packetWithCode:ESPACKET_ADD_GROUP object:[Group groupWithName:self.groupNameField.text description:self.groupDescriptionField.text]]];
        [connection readPacket];
    } else {
        NSLog(@"Name field cannot be blank");

    }
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
