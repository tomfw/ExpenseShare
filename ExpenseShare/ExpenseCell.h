//
//  ExpenseCell.h
//  ExpenseShare
//
//  Created by Thomas Williams on 11/26/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Expense;

@interface ExpenseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (strong, nonatomic) Expense *expense;
@end
