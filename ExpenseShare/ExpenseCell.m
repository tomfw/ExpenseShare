//
//  ExpenseCell.m
//  ExpenseShare
//
//  Created by Thomas Williams on 11/26/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import "ExpenseCell.h"
#import "Expense.h"
#import "User.h"
#import "ESSConnection.h"
#import "Group.h"

@implementation ExpenseCell

- (void)setExpense:(Expense *)expense {
    _expense = expense;
    User *payer = [[ESSConnection connection].group.users objectForKey:@(expense.userID)];
    self.amountLabel.text = [NSString stringWithFormat:@"$%.2f", expense.amount];
    self.userLabel.text = payer.userName;
    self.memoLabel.text = expense.memo;
    self.itemLabel.text = expense.item;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
