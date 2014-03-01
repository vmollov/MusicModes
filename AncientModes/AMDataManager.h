//
//  AMSettingsManager.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/5/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMUtilities.h"

@interface AMDataManager : NSObject
+(AMDataManager *) getInstance;

-(NSDictionary *) getStatisticsForMode:(NSString *) modeName;
-(void)updateStatisticsForMode:(NSString *) modeName correct:(BOOL)correct neededHint:(BOOL) withHint testTimeStamp:(NSDate *) timeStamp;
-(void)eraseAllStatistics;

-(NSDictionary *)getPropertiesForMode: (NSString *) modeName;
-(NSArray *)getListOfAllModes;
-(NSArray *)getListOfEnabledModes;

-(NSRange) getCurrentSampleRange;
-(NSRange) getRangeForSample:(NSString *) sample;
-(NSArray *)getListOfSamples;

-(BOOL) mode:(NSString *) mode setEnabled:(BOOL) enabled;
@end
