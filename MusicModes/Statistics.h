//
//  Statistics.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/20/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Statistics : NSManagedObject

@property (nonatomic, retain) NSString * mode;
@property (nonatomic, retain) NSNumber * numAnswered;
@property (nonatomic, retain) NSNumber * numPresented;
@property (nonatomic, retain) NSDate * testTimeStamp;

@end
