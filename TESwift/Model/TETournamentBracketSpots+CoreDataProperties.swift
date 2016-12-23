//
//  TETournamentBracketSpots+CoreDataProperties.swift
//  TESwift
//
//  Created by Apple on 22/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import Foundation
import CoreData


extension TETournamentBracketSpots {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TETournamentBracketSpots> {
        return NSFetchRequest<TETournamentBracketSpots>(entityName: "TETournamentBracketSpots");
    }

    @NSManaged public var bracketSpotID: String?
    @NSManaged public var bye: Bool
    @NSManaged public var matchNumber: String?
    @NSManaged public var name: String?
    @NSManaged public var poolname: String?
    @NSManaged public var round: String?
    @NSManaged public var score: String?
    @NSManaged public var seed: String?
    @NSManaged public var sortOrder: String?
    @NSManaged public var spotText: String?
    @NSManaged public var submitted: Bool
    @NSManaged public var totalWins: String?
    @NSManaged public var userID: String?
    @NSManaged public var userName: String?
    @NSManaged public var winner: Bool
    @NSManaged public var bracket: TETournamentBracket?

}
