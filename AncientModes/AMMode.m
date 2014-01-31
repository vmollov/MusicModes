//
//  AMMode.m
//  AncientModes
//
//  Created by Vladimir Mollov on 1/15/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMMode.h"
#import "AMSettingsAndUtilities.h"

@implementation AMMode
#pragma mark
#pragma mark Object Management
-(id) initWithName:(NSString *)name{
    if(self = [super init]){
        NSDictionary *scaleProperties = [AMSettingsAndUtilities getPropertiesForMode:name];
        if(scaleProperties == nil) [NSException raise:@"Invalid Mode" format:@"%@ is not a recognized mode or it does not exist in the main property list file", name];
        
        //populate the modes's properties from the dictionary
        _name = name;
        _modeDescription = [scaleProperties objectForKey:@"Description"];
        _pattern = [scaleProperties objectForKey:@"Pattern"];
        _patternDesc = [scaleProperties objectForKey:@"PatternDesc"];
        
        //if the descending version of the pattern is not present in the properties then build it by reversing the ascending pattern
        if(self.patternDesc == NULL) {
            _patternDesc = [[NSMutableArray alloc] initWithCapacity:[self.pattern count]];
            for(int i=[self.pattern count]-1; i>-1; i--){
                int patternPoint = -[[self.pattern objectAtIndex:i] intValue];
                [_patternDesc addObject: [NSNumber numberWithInt:patternPoint]];
            }//for
        }//if(scaleProperties == nil)
    }//if(self = [super init])
    
    return self;
}

+(NSString *) generateRandomModeName{
    // get a randome mode index integer then map the mode index to a name from the list
    NSArray *listOfModes = [AMSettingsAndUtilities getListOfModes];
    int mode = [AMSettingsAndUtilities randomIntBetween:0 and:[listOfModes count]-1];
    return [listOfModes objectAtIndex:mode];
}
@end
