//
//  AMModesSettingsViewController.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/21/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMModesSettingsVC.h"
#import "AMDataManager.h"
#import "AMModesSettingsTVC.h"

@interface AMModesSettingsVC ()
@property NSArray *listOfModes;
@end

@implementation AMModesSettingsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.listOfModes = [[AMDataManager getInstance] getListOfAllModes];
    self.tblModes.delegate = self;
    self.tblModes.dataSource = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView methods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listOfModes.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"scalesCell";
    AMModesSettingsTVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell ==nil) cell = [[AMModesSettingsTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    NSString *currentMode = [self.listOfModes objectAtIndex:indexPath.row];
    
    cell.lbMode.text = currentMode;
    cell.swModeSetting.on = [[NSUserDefaults standardUserDefaults] boolForKey:currentMode];
    cell.mode = currentMode;
    
    return cell;
}

@end
