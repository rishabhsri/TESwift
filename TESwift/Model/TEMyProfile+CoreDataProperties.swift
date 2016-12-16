//
//  TEMyProfile+CoreDataProperties.swift
//  
//
//  Created by Apple on 15/12/16.
//
//

import Foundation
import CoreData


extension TEMyProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TEMyProfile> {
        return NSFetchRequest<TEMyProfile>(entityName: "TEMyProfile");
    }

    @NSManaged public var age: Int16
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var emailid: String?
    @NSManaged public var follow: Bool
    @NSManaged public var username: String?
    @NSManaged public var gender: String?
    @NSManaged public var messageSetting: Bool
    @NSManaged public var mailSetting: Bool
    @NSManaged public var name: String?
    @NSManaged public var notify_approved_player: Bool
    @NSManaged public var notify_followers: Bool
    @NSManaged public var notify_match_admin: Bool
    @NSManaged public var notify_match_palyer: Bool
    @NSManaged public var notify_topurnament_player: Bool
    @NSManaged public var phoneNumber: String?
    @NSManaged public var player_Added_to_tournament: Bool
    @NSManaged public var showTeamIcon: String?
    @NSManaged public var state: String?
    @NSManaged public var subscriptionType: String?
    @NSManaged public var teamIconUrl: String?
    @NSManaged public var tournament_started: Bool
    @NSManaged public var imageKey: String?
    @NSManaged public var location: String?
    @NSManaged public var userid: String?
    @NSManaged public var discordname: String?

}
