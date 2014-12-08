//
// Created by Thomas Williams on 11/5/14.
// Copyright (c) 2014 Thomas Williams. All rights reserved.
//
//


#import "ESSConnection.h"
#import "GCDAsyncSocket.h"
#import "ESPacket.h"
#import "Group.h"
#import "Reimbursement.h"
#import "Expense.h"

#define TAG_WRITE_USER_ID 1
#define TAG_SEND_PACKET 4

@interface ESSConnection () <GCDAsyncSocketDelegate>
@property(nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic) NSInteger userID;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger lastHash;
@property (strong, nonatomic) NSArray *groups;
@property (strong, nonatomic) NSArray *expenses;
@property (strong, nonatomic) NSArray *reimbursements;
@end

@implementation ESSConnection
static ESSConnection *_connection = nil;

-(double)expensesForUser:(NSInteger)userID {
    double results = 0;

    for (Expense *expense in self.expenses) {
        if (expense.userID == userID) {
            results += expense.amount;
        }
    }

    for (Reimbursement *reimbursement in self.reimbursements) {
        if (reimbursement.payerID == userID) {
            results += reimbursement.amount;
        }
        if (reimbursement.payeeID == userID) {
            results -= reimbursement.amount;
        }
    }

    return results;
}

-(double)totalExpenses {
    double result = 0;
    double rmbs = 0;
    for (Reimbursement *reimbursement in self.reimbursements) {
        rmbs += reimbursement.amount;
    }
    for (Expense *expense in self.expenses) {
        result += expense.amount;
    }
    if(rmbs > result) {
        result += rmbs - result;
    }
    return result;
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {

    NSMutableData *message = [[NSMutableData alloc] initWithData:data];
    NSRange range = NSMakeRange(message.length - 4, 4);
    [message replaceBytesInRange:range withBytes:NULL length:0];
    BOOL updated = NO;

    if(tag == TAG_READ_PACKET) {
        ESPacket *packet = [NSKeyedUnarchiver unarchiveObjectWithData:message];
        if (packet.code == ESPACKET_UPDATE_HASH) {
            NSInteger hash = [(NSNumber*)packet.object integerValue];
            if(hash != self.lastHash) {
                self.lastHash = hash;
                [self sendPacket:[ESPacket packetWithCode:ESPACKET_REQUEST_TRANSACTIONS object:nil]];
                [self readPacket]; //read expenses
                [self readPacket]; //read reimbursements
            }
        } else if (packet.code == ESPACKET_EXPENSES) {
            updated = YES;
            self.expenses = (NSArray*)packet.object;
        } else if (packet.code == ESPACKET_REIMBURSEMENTS) {
            updated = YES;
            self.reimbursements = (NSArray*)packet.object;
        } else if (packet.code == ESPACKET_GROUPS) {
            NSArray *newList = (NSArray*)packet.object;
            if([self updateGroups: newList])
                updated= YES;
        } else {
            //this request was probably initiated by our delegate!
            //give him (or her) the response
            [self.delegate readPacket:packet onConnection:self];
        }

        if(updated && [self.delegate respondsToSelector:@selector(updateMadeOnConnection:)]) {
            [self.delegate updateMadeOnConnection:self];
        }
    }
}

- (BOOL)updateGroups:(NSArray *)groupList {
    if ([self areGroups:self.groups equalToGroups:groupList]) {
        return NO;
    }
    self.groups = groupList;
    for (Group *group in self.groups) {
        if (group.grpID == self.group.grpID)
            self.group = group;
    }
    return YES;
}
-(BOOL)areGroups:(NSArray *)groups equalToGroups:(NSArray *)otherGroups {
    if(!groups || !otherGroups)
        return NO;
    if(groups.count != otherGroups.count)
        return NO;

    NSInteger members1 = 0;
    NSInteger members2 = 0;

    for (Group *group in groups) {
        members1 += group.users.count;
    }
    for (Group *group in otherGroups) {
        members2 +=group.users.count;
    }

    return members1 == members2;
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    if(tag == TAG_WRITE_USER_ID)
        NSLog(@"Sent user id");
    if(tag == TAG_SEND_PACKET)
        NSLog(@"Packet sent.");
}

-(void)sendPacket:(ESPacket *)packet {
//    if(!self.isConnected)
//        [self connect];
    [packet sendOnSocket:self.socket withTimeOut:30];
}

-(void)readPacket {
    [ESPacket readOnSocket:self.socket withTimeOut:30];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"We are connnnnnnected!");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(update) userInfo:nil repeats:YES];
    });
}

-(void)reload {
    self.lastHash = 0;
    [self update];
}

- (void)update {
    if(self.group) {
        [self sendPacket:[ESPacket packetWithCode:ESPACKET_REQUEST_UPDATE object:@(self.group.grpID)]];
        [self readPacket];
        [self sendPacket:[ESPacket packetWithCode:ESPACKET_REQUEST_GROUPS object:nil]];
        [self readPacket];
    } else {
        [self sendPacket:[ESPacket packetWithCode:ESPACKET_REQUEST_GROUPS object:nil]];
        [self readPacket];
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
        if (![self.socket connectToHost:@"tomfw.it.cx" onPort:7373 error:&error]) {
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