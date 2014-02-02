//
//  NSMutableArray+Shuffling.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/2/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "NSMutableArray+Shuffling.h"

@implementation NSMutableArray (Shuffling)
- (void)shuffle{
    NSUInteger count = [self count];
    for (uint i = 0; i < count; ++i){
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = arc4random_uniform(nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
