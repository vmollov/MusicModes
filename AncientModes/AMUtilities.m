//
//  AMUtilities.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/5/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMUtilities.h"

@implementation AMUtilities

#pragma mark - pragma mark Utility Methods
uint32_t randomIntInRange(NSRange range){
    uint32_t lowBound = (uint32_t)range.location;
    uint32_t highBound = (uint32_t)range.length;
    return arc4random_uniform(highBound - lowBound + 1) + lowBound;
}

#pragma mark - pragma mark Conversion Methods
UInt8 MIDIValueForNote(NSString* note){
    //check if the passed note string is a valid note
    NSError *checkError;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[A-G][s,f]?[1-8]$" options:NSRegularExpressionCaseInsensitive error:&checkError];
    int numberOfMatches = (int)[regex numberOfMatchesInString:note options:0 range:NSMakeRange(0, [note length])];
    if(numberOfMatches < 1) [NSException raise:@"Invalid Note" format:@"Notes have to be in the format A-G(s,f)1-8"];
    
    //parse the note and get it into format of A-G{s,f}0-9
    NSString *noteName = [[note substringWithRange:NSMakeRange(0,1)] uppercaseString];
    //check if accidental was passed
    NSString *noteAccidental = [note substringWithRange:NSMakeRange(1, 1)];
    int octave;
    if ([[noteAccidental lowercaseString] isEqualToString: @"s"] || [[noteAccidental lowercaseString] isEqualToString:@"f"]){
        noteName = [[[note substringWithRange:NSMakeRange(0,1)] uppercaseString] stringByAppendingString:[[note substringWithRange:NSMakeRange(1, 1)] lowercaseString]];
        octave = [[note substringWithRange:NSMakeRange(2,1)] intValue];
    }else octave = [[note substringWithRange:NSMakeRange(1,1)] intValue];
    
    //enumerate the notes and give them integer values
    NSDictionary *noteNumValues = @{
                                    @"C":@0, @"Bs":@0,
                                    @"Cs":@1, @"Df":@1,
                                    @"D":@2,
                                    @"Ds":@3, @"Ef":@3,
                                    @"E":@4, @"Ff":@4,
                                    @"F":@5, @"Es":@5,
                                    @"Fs":@6, @"Gf":@6,
                                    @"G":@7,
                                    @"Gs":@8, @"Af":@8,
                                    @"A":@9,
                                    @"As":@10, @"Bf":@10,
                                    @"B":@11, @"Cf":@11,
                                    };
    UInt8 noteValue =[[noteNumValues objectForKey:noteName] intValue];
    //compute the note - add 12 since the map for C0 starts at value 12 - there is a -1 octave which we are ignoring
    return 12 + (octave*12 + noteValue);
}

NSString* noteForMIDIValue(UInt8 midiValue){
    if(midiValue>127)[NSException raise:@"Invalid MIDI Value" format:@"%i is not a valid value.  Must be between 0 and 127.", midiValue];
    int octave = floor(midiValue/12) -1;
    int note = midiValue % 12;
    
    switch (note) {
        case 0:
            return [NSString stringWithFormat:@"C%i", octave];
            break;
        case 1:
            return [NSString stringWithFormat:@"Cs%i", octave];
            break;
        case 2:
            return [NSString stringWithFormat:@"D%i", octave];
            break;
        case 3:
            return [NSString stringWithFormat:@"Ds%i", octave];
            break;
        case 4:
            return [NSString stringWithFormat:@"E%i", octave];
            break;
        case 5:
            return [NSString stringWithFormat:@"F%i", octave];
            break;
        case 6:
            return [NSString stringWithFormat:@"Fs%i", octave];
            break;
        case 7:
            return [NSString stringWithFormat:@"G%i", octave];
            break;
        case 8:
            return [NSString stringWithFormat:@"Gs%i", octave];
            break;
        case 9:
            return [NSString stringWithFormat:@"A%i", octave];
            break;
        case 10:
            return [NSString stringWithFormat:@"As%i", octave];
            break;
        case 11:
            return [NSString stringWithFormat:@"B%i", octave];
            break;
        default:
            break;
    }
    return nil;
}

@end
