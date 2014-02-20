//
//  AMEarTest.m
//  AncientModes
//
//  Created by Vladimir Mollov on 1/26/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMEarTest.h"

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
        _correctAnswersCount = 0;
        _timeStamp = [NSDate date];
    }//if(self = [super init])
    
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

//This method needs to return mode mane and the number of times it was presented as well as the number of times it was answered correctly.  Currently it gives only mode name + number of times answered correctly
/*-(NSDictionary *) getFinalTestStatistics{
    NSMutableDictionary *scaleStats = [[NSMutableDictionary alloc] initWithCapacity:_challenges.count];
    
    for(int i = 0; i < _challenges.count; i++){
        AMTestChallenge *currentChallenge = [_challenges objectAtIndex:i];
        NSMutableDictionary *challengeStats = [[NSMutableDictionary alloc] initWithCapacity:2];
        
        int answered = currentChallenge.answeredCorrectly?1:0;
        int presented = 1;
    
        if([scaleStats objectForKey:currentChallenge.scale.mode.name]){
            //this scale has already been added so we will just increment the number of presentations and correct answers for it
            NSMutableDictionary *currentStats = [scaleStats objectForKey:currentChallenge.scale.mode.name];
            answered += [[currentStats objectForKey:@"answered"] intValue];
            presented += [[currentStats objectForKey:@"presented"] intValue];
        }
        
        [challengeStats setObject:[NSNumber numberWithInt:answered] forKey:@"answered"];
        [challengeStats setObject:[NSNumber numberWithInt:presented] forKey:@"presented"];
        
        [scaleStats setObject:challengeStats forKey:currentChallenge.scale.mode.name];
    }
    
    return scaleStats;
}*/
@end
