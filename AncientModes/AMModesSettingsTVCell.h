//
//  AMModesSettingsTableViewCell.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/21/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMModesSettingsTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbMode;
@property (strong, nonatomic) IBOutlet UISwitch *swModeSetting;

@property NSString *mode;

- (IBAction)changeModeUseSetting:(id)sender;
@end
