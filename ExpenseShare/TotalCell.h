//
//  TotalCell.h
//  ExpenseShare
//
//  Created by Thomas Williams on 11/26/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TotalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;

- (void)setAmount:(double)amount userName:(NSString *)name share:(double)share;
@end
