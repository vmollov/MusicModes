//
//  AMEarTest.m
//  AncientModes
//
//  Created by Vladimir Mollov on 1/26/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMEarTest.h"
#import "AMNote.h"

@implementation AMEarTest
-(id)initWithNumberOfChallenges: (int) number{
    return [self initWithNumberOfChallenges:number startingNote:nil];
}
-(id)initWithNumberOfChallenges:(int)number startingNote:(NSString *)startingNote{
    if(self = [super init]){
        NSMutableArray *theChallenges = [[NSMutableArray alloc] initWithCapacity:number];
        for(int i=0; i<number; i++){
            //create a random challenge and add it to the mutable array
            if(startingNote == nil)[theChallenges addObject:[[AMTestChallenge alloc] initWithRandModeRandNote]];
            else {
                UInt8 note = [[[AMNote alloc] initWithString:startingNote] MIDIValue];
                [theChallenges addObject:[[AMTestChallenge alloc] initWithRandModeStartingOnNote:note]];
            }
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
-(NSArray *) getHint{
    if(!self.getCurrentChallenge.usedHint && !self.getCurrentChallenge.answered) _hintsCount++;
    return self.getCurrentChallenge.getHint;
}
-(BOOL) checkAnswer: (NSString *) answer{
    BOOL correct = [self.getCurrentChallenge.scale.mode.name compare:answer] == NSOrderedSame;
    self.getCurrentChallenge.answeredCorrectly = correct;
    self.getCurrentChallenge.answered = YES;
    if(correct) _correctAnswersCount++;
    return correct;
}
-(float) getRunningScore{
    int runningScore = 0;
    int answerCount = 0;
    for(int i=0; i<=self.challengeIndex; i++){
        AMTestChallenge *challenge = [self.challenges objectAtIndex:i];
        if(challenge.answered){
            if(challenge.answeredCorrectly){
                runningScore = challenge.usedHint?runningScore+1:runningScore+3;
            }
            answerCount++;
        }
    }
    
    return (((float)runningScore/3)/((float)answerCount))*100;
}
@end
