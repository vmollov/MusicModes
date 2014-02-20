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
    NSString *description = [scaleProperties objectForKey:@"Description"];
    NSArray *pattern = [scaleProperties objectForKey:@"Pattern"];
    NSArray *patternDesc = [scaleProperties objectForKey:@"PatternDesc"];
    NSString *variationMode = [scaleProperties objectForKey:@"VariationOf"];
    
    return [[AMMode alloc] initWithName:name description:description ascPattern:pattern descPattern:patternDesc variationOf:variationMode];
}

-(NSString *) generateRandomModeName{
    NSArray *listOfModes = [[AMDataManager getInstance] getListOfModes];
    // get a randome mode index integer then map the mode index to a name from the list
    NSUInteger mode = randomIntInRange(NSMakeRange(0, listOfModes.count -1));
    return [listOfModes objectAtIndex:mode];
}

-(AMScale *)generateRandomScale{
    NSRange range = [[AMDataManager getInstance] getSampleRangeSetting];
    //select a random starting MIDI note value
    UInt8 startingNote = (UInt8)randomIntInRange(range);
    //get a random mode
    NSString *randomModeName = [self generateRandomModeName];
    AMMode *mode = [self createModeFromName:randomModeName];
    
    return [[AMScale alloc] initWithMode:mode baseMIDINote:startingNote];
}

@end
