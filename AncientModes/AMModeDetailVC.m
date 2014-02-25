//
//  AMModeDetailVC.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/24/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMModeDetailVC.h"
#import "AMScalesManager.h"
#import "AMUtilities.h"

@interface AMModeDetailVC ()

@end

@implementation AMModeDetailVC

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
    
    //create the scale for this details scene
    AMMode *scaleMode = [[AMScalesManager getInstance] createModeFromName:self.modeName];
    UInt8 baseNote = MIDIValueForNote(@"C4");
    self.scale = [[AMScale alloc] initWithMode:scaleMode baseMIDINote:baseNote];
    
    //setting the navigation
    self.navigationItem.title = self.scale.mode.name;
    
    //populating the scene body
    self.lbTest.text = self.scale.mode.description;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
