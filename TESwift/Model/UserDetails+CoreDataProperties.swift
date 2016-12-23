//
//  UserDetails+CoreDataProperties.swift
//  
//
//  Created by Apple on 20/12/16.
//
//

import Foundation
import CoreData


extension UserDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetails> {
        return NSFetchRequest<UserDetails>(entityName: "UserDetails");
    }

    @NSManaged public var name: String?
    @NSManaged public var userId: String?
    @NSManaged public var userName: String?
    @NSManaged public var userSubscription: Bool
    @NSManaged public var emailId: String?
    @NSManaged public var guestUSer: Bool

}
