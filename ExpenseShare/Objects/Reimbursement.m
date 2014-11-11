//
// Created by Thomas Williams on 11/10/14.
// Copyright (c) 2014 Thomas Williams. All rights reserved.
//
//


#import "Reimbursement.h"

@interface Reimbursement ()
@property (nonatomic) NSInteger reimbursementID;
@property (nonatomic) NSInteger payerID;
@property (nonatomic) NSInteger payeeID;
@property (nonatomic) NSInteger grpID;
@end

@implementation Reimbursement
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.reimbursementID forKey:@"reimbursementID"];
    [coder encodeInteger:self.payerID forKey:@"payerID"];
    [coder encodeInteger:self.payeeID forKey:@"payeeID"];
    [coder encodeInteger:self.grpID forKey:@"grpID"];
    [coder encodeDouble:self.amount forKey:@"amount"];
    [coder encodeObject:self.memo forKey:@"memo"];
    [coder encodeInteger:self.month forKey:@"month"];
    [coder encodeInteger:self.year forKey:@"year"];
}


- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _reimbursementID = [coder decodeIntegerForKey:@"reimbursementID"];
        _payerID = [coder decodeIntegerForKey:@"payerID"];
        _payeeID = [coder decodeIntegerForKey:@"payeeID"];
        _grpID = [coder decodeIntegerForKey:@"grpID"];
        _amount = [coder decodeDoubleForKey:@"amount"];
        _memo = [coder decodeObjectForKey:@"memo"];
        _month = [coder decodeIntegerForKey:@"month"];
        _year = [coder decodeIntegerForKey:@"year"];
    }
    return self;
}

+ (Reimbursement *)reimbursementFrom:(NSInteger)payerID to:(NSInteger)payeeID inGroup:(NSInteger)grpID {
    Reimbursement *new = [Reimbursement reimbursementWithID:-1];
    new.payerID = payerID;
    new.payeeID = payeeID;
    new.grpID = grpID;
    return new;
}

+ (Reimbursement *)reimbursementWithID:(NSInteger)id {
    Reimbursement *new = [[Reimbursement alloc] init];
    new.reimbursementID = id;
    return new;
}

@end