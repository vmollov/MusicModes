//
//  AMCustomNavViewController.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/27/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMCustomNavViewController.h"
#import "AMCustomNavBar.h"

@interface AMCustomNavViewController ()

@end

@implementation AMCustomNavViewController

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
    [self setValue:[[AMCustomNavBar alloc]init] forKeyPath:@"navigationBar"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
