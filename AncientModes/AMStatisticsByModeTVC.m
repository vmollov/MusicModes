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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.listOfModes = [[AMDataManager getInstance] getListOfAllModes];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return self.listOfModes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"modeCell";
    AMStatisticsByModeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell==nil) cell=[[AMStatisticsByModeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSString *modeForCell = [self.listOfModes objectAtIndex:indexPath.row];
    NSDictionary *modeForCellData = [[AMDataManager getInstance] getStatisticsForMode:modeForCell];
    cell.modeData = modeForCellData;
    float average = [[[modeForCellData allValues] valueForKeyPath:@"@avg.self"] floatValue];
    cell.textLabel.text = modeForCell;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.f%%", average];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AMStatisticsByModeDetailVC *destination = [segue destinationViewController];
    AMStatisticsByModeTVCell *selectedCell = sender;
    destination.data = selectedCell.modeData;
    destination.modeName = selectedCell.textLabel.text;
}

@end
