//
//  AMModesSettingsVC.m
//  Modes Ear Trainer
//
//  Created by Vladimir Mollov on 4/16/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMModesSettingsVC.h"
#import "AMModesSettingsTVCell.h"
#import "AMDataManager.h"
#import "AMPurchaseVC.h"
#import "UIViewController+Parallax.h"

@interface AMModesSettingsVC ()
@property NSArray *listOfModes;
@end

@implementation AMModesSettingsVC

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
    
    self.tblListOfModes.delegate = self;
    self.tblListOfModes.dataSource = self;
    self.listOfModes = [[AMDataManager getInstance] getListOfAllModesUseDisplayName:NO grouped:YES];
    
    self.tblListOfModes.backgroundColor = [UIColor clearColor];
    self.tblListOfModes.indicatorStyle = UIScrollViewIndicatorStyleWhite;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tblListOfModes flashScrollIndicators];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)purchaseAdvancedModes{
    AMPurchaseVC *purchaseController = [[AMPurchaseVC alloc] init];
    purchaseController.productName = @"AdvancedModes";
    [self.navigationController presentViewController:purchaseController animated:YES completion:nil];
    [purchaseController getProductInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchasesCompleted) name:@"PurchaseControllerFinished" object:nil];
}
-(void)purchasesCompleted{
    [self.tblListOfModes reloadData];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PurchaseControllerFinished" object:nil];
}

#pragma mark - TableVew Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listOfModes.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.listOfModes objectAtIndex:section] count];
}
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[AMDataManager getInstance] getNameForGroupId:(int)section + 1];
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
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
