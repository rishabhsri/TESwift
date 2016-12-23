//
//  TETournamentBracket+CoreDataProperties.swift
//  TESwift
//
//  Created by Apple on 22/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import Foundation
import CoreData


extension TETournamentBracket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TETournamentBracket> {
        return NSFetchRequest<TETournamentBracket>(entityName: "TETournamentBracket");
    }

    @NSManaged public var bracketID: String?
    @NSManaged public var bracketSize: String?
    @NSManaged public var parentBracketID: String?
    @NSManaged public var poolName: String?
    @NSManaged public var poolNameWithRound: String?
    @NSManaged public var poolRoundEnum: String?
    @NSManaged public var winnerBracket: Bool
    @NSManaged public var bracketSpot: NSSet?
    @NSManaged public var list: TETournamentList?

}

// MARK: Generated accessors for bracketSpot
extension TETournamentBracket {

    @objc(addBracketSpotObject:)
    @NSManaged public func addToBracketSpot(_ value: TETournamentBracketSpots)

    @objc(removeBracketSpotObject:)
    @NSManaged public func removeFromBracketSpot(_ value: TETournamentBracketSpots)

    @objc(addBracketSpot:)
    @NSManaged public func addToBracketSpot(_ values: NSSet)

    @objc(removeBracketSpot:)
    @NSManaged public func removeFromBracketSpot(_ values: NSSet)

}
