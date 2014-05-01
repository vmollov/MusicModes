//
//  AMScale.h
//  AncientModes
//
//  Created by Vladimir Mollov on 1/26/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <AudioToolbox/MusicPlayer.h>
#import "AMMode.h"

@interface AMScale : NSObject
@property UInt8 baseMIDINote;
@property AMMode *mode;

-(id)initWithMode: (AMMode *) mode baseMIDINote:(UInt8) baseMIDINote;

-(NSArray *) getNotesUseDescending:(BOOL)descending;
-(MusicSequence)scaleSequence;
-(MusicSequence)scaleSequenceAsc;
-(MusicSequence)scaleSequenceDesc;
-(MusicSequence)buildSequenceInAscending: (BOOL)ascending descending: (BOOL) descending startingNote:(UInt8) startingNote;

@end
