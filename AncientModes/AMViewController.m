//
//  AMViewController.m
//  AncientModes
//
//  Created by Vladimir Mollov on 1/15/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMViewController.h"
#import "AMMode.h"
#import "AMDataAndSettings.h"

@interface AMViewController ()
@property AMMode *theMode;
@end

@implementation AMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playScale:(id)sender {
    [self playWithSample:@""];
}

- (IBAction)stopPlayer:(id)sender {
    [_thePlayer stop];
}

- (IBAction)playWithVibraphone:(id)sender {
    [self playWithSample:@"Vibraphone"];
}

- (IBAction)playWithTrombone:(id)sender {
    [self playWithSample:@"Trombone"];
}

- (IBAction)tempoChange:(id)sender {
    [self.theMode changeTempoTo:(Float64)[self.slTempo value]];
    self.lbTempo.text = [NSString stringWithFormat:@"Tempo: %.f", [self.slTempo value]];
}

-(void)playWithSample: (NSString *) theSample{
    [self.txtScale resignFirstResponder];
    @try{
        self.theMode =[[AMMode alloc] initWithName:_txtScale.text tempo:(Float64)[self.slTempo value]];
        _thePlayer = [[AMScalesPlayer alloc] init];
        if([theSample isEqualToString:@"Vibraphone"])[_thePlayer loadVibraphoneSample];
        if([theSample isEqualToString:@"Trombone"])[_thePlayer loadTromboneSample];
        [_thePlayer playSequence:[self.theMode buildScaleSequenceFromNote:@"Cs7"]];
    }
    @catch(NSException *e){
        _txtScale.text = [NSString stringWithFormat:@"Exception has occured: %@", e];
    }

}

@end
