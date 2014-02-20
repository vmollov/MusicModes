//
//  AMSettingsManager.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/5/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMDataManager.h"
#import "AMAppDelegate.h"
#import "Statistics.h"

@interface AMDataManager ()
@property NSDictionary *plApplicationData;
@property NSManagedObjectContext *managedObjectContext;

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
        _plApplicationData = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AMScalesData"];
        
        AMAppDelegate *del = [[UIApplication sharedApplication] delegate];
        _managedObjectContext = [del managedObjectContext];
    }//if(self = [super init])
    
    return self;
}

#pragma mark - Core Data Interfaces
-(void)updateStatisticsForMode:(NSString *) modeName addPresented:(int)presented addAnswered:(int)answered timeStamp:(NSDate *) timeStamp{
    //get the current record
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:@"Statistics" inManagedObjectContext:self.managedObjectContext]];
    
    //define the predicate
    NSPredicate *modePredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"mode='%@'", modeName]];
    NSPredicate *timeStampPredicate = [NSPredicate predicateWithFormat:@"testTimeStamp = %@", timeStamp];
    NSArray *arrayOfPredicates = [[NSArray alloc] initWithObjects:modePredicate, timeStampPredicate, nil];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:arrayOfPredicates]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request error:&error];
    Statistics *currendModeStats;
    
    if(fetchedObjects.count == 0){ //insert a new object
        currendModeStats = [NSEntityDescription insertNewObjectForEntityForName:@"Statistics" inManagedObjectContext:self.managedObjectContext];
        currendModeStats.mode = modeName;
        currendModeStats.testTimeStamp = timeStamp;
    }
    else currendModeStats = fetchedObjects[0]; //get the existing object
    
    //update the statistics
    currendModeStats.numPresented = [NSNumber numberWithInt:[currendModeStats.numPresented intValue] + presented];
    currendModeStats.numAnswered = [NSNumber numberWithInt:[currendModeStats.numAnswered intValue] + answered];
    
    //save
    if(![self.managedObjectContext save:&error]) NSLog(@"Error saving statistics: %@", error.localizedDescription);
}


#pragma mark - Plist Interfaces
#pragma mark - Mode Settings
-(NSDictionary *)getPropertiesForMode:(NSString *)modeName{
    //Get the mode definitions node
    NSDictionary *modeDefinitions = [self.plApplicationData objectForKey:@"ModeDefinitions"];
    //return the node for the current mode
    return [modeDefinitions objectForKey:modeName];
}
-(NSArray *)getListOfModes{
    return [[self.plApplicationData objectForKey:@"ModeDefinitions"] allKeys];
}

#pragma mark - Play Settings
-(NSDictionary *)getPlaySettings {
    //return the play settings node
    return [self.plApplicationData objectForKey:@"PlayOptions"];
}
-(NSString *) getSampleSetting{
    return [[self getPlaySettings] objectForKey:@"Sample"];
}
-(NSNumber *) getOctavesSetting{
    return [[self getPlaySettings] objectForKey:@"Octaves"];
}
-(NSRange) getSampleRangeSetting{
    return NSMakeRange(33, 96); //A1 and C
}

@end
