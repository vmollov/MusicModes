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

@protocol AMScalesPlayerDelegate;

@interface AMScalesPlayer : NSObject
@property (nonatomic,weak) id<AMScalesPlayerDelegate> delegate;

@property (readonly) NSString *currentSample;
@property Float64 tempo;

+(id)sharedInstance;

-(void)playSequence:(MusicSequence) sequence;
-(void)stop;
-(void)changeTempoTo: (Float64) newTempo;
-(BOOL)isPlaying;

-(void)loadPianoSample;
-(void)loadTromboneSample;
-(void)loadVibraphoneSample;
@end
