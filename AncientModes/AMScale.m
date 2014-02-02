//
//  AMScale.m
//  AncientModes
//
//  Created by Vladimir Mollov on 1/26/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMScale.h"
#import "AMSettingsAndUtilities.h"

@implementation AMScale

#pragma mark
#pragma mark Object Management
-(id)initWithModeName: (NSString *) modeName baseNote:(NSString *) baseNote{
    UInt8 baseMIDINote = [AMSettingsAndUtilities getMIDIValueForNote:baseNote];
    return [self initWithModeName:modeName baseMIDINote:baseMIDINote];
}
-(id)initWithModeName: (NSString *) modeName baseMIDINote:(UInt8) baseMIDINote{
    if(self = [super init]){
        @try{
            _baseMIDINote = baseMIDINote;
            _mode = [[AMMode alloc] initWithName: modeName];
        }@catch (NSException *e) {
            NSLog(@"Exception occured: %@", e);
            return nil;
        }
    }//if(self = [super init])
   
    return self;
}
#pragma mark
#pragma mark Accessor Methods
-(NSString *) baseNote{
    return [AMSettingsAndUtilities getNoteForMIDIValue:self.baseMIDINote];
}
-(void) setBaseNote: (NSString *) note{
    self.baseMIDINote = [AMSettingsAndUtilities getMIDIValueForNote:note];
}
#pragma mark
#pragma mark Methods to Build and Play Scales
-(void)playScale{
    [[AMScalesPlayer sharedInstance] playSequence:[self scaleSequence]];
}

-(MusicSequence)scaleSequence{
    return [self buildSequenceInascending:true descending:true];
}
-(MusicSequence)scaleSequenceAsc{
    return [self buildSequenceInascending:true descending:false];
}
-(MusicSequence)scaleSequenceDesc{
    return [self buildSequenceInascending:false descending:true];
}

-(MusicSequence)buildSequenceInascending: (BOOL)ascending descending: (BOOL) descending{
    //Get the settings
    NSNumber *octaves = [AMSettingsAndUtilities getOctavesSetting];
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
    aNote.note = (!ascending && descending)? self.baseMIDINote + ([octaves intValue] *12):self.baseMIDINote;
    aNote.duration = 1;
    
    MusicTimeStamp noteTime = 0.0;
    MusicTrackNewMIDINoteEvent(theScaleTrack, noteTime, &aNote);
    
    for(int octavePoint = 0; octavePoint<[octaves intValue]; octavePoint++){
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
    }
    for(int octavePoint = 0; octavePoint<[octaves intValue]; octavePoint++){
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
    }
    
    return theScaleSequence;
}

+(AMScale *)generateRandomScale{
    //select a random starting MIDI note value
    UInt8 startingNote = [AMSettingsAndUtilities getRandomNoteWithinSampleRangeAdjustingForOctaves];
    //get a random mode
    NSString *randomModeName = [AMMode generateRandomModeName];
    
    return [[AMScale alloc] initWithModeName:randomModeName baseMIDINote:startingNote];
}
@end
