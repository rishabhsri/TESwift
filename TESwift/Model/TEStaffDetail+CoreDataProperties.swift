//
//  TEStaffDetail+CoreDataProperties.swift
//  TESwift
//
//  Created by Apple on 22/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import Foundation
import CoreData


extension TEStaffDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TEStaffDetail> {
        return NSFetchRequest<TEStaffDetail>(entityName: "TEStaffDetail");
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var email: String?
    @NSManaged public var imageKey: String?
    @NSManaged public var location: String?
    @NSManaged public var lockFlag: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var place: String?
    @NSManaged public var seed: String?
    @NSManaged public var state: String?
    @NSManaged public var userID: String?
    @NSManaged public var username: String?
    @NSManaged public var tournament: TETournamentList?

}
