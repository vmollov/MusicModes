//
//  AMScalesPlayer.h
//  AncientModes
//
//  Created by Vladimir Mollov on 1/18/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/MusicPlayer.h>
#import "AMScale.h"

@interface AMScalesPlayer : NSObject

@property (readonly) NSString *currentSample;
@property Float64 tempo;

+(id)getInstance;

-(void)playScale:(AMScale *) scale;
-(void)playSequence:(MusicSequence) sequence;
-(void)stop;
-(void)changeTempoTo: (Float64) newTempo;
-(BOOL)isPlaying;

-(void)loadPianoSample;
-(void)loadTromboneSample;
-(void)loadVibraphoneSample;
-(void)loadSample:(NSString *) samplePreset;

@end
