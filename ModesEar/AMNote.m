//
//  AMNote.m
//  AncientModes
//
//  Created by Vladimir Mollov on 3/5/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMNote.h"

@implementation AMNote

-(id)initWithString:(NSString*)note{
    if(self = [super init]){
        //NSLog(@"Creating note: %@", note);
        if(![AMNote isNoteValid:note]) [NSException raise:@"Invalid Note" format:@"Notes have to be in the format A-G(s,f)1-8"];
        NSString *noteName = [[note substringWithRange:NSMakeRange(0,1)] uppercaseString];
        //check if accidental was passed
        NSString *noteAccidental = [note substringWithRange:NSMakeRange(1, 1)];
        NSString *octave;
        if ([[noteAccidental lowercaseString] isEqualToString: @"s"] || [[noteAccidental lowercaseString] isEqualToString:@"f"] || [[noteAccidental lowercaseString] isEqualToString:@"x"] || [[noteAccidental lowercaseString] isEqualToString:@"d"] || [[noteAccidental lowercaseString] isEqualToString:@"n"]){
            
            //noteName = [[[note substringWithRange:NSMakeRange(0,1)] uppercaseString] stringByAppendingString:[[note substringWithRange:NSMakeRange(1, 1)] lowercaseString]];
            octave = [note substringWithRange:NSMakeRange(2,1)];
        }else{
            noteAccidental = @"";
            octave = [note substringWithRange:NSMakeRange(1,1)];
        }

        _name = noteName;
        _accidental = noteAccidental;
        _octave = [octave intValue];
        
        //calculate the midi value for note
        NSDictionary *noteNumValues = @{@"C":@0, @"D":@2, @"E":@4, @"F":@5, @"G":@7, @"A":@9, @"B":@11};
        
        UInt8 noteValue =[[noteNumValues objectForKey:_name] intValue];
        if([_accidental isEqualToString:@"d"]) noteValue = noteValue - 2;
        if([_accidental isEqualToString:@"f"]) noteValue = noteValue - 1;
        if([_accidental isEqualToString:@"s"]) noteValue = noteValue + 1;
        if([_accidental isEqualToString:@"x"]) noteValue = noteValue + 2;
        
        //compute the note - add 12 since the map for C0 starts at value 12 - there is a -1 octave which we are ignoring
        _MIDIValue =  12 + (_octave *12 + noteValue);
    }
    
    return self;
}

/*-(NSString *)stringValue{
    return [[self.name stringByAppendingString:self.accidental] stringByAppendingString:[NSString stringWithFormat:@"%i", self.octave]];
}*/
-(NSString *)stringValueWithExplicitAccidental{
    NSString *returnAccidental = ([self.accidental isEqualToString:@""])?@"n":self.accidental;
    return[[self.name stringByAppendingString:returnAccidental] stringByAppendingString:[NSString stringWithFormat:@"%i", self.octave]];
}

#pragma mark - Static Methods
+(BOOL) isNoteValid:(NSString*) noteName{
    NSError *checkError;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[A-G][s,f,x,d,n]?[1-8]$" options:NSRegularExpressionCaseInsensitive error:&checkError];
    int numberOfMatches = (int)[regex numberOfMatchesInString:noteName options:0 range:NSMakeRange(0, [noteName length])];
    return (numberOfMatches > 0);

}
@end
