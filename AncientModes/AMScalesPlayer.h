//
//  AMScalesPlayer.h
//  AncientModes
//
//  Created by Vladimir Mollov on 1/18/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/MusicPlayer.h>

@interface AMScalesPlayer : NSObject

@property (readonly) NSString *currentSample;
@property Float64 tempo;

-(id)initWithTempo: (Float64) tempo;

-(void)playSequence:(MusicSequence) sequence;
-(void)stop;
-(void)changeTempoTo: (Float64) newTempo;

-(void)loadPianoSample;
-(void)loadTromboneSample;
-(void)loadVibraphoneSample;
@end
