//
//  AMTestSettingsTVCell.h
//  Modes Ear Trainer
//
//  Created by Vladimir Mollov on 4/10/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMTestSettingsTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UISwitch *swRandomStartingNote;
@property (strong, nonatomic) IBOutlet UISwitch *swTestOutOf8;

- (IBAction)changeStartingNote:(id)sender;
- (IBAction)changeTestOutOf8:(id)sender;
@end
