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
        
        // let fetchRequest2:NSPersistentStoreRequestType = UserDetails.newFetchRequest(in: context)
        
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
    
    //    func makeIterator() -> UserDetails.Iterator {
    //        print(UserDetails.Iterator)
    //    }
    
    static func updateUserDetails(userDetail:UserDetails, info:NSDictionary) -> Void {
        
        userDetail.userName = info.value(forKey: "username") as! String?
        userDetail.name = info.value(forKey: "name") as! String?
        userDetail.userId = info.value(forKey : "userID") as! String?
        userDetail.emailId = info.value(forKey: "email") as! String?
        userDetail.userSubscription = info.value(forKey: "userSubscription") as! Bool
        
    }
    
    
}
