//
//  AMStatisticsByModeDetailVC.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/27/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMStatisticsByModeDetailVC.h"

@interface AMStatisticsByModeDetailVC ()

@end

@implementation AMStatisticsByModeDetailVC

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
}
-(void)viewWillAppear:(BOOL)animated{
    self.lbMode.text = self.modeName;
    float average = [[[self.data allValues] valueForKeyPath:@"@avg.self"] floatValue];
    self.lbAverage.text = [NSString stringWithFormat:@"Average: %.f%%", average];
    self.vwGraph.data = self.data;
    [self.vwGraph setNeedsDisplay];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
