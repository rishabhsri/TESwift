//
//  TESwiftModel.m
//  TESwift
//
//  Created by Apple on 14/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

#import "TESwiftModel.h"

@implementation TESwiftModel

+ (NSFetchRequest *)newFetchRequestInManagedObjectContext:(NSManagedObjectContext *)context
{
    // Context cannot be nil. If it is it will lead to crash.
    if (context == nil) {
        return nil;
    }
    NSArray *arr = [NSStringFromClass([self class]) componentsSeparatedByString:@"."];
    NSString *str =  arr[1];
    NSParameterAssert(context);
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:str inManagedObjectContext:context];
    return request;
}

+ (NSFetchRequest *)fetchDistinctObject:(NSManagedObjectContext*)context propertyToFetch:(NSString*)propertyName{
    // Context cannot be nil. If it is it will lead to crash.
    if (context == nil) {
        return nil;
    }
    
    NSParameterAssert(context);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setResultType:NSDictionaryResultType];
    fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSDictionary *entityProperties = [fetchRequest.entity propertiesByName];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:[entityProperties objectForKey:propertyName]]];
    [fetchRequest setReturnsDistinctResults:YES];
    
    return fetchRequest;
    
}

+ (instancetype)newObjectInManagedObjectContext:(NSManagedObjectContext *)context
{
    // Context cannot be nil. If it is it will lead to crash.
    if (context == nil) {
        return nil;
    }
    NSArray *arr = [NSStringFromClass([self class]) componentsSeparatedByString:@"."];
    NSString *str =  arr[1];
    NSParameterAssert(context);
    return [NSEntityDescription insertNewObjectForEntityForName:str inManagedObjectContext:context];
}

+ (void)saveContext:(NSManagedObjectContext*)managedObjectContext {
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
    
    if(saveError)
        NSLog(@"saveError %@",[saveError localizedDescription]);
    
    
}

+ (void) deleteAllFromEntityInManageObjectContext:(NSManagedObjectContext*)managedObjectContext {
    
    NSFetchRequest * allRecords = [[NSFetchRequest alloc] init];
    NSArray *arr = [NSStringFromClass([self class]) componentsSeparatedByString:@"."];
    NSString *str =  arr[1];
    [allRecords setEntity:[NSEntityDescription entityForName:str inManagedObjectContext:managedObjectContext]];
    [allRecords setIncludesPropertyValues:NO];
    NSError * error = nil;
    NSArray * result = [managedObjectContext executeFetchRequest:allRecords error:&error];
    for (NSManagedObject * profile in result) {
        [managedObjectContext deleteObject:profile];
    }
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
}

+ (void)deleteObjectFromEntity:(NSManagedObject*)object InManagedObjectContext:(NSManagedObjectContext*)context{
    
    if(context == nil){
        NSLog(@"Context Nil");
        return;
    }
    [context deleteObject:object];
    NSError *saveError = nil;
    [context save:&saveError];
    
    if(saveError)
        NSLog(@"saveError %@",[saveError localizedDescription]);
}




@end
