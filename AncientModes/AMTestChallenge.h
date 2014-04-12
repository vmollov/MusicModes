//
//  AMTestChallenge.h
//  AncientModes
//
//  Created by Vladimir Mollov on 1/26/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMScale.h"

@interface AMTestChallenge : NSObject
@property AMScale *scale;
@property NSArray *presentedAnswers;
@property int correctAnswerIndex;
@property BOOL answered, answeredCorrectly, usedHint;

-(id)initWithScale:(AMScale *)scale numberOfPresentedAnswers:(int)presentedAnswersCount;
-(id)initWithRandModeRandNoteAndnumberOfPresentedAnswers:(int)presentedAnswersCount;
-(id)initWithRandModeStartingOnNote:(UInt8)startingNote numberOfPresentedAnswers:(int)presentedAnswersCount;

-(NSArray *) getHint;

@end

//make number of presented answers a config change