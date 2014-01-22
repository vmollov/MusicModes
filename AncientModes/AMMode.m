//
//  AMMode.m
//  AncientModes
//
//  Created by Vladimir Mollov on 1/15/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMMode.h"
#import "AMDataAndSettings.h"

@interface AMMode()
@property MusicTrack tempoTrack;
@end

@implementation AMMode

#pragma mark
#pragma mark Constructors
-(id) initWithName:(NSString *)name{
    return [self initWithName:name tempo:120];
}
-(id)initWithName:(NSString *)name tempo:(Float64)tempo{
    NSDictionary *scaleProperties = [AMDataAndSettings getPropertiesForMode:name];
    if(scaleProperties == nil) [NSException raise:@"Invalid Mode" format:@"%@ is not a recognized mode or it does not exist in the main property list file", name];
    
    //populate the modes's properties from the dictionary
    _Name = name;
    _modeDescription = [scaleProperties objectForKey:@"Description"];
    _pattern = [scaleProperties objectForKey:@"Pattern"];
    _patternDesc = [scaleProperties objectForKey:@"PatternDesc"];
    _tempo = tempo;
    
    //if the descending version of the pattern is not present in the properties then build it by reversing the ascending pattern
    if(self.patternDesc == NULL) {
        _patternDesc = [[NSMutableArray alloc] initWithCapacity:[self.pattern count]];
        for(int i=[self.pattern count]-1; i>-1; i--){
            int patternPoint = -[[self.pattern objectAtIndex:i] intValue];
            [_patternDesc addObject: [NSNumber numberWithInt:patternPoint]];
        }
    }
    
    return self;
}

#pragma mark
#pragma mark Object Methods
-(MusicSequence)buildScaleSequenceFromNote:(NSString *)note{
    return [self buildScaleSequenceFromMIDINote:[AMDataAndSettings getMIDIValueForNote:note]];
}
-(MusicSequence)buildScaleSequenceFromMIDINote: (UInt8)startingMIDINote{
    //Get the setting for number of octaves
    NSNumber *octaves = [AMDataAndSettings getOctavesSetting];
    
    //declare and initialize the MusicSequence and MusicTrack holders and add the track to the sequence
    MusicSequence theScaleSequence;
    MusicTrack theScaleTrack;
    NewMusicSequence(&theScaleSequence);
    MusicSequenceNewTrack(theScaleSequence, &theScaleTrack);
    
    //get the tempo track and set the tempo
    MusicSequenceGetTempoTrack(theScaleSequence, &_tempoTrack);
    MusicTrackNewExtendedTempoEvent(_tempoTrack, 0.0, self.tempo);
        
    //create the notes' common attributes
    MIDINoteMessage aNote;
    aNote.channel = 1;
    aNote.velocity = 127;
    aNote.note = startingMIDINote;
    aNote.duration = 1;
    
    MusicTimeStamp noteTime = 0.0;
    MusicTrackNewMIDINoteEvent(theScaleTrack, noteTime, &aNote);
    
    for(int octavePoint = 0; octavePoint<[octaves intValue]; octavePoint++){
        //itterate through the mode pattern to build the scale note by note
        for (int patternPoint=0; patternPoint<[self.pattern count]; patternPoint++){
            //get the number of semitones to the next note from the self.pattern array
            UInt8 semitones = [[self.pattern objectAtIndex:patternPoint] intValue];
            //set the MIDI value and time for the next note
            aNote.note = aNote.note + semitones;
            noteTime += 1.0;
            //add the note to the track
            MusicTrackNewMIDINoteEvent(theScaleTrack, noteTime, &aNote);
        }
    }
    for(int octavePoint = 0; octavePoint<[octaves intValue]; octavePoint++){
        //build the descending scale
        for(int patternPoint = 0; patternPoint<[self.patternDesc count]; patternPoint++){
            //get the number of semitones to the next note from the self.pattern array
            UInt8 semitones = [[self.patternDesc objectAtIndex:patternPoint] intValue];
            //set the MIDI value and time for the next note
            aNote.note = aNote.note + semitones;
            noteTime += 1.0;
            //add the note to the track
            MusicTrackNewMIDINoteEvent(theScaleTrack, noteTime, &aNote);
        }
    }
    
    return theScaleSequence;
}
-(void)changeTempoTo:(Float64)newTempo{
    //change the tempo in the tempo track
    MusicTrackNewExtendedTempoEvent(self.tempoTrack, 0.0, newTempo);
    [self setTempo:newTempo];
}

#pragma mark
#pragma mark Object Management
-(void)disposeScaleSequence:(MusicSequence) sequence{
    UInt32 trackCount;
    MusicSequenceGetTrackCount(sequence, &trackCount); //we will dispose of all tracks in the sequence
    for(int i=0; i<trackCount; i++){
        MusicTrack currentTrack;
        MusicSequenceGetIndTrack(sequence, i, &currentTrack);
        MusicSequenceDisposeTrack(sequence, currentTrack);
    }
    //disponse of the sequence itself
    MusicSequenceGetTrackCount(sequence, &trackCount);
}
@end
