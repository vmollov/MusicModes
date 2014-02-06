//
//  AMScale.m
//  AncientModes
//
//  Created by Vladimir Mollov on 1/26/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMScale.h"

@implementation AMScale

-(id)initWithMode: (AMMode *) mode baseMIDINote:(UInt8) baseMIDINote{
    if(self = [super init]){
        _baseMIDINote = baseMIDINote;
        _mode = mode;
    }
    
    return self;
}

#pragma mark - Methods to Build Scales
-(MusicSequence)scaleSequence{
    return [self buildSequenceInAscending:true descending:true];
}
-(MusicSequence)scaleSequenceAsc{
    return [self buildSequenceInAscending:true descending:false];
}
-(MusicSequence)scaleSequenceDesc{
    return [self buildSequenceInAscending:false descending:true];
}

-(MusicSequence)buildSequenceInAscending: (BOOL)ascending descending: (BOOL) descending {
    //Get the settings
    if(!ascending && !descending) [NSException raise:@"Incorrect Application Congfiguration" format:@"The settings currently indicate that neither ascending nor descending scale should be built. Adjust the configuration in the main plist file"];
    
    //declare and initialize the MusicSequence and MusicTrack holders and add the track to the sequence
    MusicSequence theScaleSequence;
    MusicTrack theScaleTrack;
    NewMusicSequence(&theScaleSequence);
    MusicSequenceNewTrack(theScaleSequence, &theScaleTrack);
    
    //create the notes' common attributes
    MIDINoteMessage aNote;
    aNote.channel = 1;
    aNote.velocity = 127;
    //set starting note to the passed midi note argument - adjust it for number of octaves if only descending scale is requested
    aNote.note = self.baseMIDINote;
    aNote.duration = 1;
    
    MusicTimeStamp noteTime = 0.0;
    MusicTrackNewMIDINoteEvent(theScaleTrack, noteTime, &aNote);
    
    //itterate through the mode pattern to build the scale note by note
    for (int patternPoint=0; patternPoint<[self.mode.pattern count]; patternPoint++){
        //get the number of semitones to the next note from the self.pattern array
        UInt8 semitones = [[self.mode.pattern objectAtIndex:patternPoint] intValue];
        //set the MIDI value and time for the next note
        if (ascending) {
            aNote.note = aNote.note + semitones;
            //adjust the time
            noteTime += 1.0;
            //add the note to the track
            MusicTrackNewMIDINoteEvent(theScaleTrack, noteTime, &aNote);
        }
    }
    //build the descending scale
    for(int patternPoint = 0; patternPoint<[self.mode.patternDesc count]; patternPoint++){
        //get the number of semitones to the next note from the self.pattern array
        UInt8 semitones = [[self.mode.patternDesc objectAtIndex:patternPoint] intValue];
        //set the MIDI value and time for the next note
        if(descending){
            aNote.note = aNote.note + semitones;
            //adjust the time
            noteTime += 1.0;
            //add the note to the track
            MusicTrackNewMIDINoteEvent(theScaleTrack, noteTime, &aNote);
        }
    }
    
    return theScaleSequence;
}

@end
