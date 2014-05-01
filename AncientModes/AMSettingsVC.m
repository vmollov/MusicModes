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
#import "AMSampleSettingsTVCell.h"
#import "AMTestSettingsTVCell.h"
#import "AMSettingsItem.h"
#import "UIViewController+Parallax.h"

static NSString *kModesSettingsCellID = @"cChooseModesToUse";
static NSString *kEnableAdvancedModesCellID = @"cEnableAdvancedModes";
static NSString *kRemoveAdsCellID = @"cRemoveAds";
static NSString *kRestorePurchasesCellID = @"cRestorePurchases";

static int kContentTableNumberOfSections = 2;

@interface AMSettingsVC ()
@property NSArray *listOfSamples, *contentCells;
@end

@implementation AMSettingsVC
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setParallaxToView:self.imgBackground];
    
    self.tblContent.backgroundColor = [UIColor clearColor];
    
    //setup the data
    self.listOfSamples = [[AMDataManager getInstance] getListOfSamples];
    
    //set up the content table data
    NSMutableArray *tmpContentCells = [[NSMutableArray alloc]init];
    int indexCounter = 0;
    AMSettingsItem *cellItem;
    
    cellItem = [[AMSettingsItem alloc] initWithTitleCellID:@"cChoosePlayBackInstrument" contentCellID:@"cPlayBackInstrumentPicker" indexPathRow:indexCounter];
    cellItem.isShown = YES; //display the first item automatically
    [tmpContentCells insertObject:cellItem atIndex:indexCounter];
    indexCounter++;
    cellItem = [[AMSettingsItem alloc] initWithTitleCellID:@"cChooseTestSettings" contentCellID:@"cTestSettings" indexPathRow:indexCounter];
    [tmpContentCells insertObject:cellItem atIndex:indexCounter];
    indexCounter++;
    
    //calculate the content cells heights
    for(AMSettingsItem *item in tmpContentCells){
        UITableViewCell *cellToCheck = [self.tblContent dequeueReusableCellWithIdentifier:item.contentCellID];
        item.contentCellHeight = cellToCheck.frame.size.height;
    }
    
    //assign the contentCellsArray to the property
    self.contentCells = tmpContentCells;
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tblContent reloadData];
    [self.tblContent flashScrollIndicators];
}
-(void)purchasesCompleted{
    [self.tblContent reloadData];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PurchaseControllerFinished" object:nil];
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
    //add purchase transaction observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchasesCompleted) name:@"PurchaseControllerFinished" object:nil];
}

- (IBAction)restorePurchases:(id)sender {
    AMPurchaseVC *purchaseController = [[AMPurchaseVC alloc] init];
    [self.navigationController presentViewController:purchaseController animated:YES completion:nil];
    [purchaseController restorePurchase];
    //add purchase transaction observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchasesCompleted) name:@"PurchaseControllerFinished" object:nil];
}

#pragma mark - UITableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"enableAdvancedModes"]) return kContentTableNumberOfSections - 1;
        return kContentTableNumberOfSections;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)return [self embededViewIsShown]?self.contentCells.count+2:self.contentCells.count+1;
    else return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
            if(![self embededViewIsShown]){
                if(indexPath.row == self.contentCells.count){
                    cell = [tableView dequeueReusableCellWithIdentifier:kModesSettingsCellID];
                    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.accessoryView = [self accessoryViewForTitleCellDefault];
                }else{
                    AMSettingsItem *item = [self.contentCells objectAtIndex:indexPath.row];
                    cell = [tableView dequeueReusableCellWithIdentifier:item.titleCellID];
                    cell.accessoryView = cell.accessoryView = [self accessoryViewForTitleCellWithContentShown:item.isShown];
                }
            }else{
                if(indexPath.row == self.contentCells.count+1){
                    cell = [tableView dequeueReusableCellWithIdentifier:kModesSettingsCellID];
                    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.accessoryView = [self accessoryViewForTitleCellDefault];
                }else{
                    if(indexPath.row == ([self indexForContentItemShown] + 1)){ //return the content cell
                        AMSettingsItem *item = [self.contentCells objectAtIndex:[self indexForContentItemShown]];
                        
                        //exceptions
                        if([self indexForContentItemShown] == 0) cell = [self cellForSamplesPickerInTableView:tableView cellIdentifier:item.contentCellID];
                        else if([self indexForContentItemShown] == 1) cell = [self cellForTestSettingsInTableView:tableView cellIdentifier:item.contentCellID];
                        //general
                        else cell = [tableView dequeueReusableCellWithIdentifier:item.contentCellID];
                    }else{
                        long theIndexRow = indexPath.row;
                        if (indexPath.row > ([self indexForContentItemShown] + 1))theIndexRow--;
                        AMSettingsItem *item = [self.contentCells objectAtIndex:theIndexRow];
                        cell = [tableView dequeueReusableCellWithIdentifier:item.titleCellID];
                        cell.accessoryView = cell.accessoryView = [self accessoryViewForTitleCellWithContentShown:item.isShown];
                    }
                }
            }
            
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"enableAdvancedModes"])
                        cell = [tableView dequeueReusableCellWithIdentifier:kEnableAdvancedModesCellID];
                    else cell = [tableView dequeueReusableCellWithIdentifier:kRemoveAdsCellID];
                    break;
                case 1:
                    cell = [tableView dequeueReusableCellWithIdentifier:kRestorePurchasesCellID];
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    cell.backgroundColor =[UIColor clearColor];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = self.tblContent.rowHeight;
    if(indexPath.section == 0){
        for(int i=0; i<self.contentCells.count; i++){
            AMSettingsItem *item = [self.contentCells objectAtIndex:i];
            if(item.isShown && indexPath.row == item.indexPathRow + 1){
                rowHeight = item.contentCellHeight;
                break;
            }
        }
    }
    return rowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell.reuseIdentifier isEqualToString:kModesSettingsCellID]) return;
    
    [self.tblContent beginUpdates];
    
    long indexCorrection = 0;
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
                [self hideContentForSettingsItem:indexPath.row - indexCorrection];
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
}

#pragma mark - TableView helper methods
-(void)showContentForSettingsItem:(long)index{
    AMSettingsItem *item = [self.contentCells objectAtIndex:index];
    if(!item.isShown){
        [self.tblContent insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index+1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        item.isShown = YES;
        
        UITableViewCell *cell = [self.tblContent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.accessoryView = [self accessoryViewForTitleCellWithContentShown:YES];
    }

}
-(void)hideContentForSettingsItem:(long)index{
    AMSettingsItem *item = [self.contentCells objectAtIndex:index];
    if(item.isShown){
        [self.tblContent deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(index+1) inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        item.isShown = NO;
        
        //setup the title cell accessory
        UITableViewCell *cell = [self.tblContent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.accessoryView = [self accessoryViewForTitleCellWithContentShown:NO];
    }
}

-(AMSampleSettingsTVCell *)cellForSamplesPickerInTableView:(UITableView *) tableView cellIdentifier:(NSString *) cellID{
    AMSampleSettingsTVCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    pickerCell.listOfSamples = self.listOfSamples;
    pickerCell.pkrPlayerSample.delegate = pickerCell;
    pickerCell.pkrPlayerSample.dataSource = pickerCell;
    
    //set the picker's initial state
    NSInteger selectedIndex = [self.listOfSamples indexOfObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"playSample"  ]];
    [pickerCell.pkrPlayerSample selectRow:selectedIndex inComponent:0 animated:YES];
    
    return pickerCell;
}
-(AMTestSettingsTVCell *)cellForTestSettingsInTableView:(UITableView *)tableView cellIdentifier:(NSString *) cellID{
    AMTestSettingsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.swRandomStartingNote.on = (![[NSUserDefaults standardUserDefaults] boolForKey:@"ChallengeOnSameNote"]);
    cell.swTestOutOf8.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"testOutOf8Answers"];
    
    return cell;
}

-(UIImageView *) accessoryViewForTitleCellWithContentShown:(BOOL)shown{
    UIImageView *accessoryView = [self accessoryViewForTitleCellDefault];
    accessoryView.transform = CGAffineTransformMakeRotation(shown?-(M_PI/2):M_PI/2);
    return accessoryView;
}
-(UIImageView *) accessoryViewForTitleCellDefault{
    UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,18,18)];
    accessoryView.image = [UIImage imageNamed:@"disclosureIndicator.png"];
    return accessoryView;
}
-(int)indexForContentItemShown{
    int index = -1;
    for (int i =0; i<self.contentCells.count; i++) if([(AMSettingsItem *)[self.contentCells objectAtIndex:i] isShown]) return i;
    return index;
}


#pragma mark - Navigation
-(IBAction) unwindToSettingsRoot:(UIStoryboardSegue *)segue{
    
}
@end
