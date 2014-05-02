//
//  AMTestSettingsTVCell.m
//  Modes Ear Trainer
//
//  Created by Vladimir Mollov on 4/10/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMTestSettingsTVCell.h"
#import "AMDataManager.h"

@implementation AMTestSettingsTVCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)changeStartingNote:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:!self.swRandomStartingNote.on forKey:@"ChallengeOnSameNote"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)changeTestOutOf8:(id)sender {
    if(self.swTestOutOf8  && ([[[AMDataManager getInstance] getListOfEnabledModes] count] < 8)){
        //not enough modes are turned on
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Too Few Modes" message:@"You need to have 8 or more modes in use for this option.  Enable more modes in the \"Choose Modes to Test\" section." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
    }
    [[NSUserDefaults standardUserDefaults] setBool: self.swTestOutOf8.on forKey:@"testOutOf8Answers"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0) {
        self.swTestOutOf8.on = NO;
    }
}
@end
