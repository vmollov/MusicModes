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
    }
    
    return self;
}

#pragma mark - Core Data Interfaces
-(void)updateStatisticsForMode:(NSString *) modeName neededHint:(BOOL) withHint testTimeStamp:(NSDate *) timeStamp{
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
    int pPossible = 3;
    int pEarned = withHint?1:3;
    currendModeStats.numPresented = [NSNumber numberWithInt:[currendModeStats.numPresented intValue] + pPossible];
    currendModeStats.numAnswered = [NSNumber numberWithInt:[currendModeStats.numAnswered intValue] + pEarned];
    
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
-(NSArray *)getListOfAllModes{
    return [[self.plApplicationData objectForKey:@"ModeDefinitions"] allKeys];
}
-(NSArray *)getListOfEnabledModes{
    NSMutableArray *enabledModes = [[NSMutableArray alloc] initWithCapacity:1];
    for(NSString *mode in self.getListOfAllModes){
        if([[NSUserDefaults standardUserDefaults] boolForKey:mode]) [enabledModes addObject:mode];
    }
    return enabledModes;
}

#pragma mark - Sample Settings
-(NSRange) getCurrentSampleRange{
    NSString *currentSample = [[NSUserDefaults standardUserDefaults] objectForKey:@"playSample"];
    return [self getRangeForSample:currentSample];
}
-(NSRange) getRangeForSample:(NSString *) sample{
    NSDictionary *sampleRangeBounds = [[self.plApplicationData objectForKey:@"Samples"] objectForKey:sample];
    NSUInteger lowBound = [[sampleRangeBounds objectForKey:@"rangeLow"] intValue];
    NSUInteger highBound = [[sampleRangeBounds objectForKey:@"rangeHigh"] intValue];
    
    return NSMakeRange(lowBound, highBound);
}
-(NSArray *)getListOfSamples{
    return [[self.plApplicationData objectForKey:@"Samples"] allKeys];
}

#pragma mark - User Defaults Interfaces
-(BOOL) mode:(NSString *) mode setEnabled:(BOOL) enabled{
    long enabledModes = [[NSUserDefaults standardUserDefaults] integerForKey:@"NumberOfEnabledModes"];
    //if the number of enabled modes will be 4 or less after this method completes then return false
    if(!enabled && enabledModes < 4) return false;
    
    enabled?enabledModes++:enabledModes--;
    
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:mode];
    [[NSUserDefaults standardUserDefaults] setInteger:enabledModes forKey:@"NumberOfEnabledModes"];
    
    return true;
}

@end
