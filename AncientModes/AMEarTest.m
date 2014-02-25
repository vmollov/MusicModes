//
//  AMEarTest.m
//  AncientModes
//
//  Created by Vladimir Mollov on 1/26/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMEarTest.h"
#import "AMUtilities.h"

@implementation AMEarTest
-(id)initWithNumberOfChallenges: (int) number{
    if(self = [super init]){
        NSMutableArray *theChallenges = [[NSMutableArray alloc] initWithCapacity:number];
        for(int i=0; i<number; i++){
            //create a random challenge and add it to the mutable array
            [theChallenges addObject:[[AMTestChallenge alloc] initWithRandModeRandNote]];
        }
        _challenges = [[NSArray alloc] initWithArray:theChallenges];
        _challengeIndex = -1;
        _correctAnswersCount = _hintsCount = 0;
        _timeStamp = [NSDate date];
    }
    
    return self;
}

#pragma mark Navigate Challenges
-(AMTestChallenge *) getCurrentChallenge{
    if (self.challengeIndex < 0) return [self getNextChallenge];
    return [self.challenges objectAtIndex:self.challengeIndex];
}
-(AMTestChallenge *) getNextChallenge{
    if(self.hasNextChallenge){
        self.challengeIndex++;
        return [self getCurrentChallenge];
    }else{
        return nil;
    }
}
-(AMTestChallenge *) getPreviousChallenge{
    if(self.hasPreviousChallenge){
        self.challengeIndex--;
        return [self getCurrentChallenge];
    }else{
        return nil;
    }
}
-(BOOL)hasNextChallenge{
    return self.challengeIndex < (int)[self.challenges count] - 1;
}
-(BOOL)hasPreviousChallenge{
    return self.challengeIndex > 0;
}

#pragma mark Score Keeping
-(BOOL) checkAnswer: (NSString *) answer{
    BOOL correct = [self.getCurrentChallenge.scale.mode.name compare:answer] == NSOrderedSame;
    self.getCurrentChallenge.answeredCorrectly = correct;
    if(correct) _correctAnswersCount++;
    return correct;
}
-(double) getFinalTestScorePercentage{
    float result = ((float)_correctAnswersCount/(float)[_challenges count])*100;
    return result;
}

@end
