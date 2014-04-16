//
//  AMStatisticsByModeTVC.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/27/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMStatisticsByModeVC.h"
#import "AMStatisticsByModeTVCell.h"
#import "AMStatisticsByModeDetailVC.h"
#import "AMDataManager.h"
#import "UIViewController+Parallax.h"
#import <iAd/iAd.h>

@interface AMStatisticsByModeVC ()
@property NSArray *listOfModes;
@end

@implementation AMStatisticsByModeVC
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.listOfModes = [[AMDataManager getInstance] getListOfAllModesUseDisplayName:NO grouped:YES];
    
    //setup the tableview
    self.tblListOfModes.delegate = self;
    self.tblListOfModes.dataSource = self;
    self.tblListOfModes.backgroundColor = [UIColor clearColor];
    self.tblListOfModes.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    [self setParallaxToView:self.imgBackground];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tblListOfModes flashScrollIndicators];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listOfModes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.listOfModes objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"modeCell";
    AMStatisticsByModeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell==nil) cell=[[AMStatisticsByModeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSString *modeForCell = [[self.listOfModes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSDictionary *modeForCellData = [[AMDataManager getInstance] getStatisticsProgressForMode:modeForCell];
    cell.modeData = modeForCellData;
    cell.average = [[AMDataManager getInstance] getStatisticsAverageForMode:modeForCell];
    cell.textLabel.text = modeForCell;
    if([[modeForCellData allKeys] count] == 0) {
        cell.detailTextLabel.text = @"No data";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
    }
    else {
        NSNumberFormatter *floatFormatter = [[NSNumberFormatter alloc]init];
        floatFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        floatFormatter.maximumFractionDigits = 1;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%%", [floatFormatter stringFromNumber:[NSNumber numberWithFloat:cell.average]]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = YES;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[AMDataManager getInstance] getNameForGroupId:(int)section + 1];
}

#pragma mark - Navigation
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ModeStatisticsDetail"]){
        AMStatisticsByModeDetailVC *destination = [segue destinationViewController];
        AMStatisticsByModeTVCell *selectedCell = sender;
        destination.data = selectedCell.modeData;
        destination.average = selectedCell.average;
        destination.modeName = selectedCell.textLabel.text;
        
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"enableAdvancedModes"]) destination.interstitialPresentationPolicy = ADInterstitialPresentationPolicyAutomatic;
    }
}

@end
