//
//  TEPlayerDetails+CoreDataClass.swift
//  TESwift
//
//  Created by Apple on 22/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import Foundation
import CoreData


public class TEPlayerDetails: TESwiftModel {
    
    static func insertPlayerDetail(info:NSDictionary, context:NSManagedObjectContext, isPlayerApproves:Bool) -> TEPlayerDetails
    {
        let playerDetails:TEPlayerDetails = TEPlayerDetails.newObject(in: context)
        if isPlayerApproves {
            playerDetails.userId = info.stringValueForKey(key: "userID")
            playerDetails.approved = isPlayerApproves
            return playerDetails
        }
        
        let playerDict:NSDictionary = info.object(forKey: "player") as! NSDictionary
        
        playerDetails.name = playerDict.stringValueForKey(key: "name")
        playerDetails.country = playerDict.stringValueForKey(key: "country")
        playerDetails.email = playerDict.stringValueForKey(key: "email")
        playerDetails.imageKey = playerDict.stringValueForKey(key: "imageKey")
        playerDetails.location = playerDict.stringValueForKey(key: "location")
        playerDetails.phoneNumber = playerDict.stringValueForKey(key: "phoneNumber")
        playerDetails.userId = playerDict.stringValueForKey(key: "userID")
        playerDetails.userName = playerDict.stringValueForKey(key: "username")
        playerDetails.city = playerDict.stringValueForKey(key: "city")
        playerDetails.approved = isPlayerApproves
        playerDetails.place = playerDict.stringValueForKey(key: "place")
        playerDetails.seed = playerDict.stringValueForKey(key: "seed")
        playerDetails.lockFlag = playerDict.stringValueForKey(key: "lockFlag")
        playerDetails.win = playerDict.stringValueForKey(key: "win")
        playerDetails.lost = playerDict.stringValueForKey(key: "lost")
        playerDetails.ties = playerDict.stringValueForKey(key: "ties")
        playerDetails.score = playerDict.stringValueForKey(key: "score")
        playerDetails.byes = playerDict.stringValueForKey(key: "byes")
        playerDetails.matchPlayed = playerDict.stringValueForKey(key: "matchPlayed")
        playerDetails.matchRemaining = playerDict.stringValueForKey(key: "matchRemaining")
        playerDetails.matchPoints = playerDict.stringValueForKey(key: "matchPoints")
        playerDetails.setTies = playerDict.stringValueForKey(key: "setTies")
        playerDetails.setWins = playerDict.stringValueForKey(key: "setWins")
        playerDetails.ptsdiff = playerDict.stringValueForKey(key: "ptsDiff")
        playerDetails.teamIcon = playerDict.stringValueForKey(key: "teamIcon")
        playerDetails.isBulkPlayer = playerDict.boolValueForKey(key: "bulk")
        playerDetails.checkedIn = playerDict.boolValueForKey(key: "checkedIn")
        
        if playerDict.stringValueForKey(key: "tb").isEmpty {
            playerDetails.tb = "0"
        }else
        {
            playerDetails.name = playerDict.stringValueForKey(key: "tb")
        }
        
        return playerDetails
    }
    
}
