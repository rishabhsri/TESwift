//
//  UserSocialDetail+CoreDataProperties.swift
//  
//
//  Created by Apple on 16/12/16.
//
//

import Foundation
import CoreData 

extension UserSocialDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserSocialDetail> {
        return NSFetchRequest<UserSocialDetail>(entityName: "UserSocialDetail");
    }

    @NSManaged public var userName: String?
    @NSManaged public var userId: String?
    @NSManaged public var name: String?
    @NSManaged public var link: String?
    @NSManaged public var imageKey: String?
    @NSManaged public var emailId: String?
    @NSManaged public var connectType: String?
    @NSManaged public var myprofile: TEMyProfile?

}
