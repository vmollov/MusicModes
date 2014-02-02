//
//  AMScalesPlayer.h
//  AncientModes
//
//  Created by Vladimir Mollov on 1/18/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/MusicPlayer.h>

@protocol AMScalesPlayerDelegate <NSObject>
@optional
-(void)playerStoppedPlayback;
@end

@interface AMScalesPlayer : NSObject
@property (nonatomic,strong) id delegate;

@property (readonly) NSString *currentSample;
@property Float64 tempo;

+(id)sharedInstance;

-(id)initWithTempo: (Float64) tempo;

-(void)playSequence:(MusicSequence) sequence;
-(void)stop;
-(void)changeTempoTo: (Float64) newTempo;
-(BOOL)isPlaying;

-(void)loadPianoSample;
-(void)loadTromboneSample;
-(void)loadVibraphoneSample;
@end

//implement AMScalesPlayer as singleton and make AMScale use it to play it's sequence
