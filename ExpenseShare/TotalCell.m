//
//  TotalCell.m
//  ExpenseShare
//
//  Created by Thomas Williams on 11/26/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import "TotalCell.h"

@implementation TotalCell

-(void)setAmount:(double)amount userName:(NSString *)name share:(double)share {
    self.amountLabel.text = [NSString stringWithFormat:@"$%.2f", amount];
    self.shareLabel.text = [NSString stringWithFormat:@"(%.1f%%)", share];
    self.userLabel.text = name;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
