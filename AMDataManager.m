//
//  AMSettingsManager.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/5/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMDataManager.h"

@interface AMDataManager ()
@property NSDictionary *applicationData;
@end

@implementation AMDataManager
+(AMDataManager *)getInstance{
    static AMDataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(id)init{
    if(self = [super init]){
        _applicationData = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AMScalesData"];
    }
    
    return self;
}

#pragma mark - Mode Settings
-(NSDictionary *)getPropertiesForMode:(NSString *)modeName{
    //Get the mode definitions node
    NSDictionary *modeDefinitions = [self.applicationData objectForKey:@"ModeDefinitions"];
    //return the node for the current mode
    return [modeDefinitions objectForKey:modeName];
}
-(NSArray *)getListOfModes{
    return [[self.applicationData objectForKey:@"ModeDefinitions"] allKeys];
}

#pragma mark - Play Settings
-(NSDictionary *)getPlaySettings {
    //return the play settings node
    return [self.applicationData objectForKey:@"PlayOptions"];
}
-(NSString *) getSampleSetting{
    return [[self getPlaySettings] objectForKey:@"Sample"];
}
-(NSNumber *) getOctavesSetting{
    return [[self getPlaySettings] objectForKey:@"Octaves"];
}
-(NSRange) getSampleRangeSetting{
    return NSMakeRange(33, 96); //A1 and C7
}

@end
