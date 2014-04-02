//
//  AMSettingsViewController.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/20/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMSettingsVC.h"
#import "AMDataManager.h"
#import "AMScalesPlayer.h"
#import "AMModesSettingsTVCell.h"
#import "UIViewController+Parallax.h"

@interface AMSettingsVC ()
@property NSArray *listOfSamples, *listOfModes;
@end

@implementation AMSettingsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setParallaxToView:self.imgBackground];
    
    //set up the purchase controller
    _purchaseController = [[AMPurchaseVC alloc] init];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:_purchaseController];
    
    //set up the table view
    self.listOfModes = [[AMDataManager getInstance] getListOfAllModesUseDisplayName:NO grouped:YES];
    self.tblModeSettings.delegate = self;
    self.tblModeSettings.dataSource = self;
    //set the background
    self.tblModeSettings.backgroundColor = [UIColor clearColor];

    
	//set up the sample picker view
    self.listOfSamples = [[AMDataManager getInstance] getListOfSamples];
    self.pkrPlayerSample.delegate = self;
    self.pkrPlayerSample.dataSource = self;
    //set the initial state
    NSInteger selectedIndex = [self.listOfSamples indexOfObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"playSample"]];
    [self.pkrPlayerSample selectRow:selectedIndex inComponent:0 animated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [self.tblModeSettings flashScrollIndicators];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)purchaseModes{
    _purchaseController.productID = [[AMDataManager getInstance] getTier1ProductID];
    [self.navigationController  presentViewController:_purchaseController animated:YES completion:nil];
    [_purchaseController getProductInfo: self];
}

#pragma mark - UITableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return self.listOfModes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [[self.listOfModes objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"scalesCell";
    AMModesSettingsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell ==nil) cell = [[AMModesSettingsTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    NSString *currentMode = [[self.listOfModes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.lbMode.text = currentMode;
    cell.swModeSetting.on = [[NSUserDefaults standardUserDefaults] boolForKey:currentMode];
    BOOL isModeAvailable = [[AMDataManager getInstance]isModeAvailable:currentMode];
    if (isModeAvailable) cell.lbOn.text = cell.swModeSetting.on?@"Used":@"Not Used";
    else cell.lbOn.text = @"Requires a Purchase";
    cell.mode = currentMode;
    cell.parentVC = self;
    
    cell.backgroundColor =[UIColor clearColor];
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[AMDataManager getInstance] getNameForGroupId:(int)section + 1];
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
    [[AMScalesPlayer getInstance] loadSample:[self.listOfSamples objectAtIndex:row]];
}
@end
