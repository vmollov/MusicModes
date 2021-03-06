//
//  AMLearnModesTVCViewController.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/24/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMLearnModesVC.h"
#import "AMModeDetailVC.h"
#import "AMPurchaseVC.h"
#import "UIViewController+Parallax.h"
#import <iAd/iAd.h>

@interface AMLearnModesVC ()
@property NSArray *listOfModes;
@end

@implementation AMLearnModesVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.listOfModes = [[AMDataManager getInstance] getListOfAllModesUseDisplayName:YES grouped:YES];
    self.tblListOfModes.dataSource = self;
    self.tblListOfModes.delegate = self;
    
    self.tblListOfModes.backgroundColor = [UIColor clearColor];
    self.tblListOfModes.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    [self setParallaxToView:self.imgBackground];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tblListOfModes flashScrollIndicators];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return self.listOfModes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [[self.listOfModes objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"modeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *modeName = [[self.listOfModes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = modeName;
    cell.detailTextLabel.text = [[AMDataManager getInstance] isModeAvailable:modeName]? @"": @"Purchase";
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[AMDataManager getInstance] getNameForGroupId:(int)section + 1];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *modeName = [[self.listOfModes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (![[AMDataManager getInstance] isModeAvailable:modeName]) {
        //Purchase advanced Modes
        AMPurchaseVC *purchaseController = [[AMPurchaseVC alloc] init];
        purchaseController.productName = @"AdvancedModes";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchasesCompleted) name:@"PurchaseControllerFinished" object:nil];
        [self.navigationController presentViewController:purchaseController animated:YES completion:nil];
        [purchaseController getProductInfo];
    }
}

#pragma mark - Purchases Completion Listener
-(void)purchasesCompleted{
    [self.tblListOfModes reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PurchaseControllerFinished" object:nil];
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"LearnModeDetailSegue"]){
        AMModeDetailVC *detailVC = [segue destinationViewController];
        NSIndexPath *indexPath = self.tblListOfModes.indexPathForSelectedRow;
        detailVC.modeName = [[self.listOfModes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"enableAdvancedModes"]) detailVC.interstitialPresentationPolicy = ADInterstitialPresentationPolicyAutomatic;
    }
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"LearnModeDetailSegue"]){
        NSIndexPath *indexPath = self.tblListOfModes.indexPathForSelectedRow;
        NSString *modeName = [[self.listOfModes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        return [[AMDataManager getInstance] isModeAvailable:modeName];
    }
    return YES;
}


@end
