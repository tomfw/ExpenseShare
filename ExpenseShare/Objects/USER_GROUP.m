//
// Created by Thomas Williams on 11/10/14.
// Copyright (c) 2014 Thomas Williams. All rights reserved.
//
//


#import "User_Group.h"

@interface User_Group ()
@property (nonatomic) NSInteger userID;
@property (nonatomic) NSInteger grpID;
@end

@implementation User_Group
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.userID forKey:@"userID"];
    [coder encodeInteger:self.grpID forKey:@"grpID"];
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _userID = [coder decodeIntegerForKey:@"userID"];
        _grpID = [coder decodeIntegerForKey:@"grpID"];
    }
    return self;
}

+ (User_Group *)userGroupWithUser:(NSInteger)userID {
    User_Group *new = [[User_Group alloc] init];
    new.userID = userID;
    return new;
}

+ (User_Group *)userGroupWithUser:(NSInteger)userID inGroup:(NSInteger)grpID {
    User_Group *new = [User_Group userGroupWithUser:userID];
    new.grpID = grpID;
    return new;
}

@end
