//
//  ReimbursementCell.h
//  ExpenseShare
//
//  Created by Thomas Williams on 11/26/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reimbursement;

@interface ReimbursementCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *amtLabel;
@property (weak, nonatomic) IBOutlet UILabel *payerLabel;
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;
@property (weak, nonatomic) IBOutlet UILabel *payeeLabel;

@property (strong, nonatomic) Reimbursement *reimbursement;

@end
