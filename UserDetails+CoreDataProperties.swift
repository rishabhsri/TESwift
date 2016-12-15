//
//  UserDetails+CoreDataProperties.swift
//  
//
//  Created by Apple on 14/12/16.
//
//

import Foundation
import CoreData


extension UserDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetails> {
        return NSFetchRequest<UserDetails>(entityName: "UserDetails");
    }

    @NSManaged public var emailD: String?
    @NSManaged public var guestUser: Bool
    @NSManaged public var name: String?
    @NSManaged public var userID: String?
    @NSManaged public var userName: String?
    @NSManaged public var userSubscription: Bool

}
