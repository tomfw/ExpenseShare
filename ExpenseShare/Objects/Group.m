//
// Created by Thomas Williams on 11/10/14.
// Copyright (c) 2014 Thomas Williams. All rights reserved.
//
//


#import "Group.h"

@interface Group ()
@property (nonatomic) NSInteger grpID;
@property (strong, nonatomic) NSString *grpName;
@property (strong, nonatomic) NSString *grpDescription;
@property (strong, nonatomic) NSMapTable *users;
@end

@implementation Group
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.grpID forKey:@"grpID"];
    [coder encodeObject:self.grpName forKey:@"grpName"];
    [coder encodeObject:self.grpDescription forKey:@"grpDescription"];
    [coder encodeObject:self.users forKey:@"users"];
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _grpID = [coder decodeIntegerForKey:@"grpID"];
        _grpName = [coder decodeObjectForKey:@"grpName"];
        _grpDescription = [coder decodeObjectForKey:@"grpDescription"];
        _users = [coder decodeObjectForKey:@"users"];
    }
    return self;
}

+ (Group *)groupWithName:(NSString *)name description:(NSString *)description {
    Group *new = [self groupWithID:-1];
    new.grpName = name;
    new.grpDescription = description;
    return new;
}

+ (Group *)groupWithID:(NSInteger)id {
    Group *new = [[Group alloc] init];
    new.grpID = id;
    return new;
}

@end