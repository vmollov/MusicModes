//
//  AMSettingsManager.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/5/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

@interface AMDataManager : NSObject
+(AMDataManager *) getInstance;

-(void)updateStatisticsForMode:(NSString *) modeName addPresented:(int)presented addAnswered:(int)answered timeStamp:(NSDate *) timeStamp;

-(NSDictionary *)getPropertiesForMode: (NSString *) modeName;
-(NSArray *)getListOfModes;

-(NSDictionary *)getPlaySettings;
-(NSString *)getSampleSetting;
-(NSNumber *)getOctavesSetting;

-(NSRange) getSampleRangeSetting;

@end
