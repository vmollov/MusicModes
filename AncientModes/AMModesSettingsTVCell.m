//
//  AMModesSettingsTableViewCell.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/21/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMModesSettingsTVCell.h"
#import "AMDataManager.h"

@implementation AMModesSettingsTVCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)changeModeUseSetting:(id)sender {
    if (![[AMDataManager getInstance]isModeAvailable:self.mode]) {
        self.swModeSetting.on = NO;
        [self.parentVC purchaseAdvancedModes:nil];
        return;
    }
    
    if(![[AMDataManager getInstance] mode:self.mode setEnabled:self.swModeSetting.on]){
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Too Few Modes" message:@"You need to have at least 4 modes selected for testing" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    self.lbOn.text = self.swModeSetting.on?@"Used":@"Not Used";
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0) {
        self.swModeSetting.on = YES;
        self.lbOn.text = @"Used";
    }
}
@end
