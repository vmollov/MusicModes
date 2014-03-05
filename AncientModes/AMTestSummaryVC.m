//
//  AMTestSummaryVC.m
//  AncientModes
//
//  Created by Vladimir Mollov on 3/3/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMTestSummaryVC.h"

@interface AMTestSummaryVC ()

@end

@implementation AMTestSummaryVC

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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

@end
