//
//  AMPropertyReader.h
//  AncientModes
//
//  Created by Vladimir Mollov on 1/21/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//
// This is a class for reading and writing application properties to the Info.plist file

@interface AMDataAndSettings : NSObject

+(NSDictionary *)getPropertiesForMode: (NSString *) modeName;
+(NSDictionary *)getPlaySettings;
+(NSString *)getSampleSetting;
+(NSNumber *)getOctavesSetting;
+(UInt8)getMIDIValueForNote:(NSString *) note;
+(NSString *)getNoteForMIDIValue:(UInt8) midiValue;
@end
