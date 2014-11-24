//
// Created by Thomas Williams on 11/5/14.
// Copyright (c) 2014 Thomas Williams. All rights reserved.
//
//


#import <Foundation/Foundation.h>

@class ESPacket;
@class ESSConnection;

@protocol ESSConnectionDelegate
-(void)readPacket:(ESPacket *)packet onConnection:(ESSConnection *)connection;
@end

@interface ESSConnection : NSObject

@property (readonly) BOOL isConnected;
@property (readonly, nonatomic) NSInteger userID;
@property (nonatomic) NSInteger grpID;
@property (weak, nonatomic) id <ESSConnectionDelegate>delegate;

+ (ESSConnection *)connection;
- (void)sendPacket:(ESPacket *)packet;
- (void)readPacket;
- (void)disconnect;
- (void)connect;
@end