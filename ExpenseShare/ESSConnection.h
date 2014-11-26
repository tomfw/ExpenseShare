//
// Created by Thomas Williams on 11/5/14.
// Copyright (c) 2014 Thomas Williams. All rights reserved.
//
//


#import <Foundation/Foundation.h>

@class ESPacket;
@class ESSConnection;
@class Group;

@protocol ESSConnectionDelegate <NSObject>
-(void)readPacket:(ESPacket *)packet onConnection:(ESSConnection *)connection;
@optional
-(void)updateMadeOnConnection:(ESSConnection *)connection;
@end

@interface ESSConnection : NSObject

@property (readonly) BOOL isConnected;
@property (readonly, nonatomic) NSInteger userID;
@property (weak, nonatomic) id <ESSConnectionDelegate>delegate;

@property (readonly, nonatomic) NSArray *expenses ;
@property (readonly, nonatomic) NSArray *reimbursements;
@property (readonly, nonatomic) NSArray *groups;
@property(nonatomic, strong) Group *group;

+ (ESSConnection *)connection;
- (double)expensesForUser:(NSInteger)userID;
- (double)totalExpenses; //total expenses for the current group....
- (void)sendPacket:(ESPacket *)packet;
- (void)readPacket;
- (void)reload;
- (void)disconnect;
- (void)connect;
@end