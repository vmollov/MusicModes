//
//  AMPersistencyManager.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/5/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//
#import "AMScale.h"

@interface AMScalesManager : NSObject
+(AMScalesManager *) getInstance;

-(AMMode *) createModeFromName:(NSString *) name;

-(NSString *) generateRandomModeName;
-(AMScale *)generateRandomScale;
@end
