//
//  AMViewController.m
//  AncientModes
//
//  Created by Vladimir Mollov on 1/15/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMViewController.h"
#import "AMSettingsAndUtilities.h"


@implementation AMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _thePlayer = [[AMScalesPlayer alloc] init];
    _thePlayer.delegate = self;
    
    _test = [[AMEarTest alloc] initWithNumberOfChallenges:5];
    [self displayChallenge];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playScale:(id)sender {
    [self playWithSample:@"Piano"];
}

- (IBAction)playWithVibraphone:(id)sender {
    [self playWithSample:@"Vibraphone"];
}

- (IBAction)playWithTrombone:(id)sender {
    [self playWithSample:@"Trombone"];
}
- (IBAction)stopPlayer:(id)sender {
    [_thePlayer stop];
}

- (IBAction)tempoChange:(id)sender {
    [self.thePlayer changeTempoTo:(Float64)[self.slTempo value]];
    self.lbTempo.text = [NSString stringWithFormat:@"Tempo: %.f", [self.slTempo value]];
}

- (IBAction)checkPlaying:(id)sender {
    self.lbPlaying.text = [NSString stringWithFormat:@"%@", [_thePlayer isPlaying]? @"Yes":@"No"];
    
}

- (IBAction)previousChallenge:(id)sender {
    [_test getPreviousChallenge];
    [self displayChallenge];
}

- (IBAction)nextChallenge:(id)sender {
    [_test getNextChallenge];
    [self displayChallenge];
    
}
-(void)displayChallenge{
    AMTestChallenge *challenge = [_test getCurrentChallenge];
    _txtScale.text = [NSString stringWithFormat:@"%@ %@", challenge.scale.baseNote, challenge.scale.scaleMode.name];
    if(_test.hasNextChallenge) _btnNext.enabled = true;
    else _btnNext.enabled = false;
    if(_test.hasPreviousChallenge) _btnPrevious.enabled = true;
    else _btnPrevious.enabled = false;
}

-(void)playWithSample: (NSString *) theSample{
    [self.txtScale resignFirstResponder];
    @try{
        if([theSample isEqualToString:@"Piano"])[_thePlayer loadPianoSample];
        if([theSample isEqualToString:@"Vibraphone"])[_thePlayer loadVibraphoneSample];
        if([theSample isEqualToString:@"Trombone"])[_thePlayer loadTromboneSample];
        
        MusicSequence theScaleSeq = [[_test.getCurrentChallenge scale] scaleSequence];
        [_thePlayer playSequence:theScaleSeq];
    }
    @catch(NSException *e){
        _txtScale.text = [NSString stringWithFormat:@"Exception has occured: %@", e];
    }
}

-(void)playerStoppedPlayback{
    self.lbPlaying.text = @"Just Stopped";
   
}
@end
