//
//  AMModesSettingsVC.h
//  Modes Ear Trainer
//
//  Created by Vladimir Mollov on 4/16/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMModesSettingsVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;
@property (strong, nonatomic) IBOutlet UITableView *tblListOfModes;

- (void)purchaseAdvancedModes;
@end
