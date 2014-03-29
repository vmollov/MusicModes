//
//  AMEndTestVC.h
//  AncientModes
//
//  Created by Vladimir Mollov on 3/1/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMEarTest.h"
#import "AMTestSummaryVC.h"

@interface AMEndTestVC : UIViewController
@property (strong, nonatomic) IBOutlet UIView *vwResults;
@property (strong, nonatomic) IBOutlet UILabel *lbFinalScore;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;

@property AMEarTest *test;
@property AMTestSummaryVC *summaryTable;
@property int questions;
@end
