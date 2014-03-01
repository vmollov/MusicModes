//
//  AMStatisticsVC.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/24/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMStatisticsVC.h"
#import "AMDataManager.h"

@interface AMStatisticsVC ()

@end

@implementation AMStatisticsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self refreshStatisticsView];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetStatistics:(id)sender {
    UIActionSheet *confirmDialog = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
    [confirmDialog showInView:[UIApplication sharedApplication].keyWindow];
}
#pragma mark - Private Methods
-(void) refreshStatisticsView{
    NSDictionary *modeStatistics = [[AMDataManager getInstance] getStatisticsForMode:nil];
    float average = [[[modeStatistics allValues] valueForKeyPath:@"@avg.self"] floatValue];
    if([[modeStatistics allKeys] count] == 0) {
        self.lbAverage.hidden = YES;
        self.btnResetStatistics.enabled = NO;
        self.btnStatisticsByMode.enabled = NO;
    }
    else {
        self.lbAverage.hidden = NO;
        self.lbAverage.text = [NSString stringWithFormat:@"Average: %.f%%", average];
        self.btnResetStatistics.enabled = YES;  
        self.btnStatisticsByMode.enabled = YES;
    }
    
    self.grphOverall.data = modeStatistics;
    [self.grphOverall setNeedsDisplay];
}
#pragma mark - UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        // Do the delete
        [[AMDataManager getInstance] eraseAllStatistics];
        [self refreshStatisticsView];
    }
}
@end
