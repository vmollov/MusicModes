//
//  NSMutableArray+Shuffling.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/2/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//
// This category enhances NSMutableArray by providing methods to randomly shuffle the elements using the Fisher-Yates algorithm.

#import <Foundation/Foundation.h>

@interface NSMutableArray (Shuffling)
-(void)shuffle;
@end
