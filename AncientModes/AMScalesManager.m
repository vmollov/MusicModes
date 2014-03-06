//
//  AMPersistencyManager.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/5/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMScalesManager.h"
#import "AMDataManager.h"
#import "AMUtilities.h"

@implementation AMScalesManager
+(AMScalesManager *) getInstance{
    static AMScalesManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(AMMode *) createModeFromName:(NSString *) name{
    NSDictionary *scaleProperties = [[AMDataManager getInstance] getPropertiesForMode:name];
    if(scaleProperties == nil) [NSException raise:@"Invalid Mode" format:@"%@ is not a recognized mode or it does not exist in the main property list file", name];
    
    //if this mode is a pattern of a different mode switch to it
    NSString *patternOf = [scaleProperties objectForKey:@"PatternOf"];
    NSString *displayName = [NSString stringWithFormat:@"%@", name];
    if(patternOf != nil) {
        scaleProperties = [[AMDataManager getInstance] getPropertiesForMode:patternOf];
        name = patternOf;
    }
    
    NSArray *pattern = [scaleProperties objectForKey:@"Pattern"];
    NSArray *patternDesc = [scaleProperties objectForKey:@"PatternDesc"];
    NSArray *stepPattern = [scaleProperties objectForKey:@"stepPattern"];
    NSArray *stepPatternDesc = [scaleProperties objectForKey:@"stepPatternDesc"];
    
    NSString *variationMode = [scaleProperties objectForKey:@"VariationOf"];
    
    return [[AMMode alloc] initWithName:name ascPattern:pattern descPattern:patternDesc stepPattern:stepPattern stepPatternDesc:stepPatternDesc variationOf:variationMode displayName:displayName];
}
-(AMMode *) createModeWithDescriptionFromName:(NSString *) name{
    AMMode *result = [self createModeFromName:name];
    NSDictionary *scaleProperties = [[AMDataManager getInstance] getPropertiesForMode:name];
    result.modeDescription = [scaleProperties objectForKey:@"Description"];
    result.tips = [scaleProperties objectForKey:@"listenFor"];
    return result;
}

-(NSString *) generateRandomModeName{
    NSArray *listOfModes = [[AMDataManager getInstance] getListOfEnabledModes];
    // get a randome mode index integer then map the mode index to a name from the list
    NSUInteger mode = randomIntInRange(NSMakeRange(0, listOfModes.count -1));
    return [listOfModes objectAtIndex:mode];
}

-(AMScale *)generateRandomScale{
    NSRange range = [[AMDataManager getInstance] getCurrentSampleRange];
    //adjust the range high note with one octave (to allow for the scale to be built
    range.length -= 12;
    //select a random starting MIDI note value
    UInt8 startingNote = (UInt8)randomIntInRange(range);
    
    return [self generateRandomScaleFromNote:startingNote];
}
-(AMScale *)generateRandomScaleFromNote:(UInt8)startingNote{
    //get a random mode
    NSString *randomModeName = [self generateRandomModeName];
    AMMode *mode = [self createModeFromName:randomModeName];
    
    return [[AMScale alloc] initWithMode:mode baseMIDINote:startingNote];
}
@end
