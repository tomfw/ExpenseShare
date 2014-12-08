//
//  RegisterViewController.m
//  ExpenseShare
//
//  Created by Thomas Williams on 11/4/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import "RegisterViewController.h"
#import "ESSConnection.h"
#import "ESPacket.h"

@interface RegisterViewController () <ESSConnectionDelegate, UITextFieldDelegate>

@end

@implementation RegisterViewController

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)doneEditing:(UITextField *)sender {
    [self.view resignFirstResponder];
}

- (void)readPacket:(ESPacket *)packet onConnection:(ESSConnection *)connection {
    if (packet.code == ESPACKET_ASSIGN_USERID) {
        [[NSUserDefaults standardUserDefaults] setValue:packet.object forKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"Saved new id");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{}];
        });
    }
}

- (IBAction)registerPressed:(id)sender {
    ESSConnection *conn = [ESSConnection connection];
    conn.delegate = self;
    [conn sendPacket:[ESPacket packetWithCode:ESPACKET_REGISTER object:self.userNameField.text]];
    [conn readPacket];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
