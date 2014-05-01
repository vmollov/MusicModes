//
//  AMNote.h
//  AncientModes
//
//  Created by Vladimir Mollov on 3/5/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

@interface AMNote : NSObject
@property NSString *name, *accidental;
@property int octave;
@property UInt8 MIDIValue;

-(id)initWithString:(NSString*)note;

//-(NSString *)stringValue;
-(NSString *)stringValueWithExplicitAccidental;

+(BOOL) isNoteValid:(NSString*) noteName;
@end
