//
//  AMSettingsManager.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/5/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

@interface AMDataManager : NSObject
+(AMDataManager *) getInstance;

-(float)getStatisticsAverageForMode:(NSString *)modeName;
-(NSDictionary*)getStatisticsProgressForMode:(NSString *)modeName;

-(void)updateStatisticsForMode:(NSString *) modeName correct:(BOOL)correct neededHint:(BOOL) withHint testTimeStamp:(NSDate *) timeStamp;
-(void)eraseAllStatistics;

-(NSString *) getIdForProductPurchase:(NSString *) theProduct;

-(NSDictionary *)getPropertiesForMode: (NSString *) modeName;
-(NSDictionary *) getListOfAllGroups;
-(NSString *) getNameForGroupId:(int) groupId;
-(NSArray *)getListOfAllModesUseDisplayName:(BOOL) displayName grouped:(BOOL) grouped;
-(NSArray *) getListOfModesInGroup:(int) group useDisplayName:(BOOL) displayName;
-(NSArray *)getListOfEnabledModes;

-(NSRange) getCurrentSampleRange;
-(NSRange) getRangeForSample:(NSString *) sample;
-(NSArray *)getListOfSamples;

-(BOOL) mode:(NSString *) mode setEnabled:(BOOL) enabled;
-(BOOL) isModeAvailable:(NSString *) mode;
@end
