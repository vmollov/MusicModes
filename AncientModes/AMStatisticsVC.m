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
    NSDictionary *modeStatistics = [[AMDataManager getInstance] getStatisticsForMode:nil];
    
    float average = [[[modeStatistics allValues] valueForKeyPath:@"@avg.self"] floatValue];
    self.lbAverage.text = [NSString stringWithFormat:@"Average: %.f%%", average];
    self.grphOverall.data = modeStatistics;
    [self.grphOverall setNeedsDisplay];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
