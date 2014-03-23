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
-(float)getStatisticsAverageForMode:(NSString *)modeName{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Statistics" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    if(modeName != nil){
        //return statistics for specific mode
        NSPredicate *modePredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"mode='%@'", modeName]];
        [request setPredicate:modePredicate];
    }
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(error != nil)NSLog(@"Error getting statistics. %@", error.localizedDescription);
    
    float totalPresented = [[fetchedObjects valueForKeyPath:@"@sum.numPresented"] floatValue];
    float totalAnswered = [[fetchedObjects valueForKeyPath:@"@sum.numAnswered"] floatValue];
    
    return (totalAnswered/totalPresented)*100;
}
-(NSDictionary*)getStatisticsProgressForMode:(NSString *)modeName{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Statistics" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    if(modeName != nil){
        //return statistics for specific mode
        NSPredicate *modePredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"mode='%@'", modeName]];
        [request setPredicate:modePredicate];
    }
    
    //compose the aggregate sum expressions
    NSExpression *kpPresented = [NSExpression expressionForKeyPath:@"numPresented"];
    NSExpression *sumFPresented = [NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:kpPresented]];
    NSExpressionDescription *sumPresentedExpr = [[NSExpressionDescription alloc]init];
    sumPresentedExpr.name = @"sumNumPresented";
    sumPresentedExpr.expression = sumFPresented;
    sumPresentedExpr.expressionResultType = NSInteger32AttributeType;
    
    NSExpression *kpAnswered = [NSExpression expressionForKeyPath:@"numAnswered"];
    NSExpression *sumFAnswered = [NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:kpAnswered]];
    NSExpressionDescription *sumAnsweredExpr = [[NSExpressionDescription alloc] init];
    sumAnsweredExpr.name = @"sumNumAnswered";
    sumAnsweredExpr.expression = sumFAnswered;
    sumAnsweredExpr.expressionResultType = NSInteger32AttributeType;
    
    [request setPropertiesToFetch:[NSArray arrayWithObjects:@"testTimeStamp", sumPresentedExpr, sumAnsweredExpr, nil]];
    
    [request setResultType:NSDictionaryResultType];
    [request setPropertiesToGroupBy:[NSArray arrayWithObject:[entity.attributesByName objectForKey:@"testTimeStamp"]]];
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"testTimeStamp" ascending:YES]]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(error != nil)NSLog(@"Error getting statistics. %@", error.localizedDescription);
    float runningTotalAnswered = 0;
    float runningTotalPresented = 0;
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    int firstRecordsCounter = 0;
    for(NSDictionary *record in fetchedObjects){
        //NSDictionary *record = [fetchedObjects objectAtIndex:counter];
        runningTotalAnswered += [[record valueForKey:@"sumNumAnswered"] intValue];
        runningTotalPresented += [[record valueForKey:@"sumNumPresented"] intValue];
        
        if(firstRecordsCounter<3 && fetchedObjects.count>=3) firstRecordsCounter++;
        else{
            int percentage = (runningTotalAnswered/runningTotalPresented) *100;
            [result setValue:[NSNumber numberWithInt:percentage] forKey:[record valueForKey:@"testTimeStamp"]];
        }
    }
    
    return result;
}

-(void)updateStatisticsForMode:(NSString *)modeName correct:(BOOL)correct neededHint:(BOOL)withHint testTimeStamp:(NSDate *) timeStamp{
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
    int pEarned = correct?(withHint?1:3):0;
    currendModeStats.numPresented = [NSNumber numberWithInt:[currendModeStats.numPresented intValue] + pPossible];
    currendModeStats.numAnswered = [NSNumber numberWithInt:[currendModeStats.numAnswered intValue] + pEarned];
    
    //save
    if(![self.managedObjectContext save:&error]) NSLog(@"Error saving statistics: %@", error.localizedDescription);
}
-(void)eraseAllStatistics{
    NSFetchRequest * allStatistics = [[NSFetchRequest alloc] init];
    [allStatistics setEntity:[NSEntityDescription entityForName:@"Statistics" inManagedObjectContext:self.managedObjectContext]];
    [allStatistics setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * records = [self.managedObjectContext executeFetchRequest:allStatistics error:&error];
    if(error != nil) NSLog(@"Error getting all statistics for deletion. %@", error.localizedDescription);
    
    for (Statistics * record in records) {
        [self.managedObjectContext deleteObject:record];
    }
    [self.managedObjectContext save:&error];
    if(error != nil) NSLog(@"Error deleting statistics. %@", error.localizedDescription);
}


#pragma mark - Plist Interfaces
#pragma mark - Tier 1 inApp Purchase
-(NSString *) getTier1ProductID{
    return [self.plApplicationData objectForKey:@"Tier1ProductID"];
}
#pragma mark - Mode Data
-(NSDictionary *)getPropertiesForMode:(NSString *)modeName{
    //Get the mode definitions node
    NSDictionary *modeDefinitions = [self.plApplicationData objectForKey:@"ModeDefinitions"];
    //return the node for the current mode
    return [modeDefinitions objectForKey:modeName];
}
-(NSDictionary *) getListOfAllGroups{
    return [self.plApplicationData objectForKey:@"ModeGroups"];
}
-(NSString *) getNameForGroupId:(int) groupId{
    return [self.getListOfAllGroups objectForKey:[NSString stringWithFormat:@"%i",groupId]];
}
-(NSArray *)getListOfAllModesUseDisplayName:(BOOL) displayName grouped:(BOOL) grouped{
    NSDictionary *allModes = [self.plApplicationData objectForKey:@"ModeDefinitions"];
    NSMutableArray *rawList = [NSMutableArray arrayWithArray:[allModes allKeys]];
    for(int i=0; i<rawList.count; i++){
        NSString *key = [rawList objectAtIndex:i];
        NSString *patternOf = [[allModes objectForKey:key] objectForKey:@"PatternOf"];
        
        if(patternOf != nil){
            if(displayName) {
                [rawList removeObjectIdenticalTo:patternOf];
            }else{
                [rawList removeObjectAtIndex:i];
            }//if(byDisplayName)
        }//if patternof != nil
    }
    
    if(grouped){
        NSArray *groupList = [[self.getListOfAllGroups allKeys] sortedArrayUsingSelector:@selector(compare:)];
        NSMutableArray *categorizedList = [NSMutableArray arrayWithCapacity:groupList.count];
        for(int i=0; i<groupList.count; i++){
            int key = [[groupList objectAtIndex:i] intValue];
            [categorizedList insertObject:[self getListOfModesInGroup:key useDisplayName:displayName] atIndex:i];
        }
        return categorizedList;
    }else{
        return [self orderListOfModes:rawList];

    }
}
-(NSArray *) getListOfModesInGroup:(int) group useDisplayName:(BOOL) displayName{
    NSDictionary *allModes = [self.plApplicationData objectForKey:@"ModeDefinitions"];
    NSMutableArray *orderedList = [NSMutableArray arrayWithArray:[self getListOfAllModesUseDisplayName:displayName grouped:NO]];
    for(int i=0; i<orderedList.count; i++){
        //get the mode's groupid
        NSString *key = [orderedList objectAtIndex:i];
        int groupId = [[[allModes objectForKey:key] objectForKey:@"groupId"] intValue];
        if(groupId != group){
            [orderedList removeObjectAtIndex:i];
            i--;
        }
    }

    return orderedList;
}

-(NSArray *) orderListOfModes:(NSArray *)listOfModes{
    //assume each groups contains the size of modes - will create an array with a lot of empty slots which will be cleared
    int groupsNum = (int)self.getListOfAllGroups.count;
    int groupSize = (int)listOfModes.count;
    NSMutableArray *sortedList = [NSMutableArray arrayWithCapacity:groupsNum*groupSize];
    //initialize all the slots in the array with empty string
    for(int i=0; i<groupsNum*groupSize; i++) [sortedList addObject:@""];
    //go through the list of modes and check if they have order value assigned
    for(NSString *mode in listOfModes){
        //insert the mode at the specified index or if the index is not given put it at the end
        NSString *orderVal = [[self getPropertiesForMode:mode] objectForKey:@"order"];
        NSString *groupVal = [[self getPropertiesForMode:mode] objectForKey:@"groupId"];
        int index;
        if(orderVal == nil || groupVal == nil) index = (int)sortedList.count - 1;
        else index = (([groupVal intValue]-1)*groupSize) + ([orderVal intValue] - 1);
        
        [sortedList setObject:mode atIndexedSubscript:index];
    }
    //remove all empty objects from the array
    for(int i=0; i<sortedList.count; i++){
        if([[sortedList objectAtIndex:i] isEqualToString:@""]){
            [sortedList removeObjectAtIndex:i];
            i--;
        }
    }
    
    return sortedList;
}
-(NSArray *)getListOfEnabledModes{
    NSMutableArray *enabledModes = [[NSMutableArray alloc] initWithCapacity:1];
    for(NSString *mode in [self getListOfAllModesUseDisplayName:NO grouped:NO]){
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
    return [[[self.plApplicationData objectForKey:@"Samples"] allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark - User Defaults Interfaces
-(BOOL) mode:(NSString *) mode setEnabled:(BOOL) enabled{
    long enabledModes = [[NSUserDefaults standardUserDefaults] integerForKey:@"NumberOfEnabledModes"];
    enabled?enabledModes++:enabledModes--;

    //if the number of enabled modes will be 4 or less after this method completes then return false
    if(!enabled && enabledModes < 4) return false;
    
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:mode];
    [[NSUserDefaults standardUserDefaults] setInteger:enabledModes forKey:@"NumberOfEnabledModes"];
    
    return true;
}
-(BOOL) isModeAvailable:(NSString *) mode{
    //check if purchase is required for the mode
    if([[[self getPropertiesForMode:mode] objectForKey:@"startEnabled"] boolValue]) return YES;
    
    //check if purchase has been made
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enableAdvancedModes"]) return YES;
    
    //purchase is required and has not been made
    return NO;
}

@end
