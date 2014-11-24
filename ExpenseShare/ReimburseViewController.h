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

@interface ReimburseViewController : UIViewController <ESSConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *amtField;
@property (weak, nonatomic) IBOutlet UITextField *whoField;
@property (weak, nonatomic) IBOutlet UITextField *memoField;
@property (nonatomic) NSInteger userID;
@property (nonatomic) NSInteger grpID;
@property (strong, nonatomic) Group *group;

@end
