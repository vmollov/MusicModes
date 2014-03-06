//
//  AMEnharmonicManager.m
//  AncientModes
//
//  Created by Vladimir Mollov on 3/4/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMEnharmonicManager.h"
#import "AMNote.h"

@interface AMEnharmonicManager ()
@property NSArray *noteToIntMap;
@end
@implementation AMEnharmonicManager

+(AMEnharmonicManager *) getInstance{
    static AMEnharmonicManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(id)init{
    if(self=[super init]){
       _noteToIntMap = @[@"C", @"D", @"E", @"F", @"G", @"A", @"B"];
    }
    return self;
}

-(NSString *)getEnharmonicFromNote:(NSString *)startingNote toMIDINote:(UInt8)destMIDIValue withBaseDistance:(int)baseNoteStep{
    //check if the passed note string is a valid note
    //NSLog(@"Note: %@", startingNote);
    AMNote *noteObj = [[AMNote alloc] initWithString:startingNote];
    
    NSDictionary *enharmonicSet = [self enharmonicsForMIDIValue:destMIDIValue];
    NSDictionary *possibleEnharmonics = [enharmonicSet objectForKey:@"all"];
    
    //if only one enharmonic option is available return it
    if(possibleEnharmonics.count == 1) return [enharmonicSet objectForKey:@"default"];
    
    //get the needed destination base note
    NSString *destinationBaseNote = [self calculateBaseNoteFromNote:noteObj withInterval:baseNoteStep];
    NSString *destinationNote = [possibleEnharmonics objectForKey:destinationBaseNote];
    //if destinationNote is nil no legal value was calculated - return the default
    if(destinationNote == nil) destinationNote = [enharmonicSet objectForKey:@"default"];
    
    //determine whether to return an explicit natural
    AMNote *destNoteObj = [[AMNote alloc] initWithString:destinationNote];
    if([destNoteObj.name isEqualToString:noteObj.name]) destinationNote = destNoteObj.stringValueWithExplicitAccidental;
    
    return destinationNote;
}

#pragma mark - Utility Methods
-(NSString *) calculateBaseNoteFromNote:(AMNote *)startNote withInterval:(int) interval{
    //NSString *baseStartNote = [parseNote(startNote) objectAtIndex:0];
    int startingBaseNoteMap = [self getIntMappingForBaseNote:startNote.name];
    int destinationBaseNoteMap = (startingBaseNoteMap + interval) % 7;
    if (destinationBaseNoteMap<0) destinationBaseNoteMap+=7;
    
    return [self getBaseNoteForIntMap:destinationBaseNoteMap];
}

#pragma mark - Conversion Methods
-(int)getIntMappingForBaseNote:(NSString *)note{
    return (int)[self.noteToIntMap indexOfObject:note];
}
-(NSString *) getBaseNoteForIntMap:(int)noteInt{
    return [self.noteToIntMap objectAtIndex:noteInt];
}

#pragma mark - Data Source
-(NSDictionary*) enharmonicsForMIDIValue:(UInt8) midiValue{
    if(midiValue<12 || midiValue>120)[NSException raise:@"Invalid MIDI Value" format:@"%i is not a valid value.  Must be between 0 and 127.", midiValue];
    int octave = floor(midiValue/12) -1;
    int note = midiValue % 12;
    
    NSString *defaultEnharmonic;
    NSMutableDictionary *enharmonicSet = [NSMutableDictionary dictionaryWithCapacity:3];
    
    switch (note) {
        case 0:
            defaultEnharmonic = [NSString stringWithFormat:@"C%i", octave];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Bs%i", (octave-1)] forKey:@"B"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"C%i", octave]  forKey:@"C"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Dd%i", octave]  forKey:@"D"];
            break;
        case 1:
            defaultEnharmonic = [NSString stringWithFormat:@"Cs%i", octave];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Cs%i", octave] forKey:@"C"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Df%i", octave] forKey:@"D"];
            break;
        case 2:
            defaultEnharmonic = [NSString stringWithFormat:@"D%i", octave];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Cx%i", octave] forKey:@"C"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"D%i", octave] forKey:@"D"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Ed%i", octave] forKey:@"E"];
            break;
        case 3:
            defaultEnharmonic = [NSString stringWithFormat:@"Ef%i", octave];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Ds%i", octave] forKey:@"D"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Ef%i", octave] forKey:@"E"];
            break;
        case 4:
            defaultEnharmonic = [NSString stringWithFormat:@"E%i", octave];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Dx%i", octave] forKey:@"D"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"E%i", octave] forKey:@"E"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Ff%i", octave] forKey:@"F"];
            break;
        case 5:
            defaultEnharmonic = [NSString stringWithFormat:@"F%i", octave];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Es%i", octave] forKey:@"E"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"F%i", octave] forKey:@"F"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Gd%i", octave] forKey:@"G"];
            break;
        case 6:
            defaultEnharmonic = [NSString stringWithFormat:@"Fs%i", octave];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Fs%i", octave] forKey:@"F"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Gf%i", octave] forKey:@"G"];
            break;
        case 7:
            defaultEnharmonic = [NSString stringWithFormat:@"G%i", octave];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Fx%i", octave] forKey:@"F"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"G%i", octave] forKey:@"G"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Ad%i", octave] forKey:@"A"];
            break;
        case 8:
            defaultEnharmonic = [NSString stringWithFormat:@"Af%i", octave];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Gs%i", octave] forKey:@"G"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Af%i", octave] forKey:@"A"];
            break;
        case 9:
            defaultEnharmonic = [NSString stringWithFormat:@"A%i", octave];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Gx%i", octave] forKey:@"G"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"A%i", octave] forKey:@"A"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Bd%i", octave] forKey:@"B"];
            break;
        case 10:
            defaultEnharmonic = [NSString stringWithFormat:@"Bf%i", octave];
            [enharmonicSet setObject:[NSString stringWithFormat:@"As%i", octave] forKey:@"A"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Bf%i", octave] forKey:@"B"];
            break;
        case 11:
            defaultEnharmonic = [NSString stringWithFormat:@"B%i", octave];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Ax%i", octave] forKey:@"A"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"B%i", octave] forKey:@"B"];
            [enharmonicSet setObject:[NSString stringWithFormat:@"Cf%i", (octave+1)] forKey:@"C"];
            break;
        default:
            break;
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:defaultEnharmonic, @"default", enharmonicSet, @"all" , nil];
}

@end
