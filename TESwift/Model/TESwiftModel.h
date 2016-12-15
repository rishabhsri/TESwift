//
//  TESwiftModel.h
//  TESwift
//
//  Created by Apple on 14/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TESwiftModel : NSManagedObject

+ (NSFetchRequest *)newFetchRequestInManagedObjectContext:(NSManagedObjectContext *)context;

+ (instancetype)newObjectInManagedObjectContext:(NSManagedObjectContext *)context;

+ (void) deleteAllFromEntityInManageObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (void)deleteObjectFromEntity:(NSManagedObject*)object InManagedObjectContext:(NSManagedObjectContext*)context;

+ (void)saveContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSFetchRequest *)fetchDistinctObject:(NSManagedObjectContext*)context propertyToFetch:(NSString*)propertyName;



@end
