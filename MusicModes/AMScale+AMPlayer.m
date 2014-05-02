//
//  AMScale+AMPlayer.m
//  Modes Ear Trainer
//
//  Created by Vladimir Mollov on 5/1/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMScale+AMPlayer.h"
#import "AMDataManager.h"

@implementation AMScale (AMPlayer)

-(MusicSequence)scaleSequenceAdjustedForPlayerRange{
    return [self buildSequenceInAscending:YES descending:YES startingNote:[self getAdjustedStartingNote]];
}
-(MusicSequence)scaleSequenceAscAdjustedForPlayerRange{
    return [self buildSequenceInAscending:YES descending:NO startingNote:[self getAdjustedStartingNote]];
}
-(MusicSequence)scaleSequenceDescAdjustedForPlayerRange{
    return [self buildSequenceInAscending:NO descending:YES startingNote:[self getAdjustedStartingNote]];
}

-(UInt8)getAdjustedStartingNote{
    UInt8 startingNote = self.baseMIDINote;
    NSRange sampleRange = [[AMDataManager getInstance] getCurrentSampleRange];
    
    while(startingNote<sampleRange.location) startingNote+=12;
    while(startingNote>sampleRange.length - 12) startingNote-=12;
    return startingNote;
}
@end
