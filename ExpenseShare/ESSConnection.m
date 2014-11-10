//
// Created by Thomas Williams on 11/5/14.
// Copyright (c) 2014 Thomas Williams. All rights reserved.
//
//


#import "ESSConnection.h"
#import "GCDAsyncSocket.h"
#import "ESPacket.h"

#define TAG_WRITE_USER_ID 1
#define TAG_SEND_PACKET 4

@interface ESSConnection () <GCDAsyncSocketDelegate>
@property(nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic) NSInteger userID;
@end

@implementation ESSConnection
static ESSConnection *_connection = nil;

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    if(tag == TAG_READ_PACKET) {
        ESPacket *packet = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self.delegate readPacket:packet onConnection:self];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    if(tag == TAG_WRITE_USER_ID)
        NSLog(@"Sent user id");
    if(tag == TAG_SEND_PACKET)
        NSLog(@"Packet sent.");
}

-(void)sendPacket:(ESPacket *)packet {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:packet];
    [self.socket writeData:data withTimeout:30 tag:TAG_SEND_PACKET];
}

-(void)readPacket {
    [self.socket readDataWithTimeout:30 tag:TAG_READ_PACKET];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"We are connnnnnnected!");
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@(self.userID)];
    [sock writeData:data withTimeout:30 tag:TAG_WRITE_USER_ID];
}
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    if (err) {
        NSLog(@"Error: %@",err);
    } else {
        NSLog(@"Disconnected!");
    }
    self.socket = nil;
}

- (NSInteger)userID {
    if(!_userID) {
        _userID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] integerValue];
    }
    return _userID;
}

-(BOOL)isConnected {
    return [self.socket isConnected];
}

-(void)disconnect {
    [self.socket disconnectAfterReadingAndWriting];
}

-(void)connect {
    if(!self.isConnected) {
        dispatch_queue_t delegateQueue = dispatch_queue_create("delegateQueue", NULL);
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:delegateQueue];
        NSError *error = nil;
        if (![self.socket connectToHost:@"192.168.1.254" onPort:7373 error:&error]) {
            NSLog(@"Error connecting: %@", error);
        }
    } else {
        NSLog(@"Already connected!");
    }
}

+(ESSConnection *)connection {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _connection = [[self alloc] init];
    });
    return _connection;
}
@end