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
@property BOOL answeredCorrectly;

-(id)initWithScale:(AMScale *)scale presentedAnsers: (NSArray *) answers;
-(id)initWithRandModeRandNote;

@end
