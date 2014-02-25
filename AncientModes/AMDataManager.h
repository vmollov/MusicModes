//
//  AMSettingsManager.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/5/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

@interface AMDataManager : NSObject
+(AMDataManager *) getInstance;

-(void)updateStatisticsForMode:(NSString *) modeName neededHint:(BOOL) withHint testTimeStamp:(NSDate *) timeStamp;

-(NSDictionary *)getPropertiesForMode: (NSString *) modeName;
-(NSArray *)getListOfAllModes;
-(NSArray *)getListOfEnabledModes;

-(NSRange) getCurrentSampleRange;
-(NSRange) getRangeForSample:(NSString *) sample;
-(NSArray *)getListOfSamples;

-(BOOL) mode:(NSString *) mode setEnabled:(BOOL) enabled;
@end
