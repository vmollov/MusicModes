//
//  Mode.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/18/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Statistics;

@interface Mode : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * modeDescription;
@property (nonatomic, retain) NSString * alias;
@property (nonatomic, retain) NSString * variationTo;
@property (nonatomic, retain) NSString * patternAsc;
@property (nonatomic, retain) NSString * patternDesc;
@property (nonatomic, retain) Statistics *statistics;

@end
