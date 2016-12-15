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

    @NSManaged public var name: String?
    @NSManaged public var subscriptionType: Bool
    @NSManaged public var email: String?
    @NSManaged public var userID: String?
    @NSManaged public var userName: String?

}
