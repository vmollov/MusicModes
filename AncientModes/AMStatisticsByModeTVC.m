//
//  AMStatisticsByModeTVC.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/27/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMStatisticsByModeTVC.h"
#import "AMStatisticsByModeTVCell.h"
#import "AMStatisticsByModeDetailVC.h"
#import "AMDataManager.h"

@interface AMStatisticsByModeTVC ()
@property NSArray *listOfModes;
@end

@implementation AMStatisticsByModeTVC

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.listOfModes = [[AMDataManager getInstance] getListOfAllModesUseDisplayName:NO grouped:YES];
    
    //set the background
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
    [background setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = background;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning{
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
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.f%%", cell.average];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = YES;
    }
    
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
    }
}

@end
