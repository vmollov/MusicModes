//
//  AMSettingsViewController.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/20/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMPlayerSettingsVC.h"
#import "AMDataManager.h"
#import "AMScalesPlayer.h"

@interface AMPlayerSettingsVC ()
@property NSArray *listOfSamples;
@end

@implementation AMPlayerSettingsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.listOfSamples = [[AMDataManager getInstance] getListOfSamples];
    self.pkrPlayerSample.delegate = self;
    self.pkrPlayerSample.dataSource = self;
    
    //set the initial state
    self.swAscending.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"playAscending"];
    self.swDescending.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"playDescending"];
    NSInteger selectedIndex = [self.listOfSamples indexOfObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"playSample"]];
    [self.pkrPlayerSample selectRow:selectedIndex inComponent:0 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Action Handlers
- (IBAction)changeScaleDirectionSetting:(id)sender {
    UISwitch *trigger = sender;
   
    if(trigger.tag==0) [[NSUserDefaults standardUserDefaults] setBool:trigger.on forKey:@"playAscending"];
    if(trigger.tag==1) [[NSUserDefaults standardUserDefaults] setBool:trigger.on forKey:@"playDescending"];
}

#pragma mark - UIPicker Delegates
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 3;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.listOfSamples objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [[NSUserDefaults standardUserDefaults] setObject:[self.listOfSamples objectAtIndex:row] forKey:@"playSample"];
    [[AMScalesPlayer getInstance] loadSample:[self.listOfSamples objectAtIndex:row]];
}
@end
