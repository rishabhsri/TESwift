//
//  TEMyProfile+CoreDataProperties.swift
//  
//
//  Created by Apple on 16/12/16.
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
    @NSManaged public var discordname: String?
    @NSManaged public var emailid: String?
    @NSManaged public var follow: Bool
    @NSManaged public var gender: String?
    @NSManaged public var imageKey: String?
    @NSManaged public var location: String?
    @NSManaged public var mailSetting: Bool
    @NSManaged public var messageSetting: Bool
    @NSManaged public var name: String?
    @NSManaged public var notify_approved_player: Bool
    @NSManaged public var notify_followers: Bool
    @NSManaged public var notify_match_admin: Bool
    @NSManaged public var notify_match_palyer: Bool
    @NSManaged public var notify_topurnament_player: Bool
    @NSManaged public var phoneNumber: String?
    @NSManaged public var player_Added_to_tournament: Bool
    @NSManaged public var showTeamIcon: Bool
    @NSManaged public var state: String?
    @NSManaged public var subscriptionType: String?
    @NSManaged public var teamIconUrl: String?
    @NSManaged public var tournament_started: Bool
    @NSManaged public var userid: String?
    @NSManaged public var username: String?
    @NSManaged public var socialdetails: NSSet?
    @NSManaged public var tournament: TETournamentList?

}

// MARK: Generated accessors for socialdetails
extension TEMyProfile {

    @objc(addSocialdetailsObject:)
    @NSManaged public func addToSocialdetails(_ value: UserSocialDetail)

    @objc(removeSocialdetailsObject:)
    @NSManaged public func removeFromSocialdetails(_ value: UserSocialDetail)

    @objc(addSocialdetails:)
    @NSManaged public func addToSocialdetails(_ values: NSSet)

    @objc(removeSocialdetails:)
    @NSManaged public func removeFromSocialdetails(_ values: NSSet)

}

// MARK: Generated accessors for tournament
extension TEMyProfile {
    
    @objc(addTournamentObject:)
    @NSManaged public func addToSocialdetails(_ value: TETournamentList)
    
    @objc(removeTournamentObject:)
    @NSManaged public func removeFromSocialdetails(_ value: TETournamentList)
    
    @objc(addTournament:)
    @NSManaged public func addToTournament(_ values: NSSet)
    
    @objc(removeTournament:)
    @NSManaged public func removeFromTournament(_ values: NSSet)
    
}
