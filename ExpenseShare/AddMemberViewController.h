//
//  AddMemberViewController.h
//  ExpenseShare
//
//  Created by Thomas Williams on 11/4/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESSConnection.h"

@interface AddMemberViewController : UIViewController <ESSConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *userTable;

@end
