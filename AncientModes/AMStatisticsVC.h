//
//  AMStatisticsVC.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/24/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMStatisticsGraphV.h"

@interface AMStatisticsVC : UIViewController
@property (strong, nonatomic) IBOutlet AMStatisticsGraphV *grphOverall;
@property (strong, nonatomic) IBOutlet UILabel *lbAverage;

@end
