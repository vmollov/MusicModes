//
//  AMMode.m
//  AncientModes
//
//  Created by Vladimir Mollov on 1/15/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMMode.h"

@implementation AMMode

-(id)initWithName:(NSString *) name description:(NSString *)description ascPattern: (NSArray *)pattern descPattern: (NSArray *)descPattern variationOf: (NSString *) variation{
    if(self = [super init]){
        _name = name;
        _description = description;
        _pattern = pattern;
        _patternDesc = descPattern;
        _variationMode = variation;
        
        //if the descending version of the pattern is not present in the properties then build it by reversing the ascending pattern
        if(self.patternDesc == NULL) {
            NSMutableArray *tmpDescPattern = [[NSMutableArray alloc] initWithCapacity:[self.pattern count]];
            for(int i=(int)[self.pattern count]-1; i>-1; i--){
                int patternPoint = -[[self.pattern objectAtIndex:i] intValue];
                [tmpDescPattern addObject: [NSNumber numberWithInt:patternPoint]];
            }//for
            _patternDesc = tmpDescPattern;
        }
    }
    
    return self;
}
@end
