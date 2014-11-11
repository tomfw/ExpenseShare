//
//  GroupsViewController.m
//  ExpenseShare
//
//  Created by Thomas Williams on 11/4/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import "GroupsViewController.h"
#import "ESSConnection.h"
#import "ESPacket.h"

@interface GroupsViewController ()

@end

@implementation GroupsViewController

- (void)readPacket:(ESPacket *)packet onConnection:(ESSConnection *)connection {
    if(packet.code == ESPACKET_GROUPS) {
        NSArray *groups = (NSArray *)packet.object;
        if(groups.count > 0) {
            NSLog(@"We are in %u",groups.count);
        } else {
            NSLog(@"We aren't in any groups yet!");
        }
    }
}


- (IBAction)skipPressed:(id)sender {
    //TODO:Skip this screen until group features are added
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ESSConnection *connection = [ESSConnection connection];
    [connection connect];
    if(connection.userID == -1) {
        [self performSegueWithIdentifier:@"SegToRegister" sender:self];
    }
    connection.delegate = self;
    [connection sendPacket:[ESPacket packetWithCode:ESPACKET_REQUEST_GROUPS object:nil]];
    [connection readPacket];
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
