//
//  ReimbursementCell.m
//  ExpenseShare
//
//  Created by Thomas Williams on 11/26/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import "ReimbursementCell.h"
#import "Reimbursement.h"
#import "ESSConnection.h"
#import "Group.h"
#import "User.h"


@implementation ReimbursementCell

- (void)setReimbursement:(Reimbursement *)reimbursement {
    _reimbursement = reimbursement;
    ESSConnection *connection = [ESSConnection connection];
    User *payer = [connection.group.users objectForKey:@(reimbursement.payerID)];
    User *payee = [connection.group.users objectForKey:@(reimbursement.payeeID)];

    self.amtLabel.text = [NSString stringWithFormat:@"$%.2f", reimbursement.amount];
    self.payeeLabel.text = payee.userName;
    self.payerLabel.text = payer.userName;
    self.memoLabel.text = reimbursement.memo;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
