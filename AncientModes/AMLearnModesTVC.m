//
//  AMLearnModesTVCViewController.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/24/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMLearnModesTVC.h"
#import "AMModeDetailVC.h"

@interface AMLearnModesTVC ()
@property NSArray *listOfModes;
@end

@implementation AMLearnModesTVC

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.listOfModes = [[AMDataManager getInstance] getListOfAllModesUseDisplayName:YES grouped:YES];
    
    //set the background
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
    [background setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = background;

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
    cell.textLabel.text = [[self.listOfModes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[AMDataManager getInstance] getNameForGroupId:(int)section + 1];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"LearnModeDetailSegue"]){
        AMModeDetailVC *detailVC = [segue destinationViewController];
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        detailVC.modeName = [[self.listOfModes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
}



@end
