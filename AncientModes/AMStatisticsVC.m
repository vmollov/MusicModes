//
//  AMStatisticsVC.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/24/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMStatisticsVC.h"
#import "AMDataManager.h"
#import "UIViewController+Parallax.h"
#import <iAd/iAd.h>

@interface AMStatisticsVC ()

@end

@implementation AMStatisticsVC

- (void)viewDidLoad{
    [super viewDidLoad];
	
    [self setParallaxToView:self.imgBackground];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    NSDictionary *modeStatistics = [[AMDataManager getInstance] getStatisticsProgressForMode:nil];
    float average = [[AMDataManager getInstance] getStatisticsAverageForMode:nil];
    if([[modeStatistics allKeys] count] == 0) {
        self.lbAverage.hidden = YES;
        self.lbProgress.hidden = YES;
        self.btnResetStatistics.enabled = NO;
        self.btnStatisticsByMode.enabled = NO;
    }
    else {
        self.lbAverage.hidden = NO;
        self.lbProgress.hidden = NO;
        
        NSNumberFormatter *floatFormatter = [[NSNumberFormatter alloc]init];
        floatFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        floatFormatter.maximumFractionDigits = 1;
        
        self.lbAverage.text = [NSString stringWithFormat:@"Current Average: %@%%", [floatFormatter stringFromNumber:[NSNumber numberWithFloat:average]]];
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
