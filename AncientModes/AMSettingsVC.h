//
//  AMSettingsNewVC.h
//  Modes Ear Trainer
//
//  Created by Vladimir Mollov on 4/4/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "AMPurchaseVC.h"


@interface AMSettingsVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;
@property (strong, nonatomic) IBOutlet UITableView *tblContent;

//@property (strong, nonatomic) AMPurchaseVC *purchaseController;

- (IBAction)purchaseAdvancedModes:(id)sender;
- (IBAction)purchaseRemoveAds:(id)sender;
- (IBAction)restorePurchases:(id)sender;
@end
