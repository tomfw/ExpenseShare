//
//  AddMemberViewController.m
//  ExpenseShare
//
//  Created by Thomas Williams on 11/4/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import "AddMemberViewController.h"
#import "ESSConnection.h"
#import "ESPacket.h"
#import "User.h"
#import "User_Group.h"
#import "Group.h"

@interface AddMemberViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) User *selected;
@end

@implementation AddMemberViewController
- (void)readPacket:(ESPacket *)packet onConnection:(ESSConnection *)connection {
    if (packet.code == ESPACKET_ALL_USERS) {
        self.users = (NSArray*)packet.object;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.userTable reloadData];
        });
    }
    if (packet.code == ESPACKET_OK) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (IBAction)addMemberPressed:(id)sender {
    if (self.selected) {
        ESSConnection *connection = [ESSConnection connection];
        User_Group *user_group = [User_Group userGroupWithUser:self.selected.userID inGroup:[ESSConnection connection].group.grpID];
        [connection sendPacket:[ESPacket packetWithCode:ESPACKET_ADD_GROUP_MEMBER object:user_group]];
        [connection readPacket];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selected = self.users[(NSUInteger) indexPath.row];
    NSLog(@"Selected: %@",self.selected.userName);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = self.users[(NSUInteger) indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", user.userName];
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ESSConnection *connection = [ESSConnection connection];
    [connection sendPacket:[ESPacket packetWithCode:ESPACKET_REQUEST_USERS object:nil]];
    [connection readPacket];
    connection.delegate = self;
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
