//
//  AMStatisticsByModeDetailVC.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/27/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMStatisticsByModeDetailVC.h"
#import "UIViewController+Parallax.h"

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
	
    [self setParallaxToView:self.imgBackground];
}
-(void)viewWillAppear:(BOOL)animated{
    self.lbMode.text = self.modeName;
    if(self.data.count == 0) self.lbAverage.hidden=YES;
    
    else {
        NSNumberFormatter *floatFormatter = [[NSNumberFormatter alloc]init];
        floatFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        floatFormatter.maximumFractionDigits = 1;
        self.lbAverage.text = [NSString stringWithFormat:@"Current Average: %@%%", [floatFormatter stringFromNumber:[NSNumber numberWithFloat:self.average]]];
    }
    self.vwGraph.data = self.data;
    [self.vwGraph setNeedsDisplay];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
