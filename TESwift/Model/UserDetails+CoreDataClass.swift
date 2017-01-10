//
//  UserDetails+CoreDataClass.swift
//
//
//  Created by Apple on 20/12/16.
//
//

import Foundation
import CoreData


public class UserDetails: TESwiftModel {
    
    static func insertUserDetails(info:NSDictionary, context:NSManagedObjectContext) -> UserDetails {
        
        let userDetail:UserDetails
        userDetail = UserDetails.newObject(in: context)
        self.updateUserDetails(userDetail: userDetail, info: info)
        return userDetail
    }
    
    static  func fetchUserDetailsFor(context:NSManagedObjectContext, predicate:NSPredicate) -> UserDetails {
        
        let fetchRequest:NSFetchRequest = UserDetails.newFetchRequest(in: context)
        fetchRequest.predicate = predicate
        
        var fetchedObjects:NSArray = NSArray()
        do {
            fetchedObjects = try context.fetch(fetchRequest) as NSArray
        } catch let error {
            print(error.localizedDescription)
        }
        return fetchedObjects.firstObject as! UserDetails
        
    }
    
    static func updateUserDetails(userDetail:UserDetails, info:NSDictionary) -> Void {
        
        userDetail.userName = info.stringValueForKey(key: "username")
        userDetail.name = info.stringValueForKey(key: "name")
        userDetail.userId = info.stringValueForKey(key: "userID")
        userDetail.emailId = info.stringValueForKey(key: "email")
        userDetail.userSubscription = info.boolValueForKey(key: "userSubscription")
        
    }
}
