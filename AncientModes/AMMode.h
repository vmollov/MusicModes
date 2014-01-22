//
//  AMMode.h
//  AncientModes
//
//  Created by Vladimir Mollov on 1/15/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <AudioToolbox/MusicPlayer.h>

@interface AMMode : NSObject
@property (nonatomic, strong, readonly) NSString *Name;
@property (nonatomic, strong, readonly) NSString *modeDescription;
@property (retain, readonly) NSArray *pattern;
@property (retain, readonly) NSMutableArray *patternDesc;
@property Float64 tempo;

-(id)initWithName:(NSString *)name;
-(id)initWithName:(NSString *)name tempo: (Float64) tempo;
-(MusicSequence)buildScaleSequenceFromMIDINote: (UInt8)startingMIDINote;
-(MusicSequence)buildScaleSequenceFromNote: (NSString *)note;
-(void)changeTempoTo: (Float64) newTempo;
-(void)disposeScaleSequence:(MusicSequence) sequence;
@end
