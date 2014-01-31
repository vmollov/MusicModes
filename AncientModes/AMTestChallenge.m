//
//  AMTestChallenge.m
//  AncientModes
//
//  Created by Vladimir Mollov on 1/26/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMTestChallenge.h"
#import "AMSettingsAndUtilities.h"

@implementation AMTestChallenge

-(id)initWithRandModeRandNote{
    //select a random starting MIDI note value - use values between octaves 1 and 8 (ignore octaves -1, 0, and 9)
    UInt8 startingNote = [AMSettingsAndUtilities getRandomNoteWithinSampleRangeAdjustingForOctaves];
    NSString *randomModeName = [AMMode generateRandomModeName];
    
    AMScale *challengeScale = [[AMScale alloc] initWithModeName:randomModeName baseMIDINote:startingNote];
    
    //generate the presented answers
    NSMutableArray *randomAnswers = [[NSMutableArray alloc] initWithCapacity:4];
    for(int i=0; i<[randomAnswers count]; i++){
        [randomAnswers addObject:[AMMode generateRandomModeName]];
    }
    
    return [self initWithScale:challengeScale presentedAnsers:randomAnswers];
}
-(id)initWithScale:(AMScale *)scale presentedAnsers:(NSArray *)answers{
    if(self = [super init]){
        _scale = scale;
        _presentedAnswers = [[NSArray alloc]initWithArray:answers];
    }//if(self = [super init])

    return self;
}

@end

//remmeber to adjust the piano aupreset to include the full piano range