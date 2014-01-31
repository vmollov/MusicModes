//
//  AMScale.h
//  AncientModes
//
//  Created by Vladimir Mollov on 1/26/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/MusicPlayer.h>
#import "AMMode.h"

@interface AMScale : NSObject
@property UInt8 baseMIDINote;
@property AMMode *scaleMode;

-(id)initWithModeName: (NSString *) modeName baseNote:(NSString *) baseNote;
-(id)initWithModeName: (NSString *) modeName baseMIDINote:(UInt8) baseMIDINote;

-(NSString *)baseNote;
-(void) setBaseNote: (NSString *) note;

-(MusicSequence)scaleSequence;
-(MusicSequence)scaleSequenceAsc;
-(MusicSequence)scaleSequenceDesc;

@end
