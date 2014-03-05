//
//  AMEarTest.h
//  AncientModes
//
//  Created by Vladimir Mollov on 1/26/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMTestChallenge.h"

@interface AMEarTest : NSObject
@property (readonly) NSDate *timeStamp;
@property NSArray *challenges;
@property int challengeIndex;
@property (readonly) int correctAnswersCount, hintsCount;

-(id) initWithNumberOfChallenges: (int) number;

-(AMTestChallenge *) getCurrentChallenge;
-(AMTestChallenge *) getNextChallenge;
-(AMTestChallenge *) getPreviousChallenge;
-(BOOL) hasNextChallenge;
-(BOOL) hasPreviousChallenge;

-(NSArray *) getHint;
-(BOOL) checkAnswer: (NSString *) answer;
-(float) getRunningScore;
@end
