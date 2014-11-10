//
// Created by Thomas Williams on 11/10/14.
// Copyright (c) 2014 Thomas Williams. All rights reserved.
//
//


#import "User.h"

@interface User ()
@property (nonatomic) NSInteger userID;
@property (strong, nonatomic) NSString *userName;
@end

@implementation User

#pragma mark - Coding

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.userID forKey:@"userID"];
    [coder encodeObject:self.userName forKey:@"userName"];
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _userID = [coder decodeIntForKey:@"userID"];
        _userName = [coder decodeObjectForKey:@"userName"];
    }
    return self;
}

#pragma mark  - Initializing

+(User*)userWithName:(NSString *)name {
    User *new = [[User alloc] init];
    new.userName = name;
    return new;
}

+(User*)userWithID:(NSInteger)userID {
    User *new = [[User alloc] init];
    new.userID = userID;
    return new;
}

@end