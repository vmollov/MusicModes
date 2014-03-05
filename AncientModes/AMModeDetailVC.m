//
//  AMModeDetailVC.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/24/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMModeDetailVC.h"
#import "AMScalesManager.h"
#import "AMScalesPlayer.h"
#import "AMUtilities.h"

@interface AMModeDetailVC ()
@property AMMode *mode;
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

- (void)viewDidLoad{
    [super viewDidLoad];
    //create the scale for this details scene
    self.mode = [[AMScalesManager getInstance] createModeWithDescriptionFromName:self.modeName];
    UInt8 baseNote = MIDIValueForNote(@"C4");
    self.scale = [[AMScale alloc] initWithMode:self.mode baseMIDINote:baseNote];
    
    //setting the navigation
    self.navigationItem.title = self.mode.displayName;
    
    //set the description and the listenFors
    self.txtDescription.text = self.mode.modeDescription;
    self.txtDescription.backgroundColor = [UIColor clearColor];
    
    NSString *strTips = @"";
    for(NSString *tip in self.mode.tips) strTips = [strTips stringByAppendingString:[NSString stringWithFormat:@"- %@\n", tip]];
    self.txtListenFor.text = strTips;
    self.txtListenFor.backgroundColor = [UIColor clearColor];
    
    //create the visual example
    NSMutableArray *scaleNotePaths = [[NSMutableArray alloc]initWithCapacity:8];
    [scaleNotePaths addObject:@"noteImages/trblClef"];
    
    for (NSString *scale in [self.scale getNotesUseDescending:[self.mode.name isEqualToString:@"Melodic Major"]]){
        [scaleNotePaths addObject:[@"noteImages" stringByAppendingPathComponent:scale]];
    }
    
    self.vwExample.noteImages = scaleNotePaths;
    self.vwExample.spacer = @"noteImages/staff";
    self.vwExample.hidden = NO;
    [self.vwExample refresh];
    
    //setup the plyer stopp event observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStoppedPlayback) name:@"ScalesPlayerStoppedPlayback" object:nil];
}
-(void) viewDidAppear:(BOOL)animated{
    [self.txtDescription flashScrollIndicators];
    [self.txtListenFor flashScrollIndicators];
    
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Interraction Handlers
- (IBAction)playExample:(id)sender {
    AMScalesPlayer *thePlayer = [AMScalesPlayer getInstance];
    if([self.btnPlayExample.titleLabel.text isEqualToString:@"Stop"]) [thePlayer stop];
    else{
        [thePlayer playScale:self.scale];
        [self.btnPlayExample setTitle:@"Stop" forState:UIControlStateNormal];
    }
}

#pragma mark - ScalesPlayerDelegate Methods
-(void)playerStoppedPlayback{
    [self.btnPlayExample setTitle:@"Play Example" forState:UIControlStateNormal];
}
@end
