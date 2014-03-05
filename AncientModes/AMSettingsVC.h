//
//  AMSettingsViewController.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/20/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMSettingsVC : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIPickerView *pkrPlayerSample;
@property (strong, nonatomic) IBOutlet UITableView *tblModeSettings;

@end
