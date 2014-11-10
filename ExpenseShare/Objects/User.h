//
// Created by Thomas Williams on 11/10/14.
// Copyright (c) 2014 Thomas Williams. All rights reserved.
//
//


#import <Foundation/Foundation.h>


@interface User : NSObject <NSCoding>


@property (readonly, nonatomic) NSInteger userID;
@property (readonly, nonatomic) NSString *userName;

+ (User *)userWithName:(NSString *)name;
+ (User *)userWithID:(NSInteger)userID;


@end