//
// Created by Thomas Williams on 11/10/14.
// Copyright (c) 2014 Thomas Williams. All rights reserved.
//
//


#import <Foundation/Foundation.h>


@interface User_Group : NSObject <NSCoding>
@property(readonly, nonatomic) NSInteger userID;
@property(readonly, nonatomic) NSInteger grpID;

+ (User_Group *)userGroupWithUser:(NSInteger)userID;
+ (User_Group *)userGroupWithUser:(NSInteger)userID inGroup:(NSInteger)grpID;
@end