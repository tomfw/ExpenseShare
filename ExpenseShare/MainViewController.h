//
//  MainViewController.h
//  ExpenseShare
//
//  Created by Thomas Williams on 11/2/14.
//  Copyright (c) 2014 Thomas Williams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESSConnection.h"

@class Group;
@class ExpenseChart;

@interface MainViewController : UIViewController <ESSConnectionDelegate>
@property (weak, nonatomic) IBOutlet ExpenseChart *chart;
@property (strong, nonatomic) Group *group;
@end
