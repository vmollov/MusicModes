//
//  AMEnharmonicManager.h
//  AncientModes
//
//  Created by Vladimir Mollov on 3/4/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

@interface AMEnharmonicManager : NSObject

+(AMEnharmonicManager *) getInstance;

-(NSString*) getEnharmonicFromNote:(NSString*) startingNote toMIDINote:(UInt8) destMIDIValue withBaseDistance:(int) baseNoteStep;
-(NSDictionary*) enharmonicsForMIDIValue:(UInt8) midiValue;
@end
