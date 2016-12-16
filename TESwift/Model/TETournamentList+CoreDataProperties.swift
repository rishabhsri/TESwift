//
//  TETournamentList+CoreDataProperties.swift
//  
//
//  Created by Apple on 16/12/16.
//
//

import Foundation
import CoreData


extension TETournamentList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TETournamentList> {
        return NSFetchRequest<TETournamentList>(entityName: "TETournamentList");
    }

    @NSManaged public var webURL: String?
    @NSManaged public var acceptAttachments: String?
    @NSManaged public var autoApprovalTime: String?
    @NSManaged public var allowUserScoreSubmission: Bool
    @NSManaged public var checkInTime: String?
    @NSManaged public var completed: Bool
    @NSManaged public var considerLocation: String?
    @NSManaged public var considerTeam: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var creatorDisplayName: String?
    @NSManaged public var cretorImageKey: String?
    @NSManaged public var creatorImageKey: String?
    @NSManaged public var creatorUserId: String?
    @NSManaged public var creatorUserName: String?
    @NSManaged public var discordChannel: Bool
    @NSManaged public var endDateTime: String?
    @NSManaged public var eventId: String?
    @NSManaged public var eventImageKey: String?
    @NSManaged public var eventName: String?
    @NSManaged public var gameDiscription: String?
    @NSManaged public var gameId: String?
    @NSManaged public var gameName: String?
    @NSManaged public var hype: Bool
    @NSManaged public var imageKay: String?
    @NSManaged public var isCompleteData: Bool
    @NSManaged public var isDummyTE: Bool
    @NSManaged public var lastUpdatedAt: String?
    @NSManaged public var latLong: String?
    @NSManaged public var maxPlayersInEachBracket: String?
    @NSManaged public var notificationMessage: String?
    @NSManaged public var openSignup: String?
    @NSManaged public var paidTournament: Bool
    @NSManaged public var poolCount: String?
    @NSManaged public var poolName: String?
    @NSManaged public var preRegister: Bool
    @NSManaged public var preRegistrationEndDate: String?
    @NSManaged public var preRegistrationCharge: String?
    @NSManaged public var privateTournament: String?
    @NSManaged public var rankedBy: String?
    @NSManaged public var remarks: String?
    @NSManaged public var rrPtsForGameTie: String?
    @NSManaged public var rrPtsForGamebye: String?
    @NSManaged public var rrPtsForGameWin: String?
    @NSManaged public var rrPtsForMatchTie: String?
    @NSManaged public var rrPtsForMatchWin: String?
    @NSManaged public var seasonId: String?
    @NSManaged public var seasonImageKay: String?
    @NSManaged public var seasonName: String?
    @NSManaged public var sequentialpairings: String?
    @NSManaged public var shareURL: String?
    @NSManaged public var showRounds: String?
    @NSManaged public var shareDateTime: String?
    @NSManaged public var started: Bool
    @NSManaged public var teamBasedTE: Bool
    @NSManaged public var tournamentDesciption: String?
    @NSManaged public var tournamentID: String?
    @NSManaged public var tournamentName: String?
    @NSManaged public var tournamenTypeDescription: String?
    @NSManaged public var tournamentTypeID: String?
    @NSManaged public var tournamentTypeName: String?
    @NSManaged public var twitterHandle: String?
    @NSManaged public var twitterLink: String?
    @NSManaged public var twitterMessage: String?
    @NSManaged public var userHype: Bool
    @NSManaged public var venue: String?
    @NSManaged public var myProfile: TEMyProfile?

}
