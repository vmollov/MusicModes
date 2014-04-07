//
//  AMSettingsNewVC.m
//  Modes Ear Trainer
//
//  Created by Vladimir Mollov on 4/4/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMSettingsVC.h"
#import "AMDataManager.h"
#import "AMScalesPlayer.h"
#import "AMModesSettingsTVCell.h"
#import "AMSampleSettingsTVCell.h"
#import "UIViewController+Parallax.h"

static NSString *kPlayBackInstrumentCellID = @"cPlayBackInstrument";
static NSString *kPlayBackInstrumentPickerCellID = @"cPlayBackInstrumentPicker";
static NSString *kModesToUseCellID = @"cChooseModesToUse";
static NSString *kModesToUseTableCellID = @"cModesToUseTableCell";
static NSString *kEnableAdvancedModesCellID = @"cEnableAdvancedModes";
static NSString *kRemoveAdsCellID = @"cRemoveAds";
static NSString *kRestorePurchasesCellID = @"cRestorePurchases";

static int kTblModeSettingsTag = 2;
static int kPkrPlayerSampleIndexPathRow = 1;
static int kTblModeSettingsIndexPathRow = 2;

static int kContentTableNumberOfSections = 2;
static int kContentTableNumberOfItemsPerSection = 3;

@interface AMSettingsVC ()
@property NSArray *listOfModes, *listOfSamples;

@property float playerSamplePickerHeight;
@property (strong) UITableView *tblModeSettings;
@property float modeSettingsTableHeight;
@property NSInteger modeSettingsButtonIndexPathRow;

@property BOOL samplePickerIsShown, modeSettingsTableIsShown;
@end

@implementation AMSettingsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
}
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setParallaxToView:self.imgBackground];
    
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
    
    self.tblContent.backgroundColor = [UIColor clearColor];
   
    self.samplePickerIsShown = YES;
    
    [self.tblContent flashScrollIndicators];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchasesCompleted) name:@"PurchaseControllerFinished" object:nil];
}
-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PurchaseControllerFinished" object:nil];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)purchasesCompleted{
    [self.tblContent reloadData];
    [self.tblModeSettings reloadData];
}

-(BOOL)embededViewIsShown{
    return (self.samplePickerIsShown || self.modeSettingsTableIsShown);
}

- (IBAction)purchaseAdvancedModes:(id)sender {
    AMPurchaseVC *purchaseController = [[AMPurchaseVC alloc] init];
    purchaseController.productName = @"AdvancedModes";
    [self.navigationController presentViewController:purchaseController animated:YES completion:nil];
    [purchaseController getProductInfo];
}

- (IBAction)purchaseRemoveAds:(id)sender {
    AMPurchaseVC *purchaseController = [[AMPurchaseVC alloc]init];
    purchaseController.productName = @"RemoveAds";
    [self.navigationController presentViewController:purchaseController animated:YES completion:nil];
    [purchaseController getProductInfo];

}

- (IBAction)restorePurchases:(id)sender {
    AMPurchaseVC *purchaseController = [[AMPurchaseVC alloc] init];
    [self.navigationController presentViewController:purchaseController animated:YES completion:nil];
    [purchaseController restorePurchase];
}

#pragma mark - UITableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView.tag == kTblModeSettingsTag) {
        tableView.backgroundColor = [UIColor clearColor];
        self.tblModeSettings = tableView;
        return self.listOfModes.count;
    }else return kContentTableNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag == kTblModeSettingsTag) return [[self.listOfModes objectAtIndex:section] count];
    else if(section == 0)return [self embededViewIsShown]?3:2;
    else return kContentTableNumberOfItemsPerSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    if(tableView.tag == kTblModeSettingsTag) cell = [self cellForModeSettingsTable:tableView ForIndexPath:indexPath];
    else{
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {
                    cell= [tableView dequeueReusableCellWithIdentifier:kPlayBackInstrumentCellID];
                    cell.accessoryType = self.samplePickerIsShown?UITableViewCellAccessoryNone:UITableViewCellAccessoryDisclosureIndicator;
                   
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,18,18)];
                    iv.image = [UIImage imageNamed:@"disclosureIndicator.png"];
                    iv.transform = CGAffineTransformMakeRotation(self.samplePickerIsShown?-(M_PI/2):M_PI/2);
                    cell.accessoryView = iv;

                    break;
                }
                if ([self embededViewIsShown]){
                    if(self.samplePickerIsShown && indexPath.row == kPkrPlayerSampleIndexPathRow)cell = [self cellForSamplesPickerInTableView:tableView];
                    else if(self.modeSettingsTableIsShown && indexPath.row == kTblModeSettingsIndexPathRow) cell = [tableView dequeueReusableCellWithIdentifier:kModesToUseTableCellID];
                    else{
                        cell = [tableView dequeueReusableCellWithIdentifier:kModesToUseCellID];
                        //cell.accessoryType = self.modeSettingsTableIsShown?UITableViewCellAccessoryNone:UITableViewCellAccessoryDisclosureIndicator;
                        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,18,18)];
                        iv.image = [UIImage imageNamed:@"disclosureIndicator.png"];
                        iv.transform = CGAffineTransformMakeRotation(self.modeSettingsTableIsShown?-(M_PI/2):M_PI/2);
                        cell.accessoryView = iv;
                        self.modeSettingsButtonIndexPathRow = indexPath.row;
                    }
                }else {
                    cell = [tableView dequeueReusableCellWithIdentifier:kModesToUseCellID];
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,18,18)];
                    iv.image = [UIImage imageNamed:@"disclosureIndicator.png"];
                    iv.transform = CGAffineTransformMakeRotation(self.modeSettingsTableIsShown?-(M_PI/2):M_PI/2);
                    cell.accessoryView = iv;
                    self.modeSettingsButtonIndexPathRow = indexPath.row;
                }
                break;
            case 1:
                if(indexPath.row == 0) cell = [tableView dequeueReusableCellWithIdentifier:kEnableAdvancedModesCellID];
                if(indexPath.row == 1) cell = [tableView dequeueReusableCellWithIdentifier:kRemoveAdsCellID];
                if(indexPath.row == 2) cell = [tableView dequeueReusableCellWithIdentifier:kRestorePurchasesCellID];
                break;
            
            default:
                break;
        }
    }
    
    cell.backgroundColor =[UIColor clearColor];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = self.tblContent.rowHeight;
    if(tableView.tag != kTblModeSettingsTag && indexPath.section == 0){
        if(self.samplePickerIsShown && indexPath.row == kPkrPlayerSampleIndexPathRow) rowHeight = self.playerSamplePickerHeight;
        if(self.modeSettingsTableIsShown && indexPath.row == kTblModeSettingsIndexPathRow) rowHeight = self.modeSettingsTableHeight;
    }
    return rowHeight;
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
                if(indexPath.row == kTblModeSettingsIndexPathRow && indexPath.section == 0)[self showModeSettingsTable];
                [self hidePlayerSamplePicker];
            }else if(self.modeSettingsTableIsShown){
                [self hideModeSettingsTable];
                if(indexPath.row == kPkrPlayerSampleIndexPathRow - 1 && indexPath.section == 0)[self showPlayerSamplePicker];
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
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [tableView endUpdates];
        //[tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.54];
    }
    
}

#pragma mark - TableView helper methods
-(AMSampleSettingsTVCell *)cellForSamplesPickerInTableView:(UITableView *) tableView{
    AMSampleSettingsTVCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:kPlayBackInstrumentPickerCellID];
    pickerCell.listOfSamples = self.listOfSamples;
    pickerCell.pkrPlayerSample.delegate = pickerCell;
    pickerCell.pkrPlayerSample.dataSource = pickerCell;
    
    //set the picker's initial state
    NSInteger selectedIndex = [self.listOfSamples indexOfObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"playSample"  ]];
    [pickerCell.pkrPlayerSample selectRow:selectedIndex inComponent:0 animated:YES];
    
    return pickerCell;
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

-(void)hidePlayerSamplePicker{
    if(self.samplePickerIsShown){
        [self.tblContent deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kPkrPlayerSampleIndexPathRow inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
        self.samplePickerIsShown = NO;
        self.modeSettingsButtonIndexPathRow = 1;
        
        UITableViewCell *cell = [self.tblContent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,18,18)];
        iv.image = [UIImage imageNamed:@"disclosureIndicator.png"];
        iv.transform = CGAffineTransformMakeRotation(M_PI/2);
        cell.accessoryView = iv;
    }
}
-(void)showPlayerSamplePicker{
    if(!self.samplePickerIsShown){
        [self.tblContent insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kPkrPlayerSampleIndexPathRow inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
        self.samplePickerIsShown = YES;
        self.modeSettingsButtonIndexPathRow = 2;
        
        UITableViewCell *cell = [self.tblContent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,18,18)];
        iv.image = [UIImage imageNamed:@"disclosureIndicator.png"];
        iv.transform = CGAffineTransformMakeRotation(-(M_PI/2));
        cell.accessoryView = iv;

    }
}
-(void)hideModeSettingsTable{
    if(self.modeSettingsTableIsShown){
        [self.tblContent deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kTblModeSettingsIndexPathRow inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
        self.modeSettingsTableIsShown = NO;
        
        UITableViewCell *cell = [self.tblContent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.modeSettingsButtonIndexPathRow inSection:0]];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,18,18)];
        iv.image = [UIImage imageNamed:@"disclosureIndicator.png"];
        iv.transform = CGAffineTransformMakeRotation(M_PI/2);
        cell.accessoryView = iv;
    }
}
-(void)showModeSettingsTable{
    if(!self.modeSettingsTableIsShown){
        [self.tblContent insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kTblModeSettingsIndexPathRow inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
        self.modeSettingsTableIsShown = YES;
        UITableViewCell *cell = [self.tblContent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.modeSettingsButtonIndexPathRow inSection:0]];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,18,18)];
        iv.image = [UIImage imageNamed:@"disclosureIndicator.png"];
        iv.transform = CGAffineTransformMakeRotation(-(M_PI/2));
        cell.accessoryView = iv;

    }
}

@end
