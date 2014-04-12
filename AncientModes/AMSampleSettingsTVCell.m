//
//  AMSampleSettingsTVCell.m
//  Modes Ear Trainer
//
//  Created by Vladimir Mollov on 4/5/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMSampleSettingsTVCell.h"
#import "AMDataManager.h"
#import "AMScalesPlayer.h"

@implementation AMSampleSettingsTVCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
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

#pragma mark - UIPicker Delegates
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 3;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *lbNumber = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 45)];
    lbNumber.text = [NSString stringWithFormat:@"%@", [self.listOfSamples objectAtIndex:row]];
    lbNumber.textColor = [UIColor whiteColor];
    lbNumber.textAlignment=NSTextAlignmentCenter;
    lbNumber.font = [UIFont fontWithName:@"Verdana" size:21];
    
    return lbNumber;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [[NSUserDefaults standardUserDefaults] setObject:[self.listOfSamples objectAtIndex:row] forKey:@"playSample"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[AMScalesPlayer getInstance] loadSample:[self.listOfSamples objectAtIndex:row]];
}

@end
