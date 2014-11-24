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
#import "Group.h"
#import "MainViewController.h"

@interface GroupsViewController ()
@property (strong, nonatomic) NSArray *groups;
@property (strong, nonatomic) Group *selectedGroup;
@end

@implementation GroupsViewController

- (void)readPacket:(ESPacket *)packet onConnection:(ESSConnection *)connection {
    if(packet.code == ESPACKET_GROUPS) {
        self.groups = (NSArray *)packet.object;
        if(self.groups.count > 0) {
            NSLog(@"We are in %lu",(unsigned long)self.groups.count);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"We aren't in any groups yet!");
        }
    }
}


- (IBAction)skipPressed:(id)sender {
    //TODO:Skip this screen until group features are added
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedGroup = self.groups[(NSUInteger) indexPath.row];
    NSLog(@"User selected: %@",self.selectedGroup.grpName);
    [self performSegueWithIdentifier:@"SegToMain" sender:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger) (self.groups ? self.groups.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"groupCell"];
    Group *group = self.groups[(NSUInteger) indexPath.row];
    cell.textLabel.text = group.grpName;
    cell.detailTextLabel.text = group.grpDescription;
    return cell;
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegToMain"]) {
        MainViewController *destVC = (MainViewController *)segue.destinationViewController;
        destVC.group = self.selectedGroup;
    }
}

@end
