//
//  AMTestSummaryVC.h
//  AncientModes
//
//  Created by Vladimir Mollov on 3/3/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMTestSummaryVC : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *lbQuestions;
@property (strong, nonatomic) IBOutlet UILabel *lbAnswered;
@property (strong, nonatomic) IBOutlet UILabel *lbHints;
@end
