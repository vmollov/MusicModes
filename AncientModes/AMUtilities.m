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

#pragma mark - Validation Methods
BOOL isNoteValid(NSString* noteName){
    NSError *checkError;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[A-G][s,f,x,d]?[1-8]$" options:NSRegularExpressionCaseInsensitive error:&checkError];
    int numberOfMatches = (int)[regex numberOfMatchesInString:noteName options:0 range:NSMakeRange(0, [noteName length])];
    return (numberOfMatches > 0);
}

#pragma mark - pragma mark Conversion Methods
NSArray* parseNote(NSString* note){
    if(!isNoteValid(note)) return nil;
    
    NSString *noteName = [[note substringWithRange:NSMakeRange(0,1)] uppercaseString];
    //check if accidental was passed
    NSString *noteAccidental = [note substringWithRange:NSMakeRange(1, 1)];
    NSString *octave;
    if ([[noteAccidental lowercaseString] isEqualToString: @"s"] || [[noteAccidental lowercaseString] isEqualToString:@"f"] || [[noteAccidental lowercaseString] isEqualToString:@"x"] || [[noteAccidental lowercaseString] isEqualToString:@"d"]){
        
        //noteName = [[[note substringWithRange:NSMakeRange(0,1)] uppercaseString] stringByAppendingString:[[note substringWithRange:NSMakeRange(1, 1)] lowercaseString]];
        octave = [note substringWithRange:NSMakeRange(2,1)];
    }else{
        noteAccidental = @"";
        octave = [note substringWithRange:NSMakeRange(1,1)];
    }
    
    return @[noteName, noteAccidental, octave];
}

UInt8 MIDIValueForNote(NSString* note){
    //check if the passed note string is a valid note
    if(!isNoteValid(note)) [NSException raise:@"Invalid Note" format:@"Notes have to be in the format A-G(s,f,x,d)1-8"];
   
    NSArray *parsedNote = parseNote(note);
    NSString *noteName = [[parsedNote objectAtIndex:0] stringByAppendingString:[parsedNote objectAtIndex:1]];
    int octave = [[parsedNote objectAtIndex:2] intValue];
    
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
@end
