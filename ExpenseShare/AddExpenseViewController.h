//
//  AddExpenseViewController.h
//  ExpenseShare
//
//  Created by Thomas Williams on 11/2/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddExpenseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *itemField;
@property (weak, nonatomic) IBOutlet UITextField *amtField;
@property (weak, nonatomic) IBOutlet UITextField *memoField;
@property (nonatomic) NSInteger userID;
@property (nonatomic) NSInteger grpID;
@end
