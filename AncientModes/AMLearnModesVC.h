//
//  AMLearnModesTVCViewController.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/24/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMDataManager.h"

@interface AMLearnModesVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tblListOfModes;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;

@end
