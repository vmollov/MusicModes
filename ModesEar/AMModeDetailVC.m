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
#import "AMNote.h"
#import "UIViewController+Parallax.h"
#import "AMUtilities.h"

@interface AMModeDetailVC ()
@property AMMode *mode;

@property NSDictionary *noteImageIndexes;
@end

@implementation AMModeDetailVC
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setParallaxToView:self.imgBackground];
    
    //create the scale for this details scene
    self.mode = [[AMScalesManager getInstance] createModeWithDescriptionFromName:self.modeName];
    UInt8 baseNote = [[[AMNote alloc] initWithString:@"C4"] MIDIValue];
    self.scale = [[AMScale alloc] initWithMode:self.mode baseMIDINote:baseNote];
    
    //setting the navigation
    self.navigationItem.title = self.mode.displayName;
    
    //set the description and the listenFors
    NSString *strTips = @"";
    for(NSString *tip in self.mode.tips)
        strTips = [strTips stringByAppendingString:[NSString stringWithFormat:@"- %@\n", tip]];
    self.txtDescription.text = [self.mode.modeDescription stringByAppendingString:[NSString stringWithFormat:@"\n\nListen For:\n%@", strTips]];
    self.txtDescription.backgroundColor = [UIColor clearColor];
    
    //create the visual example
    NSMutableArray *scaleNotePaths = [[NSMutableArray alloc]initWithCapacity:8];
    self.noteImageIndexes = [NSMutableDictionary dictionaryWithCapacity:8];
    
    [scaleNotePaths addObject:@"noteImages/trblClef"];
    NSArray *scaleNotes = [self.scale getNotesUseDescending:[self.mode.name isEqualToString:@"Melodic Major"]];
    
    for(int index = 0; index<scaleNotes.count; index++){
        NSString *scaleNote = [scaleNotes objectAtIndex:index];
        [scaleNotePaths addObject:[@"noteImages" stringByAppendingPathComponent:scaleNote]];
        
        AMNote *aNote = [[AMNote alloc]initWithString:scaleNote];
        if(aNote != nil) [self.noteImageIndexes setValue:[NSNumber numberWithInt:index+1] forKey:[NSString stringWithFormat:@"%i", aNote.MIDIValue]];
    }
    
    self.vwExample.noteImages = scaleNotePaths;
    self.vwExample.spacer = @"noteImages/staff";
    self.vwExample.hidden = NO;
    [self.vwExample refresh];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //setup the plyer stop event observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStoppedPlayback) name:@"ScalesPlayerStoppedPlayback" object:nil];
    
    //setup the note highlight observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(highlightPlayedNoteNotification:) name:@"MIDINotePlayed" object:nil];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.txtDescription flashScrollIndicators];
}
-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[AMScalesPlayer getInstance] stop];
    //remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ScalesPlayerStoppedPlayback" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MIDINotePlayed" object:nil];
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

#pragma mark - ScalesPlayer Methods
-(void)playerStoppedPlayback{
    [self.btnPlayExample setTitle:@"Play Example" forState:UIControlStateNormal];
    [self.vwExample removeHighlights];
}
-(void)highlightPlayedNoteNotification:(NSNotification *) notification{
    NSString *MIDINote = [notification.userInfo objectForKey:@"MIDINote"];
    NSInteger noteIndex = [[self.noteImageIndexes objectForKey:MIDINote] integerValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.vwExample highlightNoteAtIndex:noteIndex];
    });
    
}
@end
