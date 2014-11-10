//
// Created by Thomas Williams on 11/10/14.
// Copyright (c) 2014 Thomas Williams. All rights reserved.
//
//


#import "Expense.h"

@interface Expense ()
@property (nonatomic) NSInteger expenseID;
@end

@implementation Expense

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.expenseID forKey:@"expenseID"];
    [coder encodeInteger:self.grpID forKey:@"grpID"];
    [coder encodeInteger:self.userID forKey:@"userID"];
    [coder encodeObject:self.item forKey:@"item"];
    [coder encodeDouble:self.amount forKey:@"amount"];
    [coder encodeObject:self.memo forKey:@"memo"];
    [coder encodeInteger:self.month forKey:@"month"];
    [coder encodeInteger:self.year forKey:@"year"];
    //encode receipt
}

- (id)initWithCoder:(NSCoder *)coder {
    if(self = [super init]) {
        _expenseID = [coder decodeIntegerForKey:@"expenseID"];
        _grpID = [coder decodeIntegerForKey:@"grpID"];
        _userID = [coder decodeIntegerForKey:@"userID"];
        _item = [coder decodeObjectForKey:@"item"];
        _amount = [coder decodeDoubleForKey:@"amount"];
        _memo = [coder decodeObjectForKey:@"memo"];
        _month = [coder decodeIntegerForKey:@"month"];
        _year = [coder decodeIntegerForKey:@"year"];
        //decode receipt
    }
    return self;
}

+ (Expense *)expenseInGroup:(NSInteger)grpID byUser:(NSInteger)userID {
    Expense *new = [Expense expenseWithID:-1];
    new.grpID = grpID;
    new.userID = userID;
    return new;
}

+ (Expense *)expenseWithID:(NSInteger)expenseID {
    Expense *new = [[Expense alloc] init];
    new.expenseID = expenseID;
    return new;
}


@end