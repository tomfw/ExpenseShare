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
@property (strong, nonatomic) Group *selectedGroup;
@end

@implementation GroupsViewController

- (void)readPacket:(ESPacket *)packet onConnection:(ESSConnection *)connection {
}

- (void)updateMadeOnConnection:(ESSConnection *)connection {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (IBAction)skipPressed:(id)sender {
    //TODO:Skip this screen until group features are added
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedGroup = [ESSConnection connection].groups[(NSUInteger) indexPath.row];
    [self performSegueWithIdentifier:@"SegToMain" sender:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger) ([ESSConnection connection].groups ? [ESSConnection connection].groups.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"groupCell"];
    Group *group = [ESSConnection connection].groups[(NSUInteger) indexPath.row];
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
    [connection reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegToMain"]) {
        [ESSConnection connection].group = self.selectedGroup;
        MainViewController *destVC = (MainViewController *)segue.destinationViewController;
        destVC.group = self.selectedGroup;
    }
}

@end
