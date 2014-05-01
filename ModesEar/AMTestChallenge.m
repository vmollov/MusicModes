//
//  AMTestChallenge.m
//  AncientModes
//
//  Created by Vladimir Mollov on 1/26/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMTestChallenge.h"
#import "AMScalesManager.h"
#import "NSMutableArray+Shuffling.h"
#import "AMUtilities.h"

@implementation AMTestChallenge

-(id)initWithScale:(AMScale *)scale numberOfPresentedAnswers:(int)presentedAnswersCount{
    if(self = [super init]){
        _scale = scale;
        
        //generate the presented answers
        //get the variation mode so we can include it in the presented answers
        NSString *variationMode = _scale.mode.variationMode;
        
        //generate the answers
        int index = 0;
        NSMutableArray *randomAnswers = [[NSMutableArray alloc] initWithCapacity:presentedAnswersCount];
        
        //add the correct answer
        [randomAnswers addObject:_scale.mode.name];
        index++; //to account for adding the correct answer
        
        //add the variation mode
        if(variationMode != nil && [[NSUserDefaults standardUserDefaults] boolForKey:variationMode]){
            [randomAnswers addObject:variationMode];
            index++; //to account for adding the variation mode
        }
        
        for(index = index; index<presentedAnswersCount; index++){
            NSString *randomModeAnswer = [[AMScalesManager getInstance] generateRandomModeName];
            BOOL skip = false;
            
            //prevent a RandomModeAnswer to be put in the pool more than once
            for(int n=0; n<index; n++){
                if([randomModeAnswer compare:[randomAnswers objectAtIndex:n]] == NSOrderedSame){
                    skip =true;
                    break;
                }
            }
            
            //if this random answer has failed a requirement we will not use it
            if (skip){
                index--;
                continue;
            }
            [randomAnswers addObject:randomModeAnswer];
        }
        
        //randomize the order of the answers
        [randomAnswers shuffle];
        
        _presentedAnswers = randomAnswers;
        for(int i=0; i<_presentedAnswers.count; i++){
            if([_scale.mode.name compare:[_presentedAnswers objectAtIndex:i]] == NSOrderedSame){
                _correctAnswerIndex = i;
                break;
            }
        }
        
        //initialize the rest of the members
        _usedHint = NO;
    }

    return self;
}

-(id)initWithRandModeRandNoteAndnumberOfPresentedAnswers:(int)presentedAnswersCount{
    AMScale *challengeScale = [[AMScalesManager getInstance] generateRandomScale];
    
    return [self initWithScale:challengeScale numberOfPresentedAnswers:presentedAnswersCount];
}
-(id)initWithRandModeStartingOnNote:(UInt8)startingNote numberOfPresentedAnswers:(int)presentedAnswersCount{
    AMScale *challengeScale = [[AMScalesManager getInstance] generateRandomScaleFromNote:startingNote];
    
    return [self initWithScale:challengeScale numberOfPresentedAnswers:presentedAnswersCount];
}

-(NSArray *)getHint{
    if(!self.answered)self.usedHint = YES;
    return [self.scale getNotesUseDescending:randomIntInRange(NSMakeRange(0, 1))];
}

@end