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
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation ESSConnection
static ESSConnection *_connection = nil;

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {

    NSMutableData *message = [[NSMutableData alloc] initWithData:data];
    NSRange range = NSMakeRange(message.length - 4, 4);
    [message replaceBytesInRange:range withBytes:NULL length:0];

    if(tag == TAG_READ_PACKET) {
        ESPacket *packet = [NSKeyedUnarchiver unarchiveObjectWithData:message];
        if (packet.code == ESPACKET_UPDATE_HASH) {
            NSLog(@"Got the hash for the current group:%@",packet.object);
        }
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
    [packet sendOnSocket:self.socket withTimeOut:30];
}

-(void)readPacket {
    [ESPacket readOnSocket:self.socket withTimeOut:30];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"We are connnnnnnected!");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(update) userInfo:nil repeats:YES];
    });
}

- (void)update {
    NSLog(@"Hello? update?");
    if(self.grpID > 1) {
        NSLog(@"We need to update some stuff!");
        [self sendPacket:[ESPacket packetWithCode:ESPACKET_REQUEST_UPDATE object:@(self.grpID)]];
        [self readPacket];
    } else {
        [self sendPacket:[ESPacket packetWithCode:ESPACKET_OK object:nil]];
    }
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
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@(self.userID)];
        NSMutableData *message = [[NSMutableData alloc] initWithData:data];
        [message appendData:[ESPacket terminator]];
        [self.socket writeData:message withTimeout:30 tag:TAG_WRITE_USER_ID];
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