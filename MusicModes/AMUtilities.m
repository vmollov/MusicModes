//
//  AMUtilities.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/5/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMUtilities.h"

@implementation AMUtilities

#pragma mark - pragma mark Utility Methods
uint32_t randomIntInRange(NSRange range){
    uint32_t lowBound = (uint32_t)range.location;
    uint32_t highBound = (uint32_t)range.length;
    return arc4random_uniform(highBound - lowBound + 1) + lowBound;
}
@end
