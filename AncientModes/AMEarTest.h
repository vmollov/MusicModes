//
//  AMEarTest.h
//  AncientModes
//
//  Created by Vladimir Mollov on 1/26/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMTestChallenge.h"

@interface AMEarTest : NSObject
@property NSArray *challenges;
@property int challengeIndex;
@property (readonly) int correctAnswersCount;

-(id) initWithNumberOfChallenges: (int) number;

-(AMTestChallenge *) getCurrentChallenge;
-(AMTestChallenge *) getNextChallenge;
-(AMTestChallenge *) getPreviousChallenge;
-(BOOL) hasNextChallenge;
-(BOOL) hasPreviousChallenge;

-(BOOL) checkAnswer: (NSString *) answer;
-(double) getFinalTestScorePercentage;
@end
