//
//  AMLearnModesTVCViewController.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/24/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMLearnModesVC.h"
#import "AMModeDetailVC.h"
#import "UIViewController+Parallax.h"

@interface AMLearnModesVC ()
@property NSArray *listOfModes;
@end

@implementation AMLearnModesVC

- (void)viewDidLoad{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.listOfModes = [[AMDataManager getInstance] getListOfAllModesUseDisplayName:YES grouped:YES];
    self.tblListOfModes.dataSource = self;
    self.tblListOfModes.delegate = self;
    
    self.tblListOfModes.backgroundColor = [UIColor clearColor];
    
    [self setParallaxToView:self.imgBackground];
     
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
    cell.backgroundColor = [UIColor clearColor];
    
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
        NSIndexPath *indexPath = self.tblListOfModes.indexPathForSelectedRow;
        detailVC.modeName = [[self.listOfModes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
}



@end
