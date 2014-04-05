//
//  AMSettingsNewVC.m
//  Modes Ear Trainer
//
//  Created by Vladimir Mollov on 4/4/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMSettingsNewVC.h"
#import "AMDataManager.h"
#import "AMScalesPlayer.h"
#import "AMModesSettingsTVCell.h"
#import "UIViewController+Parallax.h"

static NSString *kPlayBackInstrumentCellID = @"cPlayBackInstrument";
static NSString *kPlayBackInstrumentPickerCellID = @"cPlayBackInstrumentPicker";
static NSString *kModesToUseCellID = @"cChooseModesToUse";
static NSString *kModesToUseTableCellID = @"cModesToUseTableCell";
static NSString *kEnableAdvancedModesCellID = @"cEnableAdvancedModes";
static NSString *kRemoveAdsCellID = @"cRemoveAds";

static int kPkrPlayerSampleTag = 1;
static int kTblModeSettingsTag = 2;
static int kPkrPlayerSampleIndexPathRow = 1;
static int kTblModeSettingsIndexPathRow = 2;

static int kContentTableNumberOfSections = 3;

@interface AMSettingsNewVC ()
@property NSArray *listOfSamples, *listOfModes;

@property UIPickerView *pkrPlayerSample;
@property float playerSamplePickerHeight;
@property (strong) UITableView *tblModeSettings;
@property float modeSettingsTableHeight;

@property BOOL samplePickerIsShown, modeSettingsTableIsShown;
@end

@implementation AMSettingsNewVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
}
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setParallaxToView:self.imgBackground];
    
    //set up the purchase controller
    _purchaseController = [[AMPurchaseVC alloc] init];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:_purchaseController];
    
    self.tblContent.backgroundColor = [UIColor clearColor];
    
    //setup the data
    self.listOfModes = [[AMDataManager getInstance] getListOfAllModesUseDisplayName:NO grouped:YES];
    self.listOfSamples = [[AMDataManager getInstance] getListOfSamples];
    
    //get the modes table view height
    UITableViewCell *cellToCheck = [self.tblContent dequeueReusableCellWithIdentifier:kModesToUseTableCellID];
    self.modeSettingsTableHeight = cellToCheck.frame.size.height;
         
    //get the sample picker view height
    cellToCheck = [self.tblContent dequeueReusableCellWithIdentifier:kPlayBackInstrumentPickerCellID];
    self.playerSamplePickerHeight = cellToCheck.frame.size.height;
    self.pkrPlayerSample = (UIPickerView *)[cellToCheck viewWithTag:kPkrPlayerSampleTag];
    
    //set the initial state
    NSInteger selectedIndex = [self.listOfSamples indexOfObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"playSample"  ]];
    
    [self pickerView:self.pkrPlayerSample didSelectRow:selectedIndex inComponent:0];
     
    self.tblContent.backgroundColor = [UIColor clearColor];
    
    [self.tblContent flashScrollIndicators];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(BOOL)embededViewIsShown{
    return (self.samplePickerIsShown || self.modeSettingsTableIsShown);
}

-(void)purchaseModes{
    _purchaseController.productID = [[AMDataManager getInstance] getIdForProductPurchase:@"AdvancedModesProductID"];
    _purchaseController.productKey = @"enableAdvancedModes";
    [self.navigationController presentViewController:_purchaseController animated:YES completion:nil];
    [_purchaseController getProductInfo: self];
}

#pragma mark - UITableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView.tag == kTblModeSettingsTag) {
        tableView.backgroundColor = [UIColor clearColor];
        return self.listOfModes.count;
    }else return kContentTableNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag == kTblModeSettingsTag) return [[self.listOfModes objectAtIndex:section] count];
    else if(section == 0)return [self embededViewIsShown]?3:2;
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    if(tableView.tag == kTblModeSettingsTag) cell = [self cellForModeSettingsTable:tableView ForIndexPath:indexPath];
    else{
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {
                    cell= [tableView dequeueReusableCellWithIdentifier:kPlayBackInstrumentCellID];
                    break;
                }
                if ([self embededViewIsShown]){
                    if(indexPath.row == kPkrPlayerSampleIndexPathRow)  cell = [tableView dequeueReusableCellWithIdentifier:kPlayBackInstrumentPickerCellID];
                    else if(indexPath.row == kTblModeSettingsIndexPathRow) cell = [tableView dequeueReusableCellWithIdentifier:kModesToUseTableCellID];
                    else{
                        cell = [tableView dequeueReusableCellWithIdentifier:kModesToUseCellID];
                    }
                }else cell = [tableView dequeueReusableCellWithIdentifier:kModesToUseCellID];
                break;
            case 1:
                cell = [tableView dequeueReusableCellWithIdentifier:kEnableAdvancedModesCellID];
                break;
            case 2:
                cell = [tableView dequeueReusableCellWithIdentifier:kRemoveAdsCellID];
            default:
                break;
        }
    }
    
    cell.backgroundColor =[UIColor clearColor];
    
    return cell;
}
-(UITableViewCell *)cellForModeSettingsTable:(UITableView *) tableView ForIndexPath:(NSIndexPath *)indexPath{
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
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView.tag == kTblModeSettingsTag) return [[AMDataManager getInstance] getNameForGroupId:(int)section + 1];
    else return @"";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag != kTblModeSettingsTag){
        [self.tblContent beginUpdates];
        
        if([self embededViewIsShown]){
            if(self.samplePickerIsShown){
                [self hidePlayerSamplePicker];
                if(indexPath.row == kTblModeSettingsIndexPathRow)[self showModeSettingsTable];
            }else if(self.modeSettingsTableIsShown){
                [self hideModeSettingsTable];
                if(indexPath.row == kPkrPlayerSampleIndexPathRow - 1)[self showPlayerSamplePicker];
            }
        }else{
            if(indexPath.section == 0){
                switch (indexPath.row) {
                    case 0:
                        [self showPlayerSamplePicker];
                        break;
                    case 1:
                        [self showModeSettingsTable];
                        break;
                    default:
                        break;
                }
            }
        }
        [self.tblContent deselectRowAtIndexPath:indexPath animated:YES];        
        [self.tblContent endUpdates];
    }
    
}

-(void)hidePlayerSamplePicker{
    if(self.samplePickerIsShown){
        [self.tblContent deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kPkrPlayerSampleIndexPathRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.samplePickerIsShown = NO;
    }
}
-(void)showPlayerSamplePicker{
    if(!self.samplePickerIsShown){
        [self.tblContent insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kPkrPlayerSampleIndexPathRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.samplePickerIsShown = YES;
    }
}
-(void)hideModeSettingsTable{
    if(self.modeSettingsTableIsShown){
        [self.tblContent deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kTblModeSettingsIndexPathRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.modeSettingsTableIsShown = NO;
    }
}
-(void)showModeSettingsTable{
    if(!self.modeSettingsTableIsShown){
        [self.tblContent insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kTblModeSettingsIndexPathRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.modeSettingsTableIsShown = YES;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = self.tblContent.rowHeight;
    if(tableView.tag != kTblModeSettingsTag){
        if(self.samplePickerIsShown && indexPath.row == kPkrPlayerSampleIndexPathRow) rowHeight = self.playerSamplePickerHeight;
        if(self.modeSettingsTableIsShown && indexPath.row == kTblModeSettingsIndexPathRow) rowHeight = self.modeSettingsTableHeight;
    }
    return rowHeight;
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
