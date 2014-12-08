//
//  ReimburseViewController.h
//  ExpenseShare
//
//  Created by Thomas Williams on 11/2/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESSConnection.h"

@class Group;
@class Reimbursement;

@interface ReimburseViewController : UIViewController <ESSConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *amtField;
@property (weak, nonatomic) IBOutlet UIButton *whoButton;
@property (weak, nonatomic) IBOutlet UITextField *memoField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic) NSInteger userID;
@property (nonatomic) NSInteger grpID;
@property (strong, nonatomic) Group *group;
@property (strong, nonatomic) Reimbursement *display;

@end
