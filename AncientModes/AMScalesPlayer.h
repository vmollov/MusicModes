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

@property MusicPlayer player;
@property (readonly) NSString *currentSample;

-(void)playSequence:(MusicSequence) sequence;
-(void)stop;

-(void)loadPianoSample;
-(void)loadTromboneSample;
-(void)loadVibraphoneSample;
@end
