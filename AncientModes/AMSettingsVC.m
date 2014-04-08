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
#import "AMSettingsItem.h"
#import "UIViewController+Parallax.h"

static NSString *kEnableAdvancedModesCellID = @"cEnableAdvancedModes";
static NSString *kRemoveAdsCellID = @"cRemoveAds";
static NSString *kRestorePurchasesCellID = @"cRestorePurchases";

static int kTblModeSettingsTag = 2; //try to remove

static int kContentTableNumberOfSections = 2;
static int kContentTableNumberOfItemsPerSection = 3;

@interface AMSettingsVC ()
@property NSArray *listOfModes, *listOfSamples, *contentCells;

@property (strong) UITableView *tblModeSettings;
@property BOOL purchaseModesDisplayed, purchaseRemoveAdsDisplayed;
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
    
    //set up the content table data
    NSMutableArray *tmpContentCells = [[NSMutableArray alloc]init];
    int indexCounter = 0;
    AMSettingsItem *cellItem;
    
    cellItem = [[AMSettingsItem alloc] initWithTitleCellID:@"cChoosePlayBackInstrument" contentCellID:@"cPlayBackInstrumentPicker" indexPathRow:indexCounter];
    //cellItem.isShown = YES; //display the first item automatically
    [tmpContentCells insertObject:cellItem atIndex:indexCounter];
    indexCounter++;
    cellItem = [[AMSettingsItem alloc] initWithTitleCellID:@"cChooseTestSettings" contentCellID:@"cTestSettings" indexPathRow:indexCounter];
    [tmpContentCells insertObject:cellItem atIndex:indexCounter];
    indexCounter++;
    cellItem = [[AMSettingsItem alloc] initWithTitleCellID:@"cChooseModesToUse" contentCellID:@"cModesToUseTableCell" indexPathRow:indexCounter];
    [tmpContentCells insertObject:cellItem atIndex:indexCounter];
    indexCounter++;
    
    //calculate the content cells heights
    for(AMSettingsItem *item in tmpContentCells){
        UITableViewCell *cellToCheck = [self.tblContent dequeueReusableCellWithIdentifier:item.contentCellID];
        item.contentCellHeight = cellToCheck.frame.size.height;
    }
    
    //assign the contentCellsArray to the property
    self.contentCells = tmpContentCells;
    
    self.tblContent.backgroundColor = [UIColor clearColor];
   
    [self.tblContent flashScrollIndicators];
    
    //add purchase transaction observer
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
    //reset the purchase button display trackers
    self.purchaseModesDisplayed = NO;
    self.purchaseRemoveAdsDisplayed = NO;
    [self.tblModeSettings reloadData];
}

-(BOOL)embededViewIsShown{
    for (AMSettingsItem *item in self.contentCells) if (item.isShown) return YES;
    return NO;
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
    }else{
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"enableAdvancedModes"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"enableRemoveAds"]) return kContentTableNumberOfSections - 1;
        return kContentTableNumberOfSections;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView.tag == kTblModeSettingsTag) return [[AMDataManager getInstance] getNameForGroupId:(int)section + 1];
    else return @"";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag == kTblModeSettingsTag) return [[self.listOfModes objectAtIndex:section] count];
    else if(section == 0)return [self embededViewIsShown]?self.contentCells.count+1:self.contentCells.count;
    else {
        int rowNum = kContentTableNumberOfItemsPerSection;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enableAdvancedModes"]) rowNum--;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enableRemoveAds"]) rowNum--;
        return rowNum;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    NSLog(@"section: %i; row: %i", indexPath.section, indexPath.row);
    
    if(tableView.tag == kTblModeSettingsTag) cell = [self cellForModeSettingsTable:tableView ForIndexPath:indexPath];
    else{
        switch (indexPath.section) {
            case 0:
                NSLog(@"IndexPathRow: %i", indexPath.row);
                for(AMSettingsItem *item in self.contentCells){
                    if((item.titleIsDisplayed && !item.isShown) || (item.titleIsDisplayed && item.contentIsDisplayed)) continue;
                    if(!item.titleIsDisplayed){
                        cell = [tableView dequeueReusableCellWithIdentifier:item.titleCellID];
                        cell.accessoryView = [self accessoryViewForTitleCellWithContentShown:item.isShown];
                        item.titleIsDisplayed = YES;
                        break;
                    }else if(item.isShown && !item.contentIsDisplayed){
                        //exceptions
                        if(indexPath.row == 1) cell = [self cellForSamplesPickerInTableView:tableView];
                        //general
                        else cell = [tableView dequeueReusableCellWithIdentifier:item.contentCellID];
                        item.contentIsDisplayed = YES;
                        break;
                    }

                }
                
                /*if (indexPath.row == 0) {
                    cell= [tableView dequeueReusableCellWithIdentifier:kPlayBackInstrumentCellID];
                    cell.accessoryType = self.samplePickerIsShown?UITableViewCellAccessoryNone:UITableViewCellAccessoryDisclosureIndicator;
                   
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
                        iv.transform = CGAffineTransformMakeRotation(self.modeSettingsTableIsShown?-(M_PI/2):M_PI/2);
                        cell.accessoryView = iv;
                        self.modeSettingsButtonIndexPathRow = indexPath.row;
                    }
                }else {
                    cell = [tableView dequeueReusableCellWithIdentifier:kModesToUseCellID];
                    iv.transform = CGAffineTransformMakeRotation(self.modeSettingsTableIsShown?-(M_PI/2):M_PI/2);
                    cell.accessoryView = iv;
                    self.modeSettingsButtonIndexPathRow = indexPath.row;
                }*/
                break;
            case 1:
                if(![[NSUserDefaults standardUserDefaults] boolForKey:@"enableAdvancedModes"] && !self.purchaseModesDisplayed) {
                    cell = [tableView dequeueReusableCellWithIdentifier:kEnableAdvancedModesCellID];
                    self.purchaseModesDisplayed = YES;
                }
                else if(![[NSUserDefaults standardUserDefaults] boolForKey:@"enableRemoveAds"] && !self.purchaseRemoveAdsDisplayed){
                    cell = [tableView dequeueReusableCellWithIdentifier:kRemoveAdsCellID];
                    self.purchaseRemoveAdsDisplayed = YES;
                }
                else cell = [tableView dequeueReusableCellWithIdentifier:kRestorePurchasesCellID];
                
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
        for(int i=0; i<self.contentCells.count; i++){
            AMSettingsItem *item = [self.contentCells objectAtIndex:i];
            if(item.isShown && indexPath.row == item.indexPathRow + 1){
                rowHeight = item.contentCellHeight;
                break;
            }
        }
        
        //if(self.samplePickerIsShown && indexPath.row == kPkrPlayerSampleIndexPathRow) rowHeight = self.playerSamplePickerHeight;
        //if(self.modeSettingsTableIsShown && indexPath.row == kTblModeSettingsIndexPathRow) rowHeight = self.modeSettingsTableHeight;
    }
    return rowHeight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag != kTblModeSettingsTag){
        NSLog(@"Clicked row: %i", indexPath.row);
        [self.tblContent beginUpdates];
        
        int indexCorrection = 0;
        BOOL actionNeeded = YES;
        for(int i=0; i<self.contentCells.count; i++){
            AMSettingsItem *item = [self.contentCells objectAtIndex:i];
            if(item.isShown){
                if(indexPath.row == item.indexPathRow + 1) {
                    actionNeeded=NO;
                    break;
                }
                if(indexPath.row > item.indexPathRow + 1) indexCorrection = 1;
                if(indexPath.row == item.indexPathRow){
                    [self hideContentForSettingsItem:indexPath.row -indexCorrection];
                    actionNeeded = NO;
                }
            }
            [self hideContentForSettingsItem:i];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [tableView endUpdates];
        
        if(actionNeeded){
            [self.tblContent beginUpdates];
            [self showContentForSettingsItem:indexPath.row - indexCorrection];
            [self.tblContent endUpdates];
        }

        
        /*
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
        }*/
        
        //[tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.54];
    }
    
}

#pragma mark - TableView helper methods
-(void)showContentForSettingsItem:(int)index{
    AMSettingsItem *item = [self.contentCells objectAtIndex:index];
    if(!item.isShown){
        [self.tblContent insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index+1 inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
        item.isShown = YES;
        
        //reset the display setting
        item.contentIsDisplayed = NO;
        
        UITableViewCell *cell = [self.tblContent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.accessoryView = [self accessoryViewForTitleCellWithContentShown:YES];
    }

}
-(void)hideContentForSettingsItem:(int)index{
    AMSettingsItem *item = [self.contentCells objectAtIndex:index];
    if(item.isShown){
        [self.tblContent deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(index+1) inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
        item.isShown = NO;
        item.contentIsDisplayed = NO;
        
        //setup the title cell accessory
        UITableViewCell *cell = [self.tblContent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.accessoryView = [self accessoryViewForTitleCellWithContentShown:NO];
    }
}

-(AMSampleSettingsTVCell *)cellForSamplesPickerInTableView:(UITableView *) tableView{
    AMSettingsItem *pickerCellItem = [self.contentCells firstObject];
    AMSampleSettingsTVCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:pickerCellItem.contentCellID];
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

-(UIImageView *) accessoryViewForTitleCellWithContentShown:(BOOL)shown{
    UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,18,18)];
    accessoryView.image = [UIImage imageNamed:@"disclosureIndicator.png"];
    accessoryView.transform = CGAffineTransformMakeRotation(shown?-(M_PI/2):M_PI/2);
    return accessoryView;
}
/*-(void)hidePlayerSamplePicker{
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
}*/

@end
