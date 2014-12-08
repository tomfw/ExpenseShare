//
//  ExpenseChart.m
//  ExpenseShare
//
//  Created by Thomas Williams on 11/25/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import "ExpenseChart.h"
#import "ESSConnection.h"
#import "Group.h"
#import "User.h"

#define CHART_RADIUS 150

@interface ExpenseChart ()
@property (strong, nonatomic) NSArray *shares;
@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) NSArray *colors;
@end

@implementation ExpenseChart

-(void)awakeFromNib {
    [super awakeFromNib];
    self.colors = @[[UIColor redColor], [UIColor blueColor],
            [UIColor yellowColor], [UIColor greenColor], [UIColor purpleColor],
            [UIColor orangeColor], [UIColor blackColor]];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self calculateShares];
    [self drawChart:ctx inRect:rect];
    [self drawKeysUsingContext:ctx inRect:rect];
}

- (void)calculateShares {
    NSMutableArray *mUsers = [NSMutableArray array];
    NSMutableArray *mShares = [NSMutableArray array];
    double totalExpenses = [[ESSConnection connection] totalExpenses];

    for (NSNumber* key in [ESSConnection connection].group.users) {
        [mUsers addObject:[[ESSConnection connection].group.users objectForKey:key]];
    }

    for (User *user in mUsers) {
        double share = ([[ESSConnection connection] expensesForUser:user.userID] / totalExpenses) * 100;
        if(share > 100)
            share = 100;
        if(share < 0)
            share = 0;
        [mShares addObject:@(share)];

    }
    self.shares = [mShares copy];
    self.users = [mUsers copy];
}

-(void)drawChart:(CGContextRef)ref inRect:(CGRect)rect {
    CGFloat start = 0;
    for (NSUInteger i = 0; i < self.users.count; ++i) {
        CGFloat share = (CGFloat) [(NSNumber *) self.shares[i] floatValue];
        User *user = self.users[i];
        if(share) {
            [self drawWedgeOfPercent:share usingContext:ref inRect:rect fromPercent:start inColor:self.colors[i % self.colors.count]];
       }
        start += share;
    }
}

-(void)drawKeysUsingContext:(CGContextRef)ref inRect:(CGRect)rect {
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y + rect.size.height - 15;
    NSDictionary *attributes = @{@[NSFontAttributeName, NSForegroundColorAttributeName ] : @[[UIFont fontWithName:@"Helvetica" size:8.0], [UIColor blackColor]]};

    for (NSUInteger i = 0; i < self.users.count; ++i) {
        User *user = self.users[i];

        //draw the rectangle
        CGContextMoveToPoint(ref, x , y );
        CGContextAddRect(ref, CGRectMake(x, y + 3, 10, 10));
        CGContextSetFillColor(ref, CGColorGetComponents([(UIColor *) self.colors[i % self.colors.count] CGColor]));
        CGContextFillPath(ref);
        x+=20;

        //draw the text
        CGContextSaveGState(ref);
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ($%.2f)",user.userName,[[ESSConnection connection] expensesForUser:user.userID]]
                                                                   attributes:attributes];
        [text drawAtPoint:CGPointMake(x, y)];
        CGContextRestoreGState(ref);
        x += text.size.width + 10;
    }
}

-(void)drawWedgeOfPercent:(CGFloat)percent usingContext:(CGContextRef)ref inRect:(CGRect)rect fromPercent:(CGFloat)start inColor:(UIColor *)color {
    CGFloat radius = rect.size.width <= rect.size.height ? (CGFloat) (rect.size.width * .35) : (CGFloat) (rect.size.height * .35);
    CGFloat thetaStart = (CGFloat) ((2 * M_PI) * (start / 100));
    CGFloat thetaEnd = (CGFloat) ((2 * M_PI) * (percent / 100) + thetaStart);
    CGContextAddArc(ref, rect.size.width / 2, rect.size.height / 2, radius, thetaStart, thetaEnd, 0);
    CGContextAddLineToPoint(ref, rect.size.width / 2, rect.size.height / 2);
    CGContextSetFillColor(ref, CGColorGetComponents([color CGColor]));
    CGContextFillPath(ref);
}

@end
