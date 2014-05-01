//
//  AMMode.m
//  AncientModes
//
//  Created by Vladimir Mollov on 1/15/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMMode.h"

@implementation AMMode

-(id)initWithName:(NSString *) name ascPattern: (NSArray *)pattern descPattern: (NSArray *)descPattern stepPattern:(NSArray *)stepPattern stepPatternDesc:(NSArray *)stepPatternDesc variationOf:(NSString *)variation displayName:(NSString *)displayName{
    if(self = [super init]){
        _name = name;
        _pattern = pattern;
        _patternDesc = descPattern;
        _stepPattern = stepPattern;
        _stepPatternDesc = stepPatternDesc;
        _variationMode = variation;
        _displayName = displayName;
        _modeDescription = nil;
        _tips = nil;
        
        //if the descending version of the pattern is not present in the properties then build it by reversing the ascending pattern
        if(self.patternDesc == NULL) {
            NSMutableArray *tmpDescPattern = [[NSMutableArray alloc] initWithCapacity:[self.pattern count]];
            for(int i=(int)[self.pattern count]-1; i>-1; i--){
                int patternPoint = -[[self.pattern objectAtIndex:i] intValue];
                [tmpDescPattern addObject: [NSNumber numberWithInt:patternPoint]];
            }//for
            _patternDesc = tmpDescPattern;
        }
        
        //if stepPattern is empty or contains incorrect number of members generate one using 1 for each step
        if(self.stepPattern == nil || self.stepPattern.count != self.pattern.count){
            NSMutableArray *tmpStepPattern = [[NSMutableArray alloc] initWithCapacity:self.pattern.count];
            for(int i=0; i<self.pattern.count; i++) [tmpStepPattern addObject:[NSNumber numberWithInt:1]];
            _stepPattern = tmpStepPattern;
        }
        //if stepPatternDesc is empty or contains incorrect number of members generate one using 1 for each step
        if(self.stepPatternDesc == nil || self.stepPatternDesc.count != self.patternDesc.count){
            NSMutableArray *tmpStepPattern = [[NSMutableArray alloc] initWithCapacity:self.patternDesc.count];
            for(int i=0; i<self.patternDesc.count; i++) [tmpStepPattern addObject:[NSNumber numberWithInt:-1]];
            _stepPatternDesc = tmpStepPattern;
        }

    }
    
    return self;
}
@end
