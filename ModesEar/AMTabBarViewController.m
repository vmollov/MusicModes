//
//  AMTabBarViewController.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/27/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMTabBarViewController.h"

@interface AMTabBarViewController ()

@end

@implementation AMTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"The Title" image:nil tag:0];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //fix needed for capturing devices on iOS 7.1 as well as earlier 7
    BOOL applyVersionPositionFix = ([[[UIDevice currentDevice] systemVersion] compare:@"7.1"] == NSOrderedAscending);
    
	// set the tab bar layout and size
    self.tabBar.frame = CGRectMake(0, self.view.frame.size.height-27, self.view.frame.size.width, 27);
    for(UITabBarItem *tabBarItem in self.tabBar.items){
        [tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, applyVersionPositionFix?-7:-28)];
        [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    }
}
- (NSUInteger)supportedInterfaceOrientations{
    //return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
