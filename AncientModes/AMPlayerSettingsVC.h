//
//  AMSettingsViewController.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/20/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMPlayerSettingsVC : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UISwitch *swAscending;
@property (strong, nonatomic) IBOutlet UISwitch *swDescending;
@property (strong, nonatomic) IBOutlet UIPickerView *pkrPlayerSample;
- (IBAction)changeScaleDirectionSetting:(id)sender;

@end
