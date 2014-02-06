//
//  AMUtilities.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/5/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

@interface AMUtilities : NSObject
int randomIntInRange(NSRange range);

UInt8 MIDIValueForNote(NSString* note);
NSString* noteForMIDIValue(UInt8 midiValue);

@end
