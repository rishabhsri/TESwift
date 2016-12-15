//
//  UserDetails+CoreDataClass.swift
//  
//
//  Created by Apple on 14/12/16.
//
//

import Foundation
import CoreData

@objc(UserDetails)
public class UserDetails: TESwiftModel {

    static func insertUserDetails(info:NSDictionary, context:NSManagedObjectContext) -> UserDetails {
        
        let userDetail:UserDetails
        userDetail = UserDetails.newObject(in: context)
        self.updateUserDetails(userDetail: userDetail, info: info)
        return userDetail
    }
    
    static  func fetchUserDetailsFor(context:NSManagedObjectContext, predicate:NSPredicate) -> UserDetails {
        
        // let fetchRequest2:NSPersistentStoreRequestType = UserDetails.newFetchRequest(in: context)
        
        let fetchRequest:NSFetchRequest = UserDetails.newFetchRequest(in: context)
        //   fetchRequest.predicate = predicate
        
        
        let fetchedObjects:NSArray = NSArray()
        do {
            let results = try context.fetch(fetchRequest)
            for task in results {
                fetchedObjects.adding(task)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return fetchedObjects.object(at: 0) as! UserDetails
        
    }
    
    static func updateUserDetails(userDetail:UserDetails, info:NSDictionary) -> Void {
        
        userDetail.userName = info.value(forKey: "username") as! String?
        userDetail.name = info.value(forKey: "name") as! String?
        userDetail.userID = info.value(forKey: "userID") as! String?
        userDetail.email = info.value(forKey: "email") as! String?
        userDetail.subscriptionType = info.value(forKey: "userSubscription") as! Bool
        
    }

    
}
