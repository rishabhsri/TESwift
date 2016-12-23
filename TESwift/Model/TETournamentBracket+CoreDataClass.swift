//
//  TETournamentBracket+CoreDataClass.swift
//  TESwift
//
//  Created by Apple on 22/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import Foundation
import CoreData


public class TETournamentBracket: TESwiftModel {
    
    static func insertBracket(info:NSDictionary, conetxt:NSManagedObjectContext) -> TETournamentBracket
        
    {
        
        let bracketDetail:TETournamentBracket = TETournamentBracket.newObject(in: conetxt)
        bracketDetail.bracketID = info.stringValueForKey(key: "bracketID")
        
        bracketDetail.bracketSize = info.stringValueForKey(key: "bracketSize")
        
        bracketDetail.poolName = info.stringValueForKey(key: "poolname")
        
        bracketDetail.poolRoundEnum = info.stringValueForKey(key: "poolRoundEnum")
        
        bracketDetail.parentBracketID = info.stringValueForKey(key: "parentBracketID")
        
        bracketDetail.winnerBracket = info.boolValueForKey(key: "winnersBracket")
        bracketDetail.poolNameWithRound = info.stringValueForKey(key: "poolNameWithRound")
        
        let bracketSpotArr:NSArray = info.object(forKey: "bracketSpots") as! NSArray
        
        for bracketInfo in bracketSpotArr {
            let brcketSpotInfo:TETournamentBracketSpots = TETournamentBracketSpots.insertBracketSpotInfo(info: bracketInfo as! NSDictionary, context: conetxt, poolName: info.stringValueForKey(key: "poolName"))
            bracketDetail.addToBracketSpot(brcketSpotInfo)
        }
        return bracketDetail
    }
    
}
