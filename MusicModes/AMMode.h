//
//  AMMode.h
//  AncientModes
//
//  Created by Vladimir Mollov on 1/15/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

@interface AMMode : NSObject
@property (readonly) NSString *name, *variationMode, *displayName;
@property (readonly) NSArray *pattern, *patternDesc, *stepPattern, *stepPatternDesc;
@property NSString *modeDescription;
@property NSArray *tips;

-(id)initWithName:(NSString *) name ascPattern: (NSArray *)pattern descPattern: (NSArray *)descPattern stepPattern:(NSArray *)stepPattern stepPatternDesc:(NSArray *)stepPatternDesc variationOf: (NSString *) variation displayName:(NSString *)displayName;

@end
