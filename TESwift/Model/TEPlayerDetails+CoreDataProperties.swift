//
//  TEPlayerDetails+CoreDataProperties.swift
//  TESwift
//
//  Created by Apple on 22/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import Foundation
import CoreData


extension TEPlayerDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TEPlayerDetails> {
        return NSFetchRequest<TEPlayerDetails>(entityName: "TEPlayerDetails");
    }

    @NSManaged public var approved: Bool
    @NSManaged public var byes: String?
    @NSManaged public var checkedIn: Bool
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var email: String?
    @NSManaged public var imageKey: String?
    @NSManaged public var isBulkPlayer: Bool
    @NSManaged public var location: String?
    @NSManaged public var lockFlag: String?
    @NSManaged public var lost: String?
    @NSManaged public var matchPlayed: String?
    @NSManaged public var matchPoints: String?
    @NSManaged public var matchRemaining: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var place: String?
    @NSManaged public var ptsdiff: String?
    @NSManaged public var score: String?
    @NSManaged public var seed: String?
    @NSManaged public var setTies: String?
    @NSManaged public var setWins: String?
    @NSManaged public var state: String?
    @NSManaged public var tb: String?
    @NSManaged public var teamIcon: String?
    @NSManaged public var ties: String?
    @NSManaged public var userId: String?
    @NSManaged public var userName: String?
    @NSManaged public var win: String?
    @NSManaged public var tournament: TETournamentList?

}
