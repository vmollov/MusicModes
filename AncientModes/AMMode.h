//
//  AMMode.h
//  AncientModes
//
//  Created by Vladimir Mollov on 1/15/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

@interface AMMode : NSObject
@property (readonly) NSString *name, *description, *alias, *variationMode;
@property (readonly) NSArray *pattern, *patternDesc;

-(id)initWithName:(NSString *) name description:(NSString *)description ascPattern: (NSArray *)pattern descPattern: (NSArray *)descPattern alias: (NSString *)alias variationOf: (NSString *) variation;

-(BOOL)isAliasToMode:(NSString *)checkMode;
@end
