//
//  TETournamentBracketSpots+CoreDataClass.swift
//  TESwift
//
//  Created by Apple on 22/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import Foundation
import CoreData


public class TETournamentBracketSpots: TESwiftModel {
    
    static func insertBracketSpotInfo(info:NSDictionary, context:NSManagedObjectContext, poolName:String) -> TETournamentBracketSpots
    {
        let bracketSpotDetail:TETournamentBracketSpots = TETournamentBracketSpots.newObject(in: context)
        bracketSpotDetail.bracketSpotID = info.stringValueForKey(key: "bracketSpotID")
        bracketSpotDetail.userID = info.stringValueForKey(key: "userID")
        bracketSpotDetail.userName = info.stringValueForKey(key: "username")
        bracketSpotDetail.matchNumber = info.stringValueForKey(key: "matchNumber")
        bracketSpotDetail.round = info.stringValueForKey(key: "round")
        bracketSpotDetail.spotText = info.stringValueForKey(key: "spotText")
        bracketSpotDetail.score = info.stringValueForKey(key: "score")
        bracketSpotDetail.bye = info.boolValueForKey(key: "bye")
        bracketSpotDetail.seed = info.stringValueForKey(key: "seed")
        bracketSpotDetail.poolname = poolName
        bracketSpotDetail.name = info.stringValueForKey(key: "name")
        bracketSpotDetail.submitted = info.boolValueForKey(key: "submitted")
        bracketSpotDetail.totalWins = info.stringValueForKey(key: "totalWins")
        
        return bracketSpotDetail
        
    }
}
