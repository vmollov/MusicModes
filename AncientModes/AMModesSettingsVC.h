//
//  AMModesSettingsViewController.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/21/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMModesSettingsVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tblModes;

@end
