//
//  AMMode.h
//  AncientModes
//
//  Created by Vladimir Mollov on 1/15/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <AudioToolbox/MusicPlayer.h>
#import "AMScalesPlayer.h"

@interface AMMode : NSObject
@property (nonatomic, strong, readonly) NSString *Name;
@property (nonatomic, strong, readonly) NSString *modeDescription;
@property (retain, readonly) NSArray *pattern;
@property (retain, readonly) NSMutableArray *patternDesc;

-(id)initWithName:(NSString *)name;

-(MusicSequence)buildScaleSequenceFromMIDINote: (UInt8)startingMIDINote;
-(MusicSequence)buildScaleSequenceFromNote: (NSString *)note;
-(void)disposeScaleSequence:(MusicSequence) sequence;
@end
