//
//  AMStatisticsByModeDetailVC.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/27/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMStatisticsGraphV.h"

@interface AMStatisticsByModeDetailVC : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lbMode;
@property (strong, nonatomic) IBOutlet UILabel *lbAverage;
@property (strong, nonatomic) IBOutlet AMStatisticsGraphV *vwGraph;

@property NSDictionary *data;
@property NSString *modeName;
@end
