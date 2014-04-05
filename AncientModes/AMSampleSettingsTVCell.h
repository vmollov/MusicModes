//
//  AMSampleSettingsTVCell.h
//  Modes Ear Trainer
//
//  Created by Vladimir Mollov on 4/5/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMSampleSettingsTVCell : UITableViewCell<UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIPickerView *pkrPlayerSample;
@property NSArray *listOfSamples;
@end
