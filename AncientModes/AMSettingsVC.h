//
//  AMSettingsViewController.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/20/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <StoreKit/StoreKit.h>
#import "AMPurchaseVC.h"

@interface AMSettingsVC : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;
@property (strong, nonatomic) IBOutlet UIPickerView *pkrPlayerSample;
@property (strong, nonatomic) IBOutlet UITableView *tblModeSettings;

@property (strong, nonatomic) AMPurchaseVC *purchaseController;

-(void)purchaseModes;
-(void)enableAdvancedModes;
@end
