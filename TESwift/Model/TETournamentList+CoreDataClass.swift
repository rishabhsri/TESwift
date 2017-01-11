//
//  TETournamentList+CoreDataClass.swift
//  TESwift
//
//  Created by Apple on 22/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import Foundation
import CoreData


public class TETournamentList: TESwiftModel {
   
    static func insertTournamentDetails(info:NSDictionary, context:NSManagedObjectContext, isDummy:Bool, isUserHype:Bool) -> TETournamentList
    {
        let tournamentList:TETournamentList = TETournamentList.newObject(in: context)
        tournamentList.tournamentID = info.stringValueForKey(key: "tournamentID")
        tournamentList.started = info.boolValueForKey(key: "started")
        tournamentList.privateTournament = info.stringValueForKey(key: "privateTournament")
        tournamentList.isCompleteData = true
        
        if let tournamentType:NSDictionary = info.object(forKey: "tournamentType") as! NSDictionary? {
            if tournamentType.allKeys.count>0  {
                
                tournamentList.tournamentTypeName = tournamentType.stringValueForKey(key: "tournamentTypeName")
                tournamentList.tournamentDesciption = tournamentType.stringValueForKey(key: "tournamentTypeDescription")
                tournamentList.tournamentTypeID = tournamentType.stringValueForKey(key: "tournamentTypeID")
                
                tournamentList.rrPtsForGameWin = tournamentType.stringValueForKey(key: "rrPtsForMatchWin")
                tournamentList.rrPtsForMatchTie = tournamentType.stringValueForKey(key: "rrPtsForMatchTie")
                tournamentList.rrPtsForGameWin = tournamentType.stringValueForKey(key: "rrPtsForMatchWin")
                tournamentList.rrPtsForGameTie = tournamentType.stringValueForKey(key: "rrPtsForGameTie")
                tournamentList.rrPtsForGamebye = tournamentType.stringValueForKey(key: "rrPtsForGameBye")
                
                var string = tournamentType.stringValueForKey(key: "rankedBy").uppercased()
                string = string.replacingOccurrences(of: "_", with: " ")
                tournamentList.rankedBy = string
                
                tournamentList.showRounds = tournamentType.stringValueForKey(key: "showRounds")
            }
        }
        
        if let game:NSDictionary = info.object(forKey: "game") as! NSDictionary? {
            if game.allKeys.count>0 {
                tournamentList.gameId = game.stringValueForKey(key: "gameID")
                tournamentList.gameDiscription = game.stringValueForKey(key: "description")
                tournamentList.gameName = game.stringValueForKey(key: "name")
                
            }
        }
        
        tournamentList.maxPlayersInEachBracket = info.stringValueForKey(key: "maxPlayersInEachBracket")
        tournamentList.imageKay = info.stringValueForKey(key: "imageKey")
        tournamentList.completed = info.boolValueForKey(key: "completed")
        tournamentList.webURL = info.stringValueForKey(key: "webURL")
        tournamentList.venue = info.stringValueForKey(key: "venue")
        tournamentList.openSignup = info.stringValueForKey(key: "openSignup")
        
        tournamentList.tournamentDesciption = info.stringValueForKey(key: "description")
        tournamentList.creatorUserId = info.stringValueForKey(key: "creatorUserId")
        tournamentList.poolCount = info.stringValueForKey(key: "poolCount")
        
        var startKeyName:String = "startDateTime"
        var endKeyName:String = "endDateTime"
        
        if COMMON_SETTING.isEmptyStingOrWithBlankSpace(info.stringValueForKey(key: startKeyName)) {
            startKeyName = "startDate"
        }
        if COMMON_SETTING.isEmptyStingOrWithBlankSpace(info.stringValueForKey(key: endKeyName)) {
            endKeyName = "endDate"
        }
        
        tournamentList.startDateTime = info.stringValueForKey(key: startKeyName)
        tournamentList.endDateTime = info.stringValueForKey(key: endKeyName)
        tournamentList.tournamentName = info.stringValueForKey(key: "name")
        tournamentList.notificationMessage = info.stringValueForKey(key: "notificationMessage")
        tournamentList.twitterMessage = info.stringValueForKey(key: "twitterMessage")
        
        tournamentList.createdAt = info.stringValueForKey(key: "createdAt")
        tournamentList.lastUpdatedAt = info.stringValueForKey(key: "lastUpdatedAt")
        tournamentList.preRegister = info.boolValueForKey(key: "preRegister")
        tournamentList.considerLocation = info.stringValueForKey(key: "considerLocation")
        tournamentList.considerTeam = info.stringValueForKey(key: "considerTeam")
        tournamentList.hype = info.boolValueForKey(key: "hype")
        
        tournamentList.latLong = info.stringValueForKey(key: "latLong")
        tournamentList.teamBasedTE = info.boolValueForKey(key: "teamBased")
        tournamentList.allowUserScoreSubmission = info.boolValueForKey(key: "allowUserScoreSubmission")
        
        tournamentList.checkInTime = info.stringValueForKey(key: "checkinTime")
        tournamentList.autoApprovalTime = info.stringValueForKey(key: "autoApprovalTime")
        tournamentList.discordChannel = info.boolValueForKey(key: "createDiscordChannel")
        
        tournamentList.isDummyTE = isDummy
        
        tournamentList.userHype = isUserHype
        
        tournamentList.shareURL = info.stringValueForKey(key: "shareUrl")
        tournamentList.paidTournament = info.boolValueForKey(key: "paid")
        tournamentList.preRegistrationCharge = info.stringValueForKey(key: "price")
        
        
        if let adminDetail:NSDictionary = info.object(forKey: "adminDetails") as? NSDictionary {
            if adminDetail.allKeys.count>0 {
                tournamentList.creatorUserName = adminDetail.stringValueForKey(key: "username")
                tournamentList.creatorImageKey = adminDetail.stringValueForKey(key: "imageKey")
                tournamentList.creatorDisplayName = adminDetail.stringValueForKey(key: "name")
                
            }
        }
        
        if let seasonDetail:NSDictionary = info.object(forKey: "season") as? NSDictionary {
            if seasonDetail.allKeys.count>0 {
                tournamentList.seasonId = seasonDetail.stringValueForKey(key: "seasonID")
                tournamentList.seasonName = seasonDetail.stringValueForKey(key: "name")
                tournamentList.seasonImageKay = seasonDetail.stringValueForKey(key: "imageKey")
                
            }
        }
        
        if let eventDetail:NSDictionary = info.object(forKey: "event") as? NSDictionary {
            if eventDetail.allKeys.count>0 {
                tournamentList.eventName = eventDetail.stringValueForKey(key: "name")
                tournamentList.eventId = eventDetail.stringValueForKey(key: "eventID")
                tournamentList.eventImageKey = eventDetail.stringValueForKey(key: "imageKey")
                
            }
        }
        
        if let twitterDetail:NSDictionary = info.object(forKey: "twitter") as? NSDictionary {
            if twitterDetail.allKeys.count>0 {
                tournamentList.twitterHandle = twitterDetail.stringValueForKey(key: "handle")
                tournamentList.twitterLink = twitterDetail.stringValueForKey(key: "link")
            }
        }else{
            tournamentList.twitterHandle = "";
            tournamentList.twitterLink = "";
        }
        
        let poolName:NSMutableString = ""
        
        let pool:NSArray = info.object(forKey: "poolNames") as! NSArray
        
        for var name in pool{
            poolName.append(name as! String)
        }
        
        if poolName.length > 0 {
            tournamentList.poolName = poolName.substring(to: poolName.length-1)
        }else
        {
            tournamentList.poolName = ""
        }
        
        if let arrPlayers:NSArray = info.object(forKey: "players") as? NSArray {
            if arrPlayers.count > 0 {
                for var playerDetail in arrPlayers{
                    let playerInfo:TEPlayerDetails = TEPlayerDetails.insertPlayerDetail(info: playerDetail as! NSDictionary, context: context, isPlayerApproves: true)
                    tournamentList.addToPlayer(playerInfo)
                }
            }
        }
        
        if let arrPlayers:NSArray = info.object(forKey: "participationRequests") as? NSArray {
            if arrPlayers.count > 0 {
                for var playerDetail in arrPlayers{
                    let playerInfo:TEPlayerDetails = TEPlayerDetails.insertPlayerDetail(info: playerDetail as! NSDictionary, context: context, isPlayerApproves: false)
                    tournamentList.addToPlayer(playerInfo)
                }
            }
        }
        
        if let arrBrackets:NSArray = info.object(forKey: "brackets") as? NSArray {
            if arrBrackets.count > 0 {
                for var bracketDetail in arrBrackets{
                    let bracketInfo:TETournamentBracket = TETournamentBracket.insertBracket(info: bracketDetail as! NSDictionary, conetxt: context)
                    tournamentList.addToBracket(bracketInfo)
                }
            }
        }
        
        if let arrStaff:NSArray = info.object(forKey: "staff") as? NSArray {
            if arrStaff.count > 0 {
                for var staffDetail in arrStaff{
                    let staffInfo:TEStaffDetail = TEStaffDetail.insertStaff(info: staffDetail as! NSDictionary, conetxt: context)
                    tournamentList.addToStaff(staffInfo)
                }
            }
        }
        
        TEMyProfile.save(context)
        
        return tournamentList
    }
    
    static func insertTournamentMiniDetails(info:NSDictionary, context:NSManagedObjectContext, isDummy:Bool, isUserHype:Bool) -> TETournamentList
    {
        let tournamentList:TETournamentList = TETournamentList.newObject(in: context)
        tournamentList.tournamentID = info.stringValueForKey(key: "tournamentID")
        tournamentList.started = info.boolValueForKey(key: "started")
        tournamentList.tournamentTypeName = info.stringValueForKey(key: "tournamentTypeName")
        
        var startKeyName:String = "startDateTime"
        var endKeyName:String = "endDateTime"
        
        if COMMON_SETTING.isEmptyStingOrWithBlankSpace(info.stringValueForKey(key: startKeyName)) {
            startKeyName = "startDate"
        }
        if COMMON_SETTING.isEmptyStingOrWithBlankSpace(info.stringValueForKey(key: endKeyName)) {
            endKeyName = "endDate"
        }
        
        tournamentList.startDateTime = info.stringValueForKey(key: startKeyName)
        tournamentList.endDateTime = info.stringValueForKey(key: endKeyName)
        tournamentList.lastUpdatedAt = info.stringValueForKey(key: "lastUpdatedAt")
        tournamentList.tournamentName = info.stringValueForKey(key: "name")
        tournamentList.imageKay = info.stringValueForKey(key: "imageKey")
        tournamentList.hype = info.boolValueForKey(key: "hype")
        tournamentList.latLong = info.stringValueForKey(key: "latLong")
        tournamentList.completed = info.boolValueForKey(key: "completed")
        
        return tournamentList
    }

    
    static func updateTournamentDetails(info:NSDictionary, tournamentList:TETournamentList, context:NSManagedObjectContext) ->  TETournamentList
    {
        tournamentList.tournamentID = info.stringValueForKey(key: "tournamentID")
        tournamentList.started = info.boolValueForKey(key: "started")
        tournamentList.privateTournament = info.stringValueForKey(key: "privateTournament")

        let tournamentType:NSDictionary = info.object(forKey: "tournamentType") as! NSDictionary
        tournamentList.tournamentTypeName = tournamentType.stringValueForKey(key: "tournamentTypeName")
        tournamentList.tournamentDesciption = tournamentType.stringValueForKey(key: "tournamentTypeDescription")
        tournamentList.tournamentTypeID = tournamentType.stringValueForKey(key: "tournamentTypeID")
        
        tournamentList.rrPtsForGameWin = tournamentType.stringValueForKey(key: "rrPtsForMatchWin")
        tournamentList.rrPtsForMatchTie = tournamentType.stringValueForKey(key: "rrPtsForMatchTie")
        tournamentList.rrPtsForGameWin = tournamentType.stringValueForKey(key: "rrPtsForMatchWin")
        tournamentList.rrPtsForGameTie = tournamentType.stringValueForKey(key: "rrPtsForGameTie")
        tournamentList.rrPtsForGamebye = tournamentType.stringValueForKey(key: "rrPtsForGameBye")
        
        tournamentList.paidTournament = info.boolValueForKey(key : "paid")
        
        tournamentList.preRegistrationCharge = info.stringValueForKey(key : "price")
        var string = tournamentType.stringValueForKey(key: "rankedBy").uppercased()
        string = string.replacingOccurrences(of: "_", with: " ")
        tournamentList.rankedBy = string
        
        tournamentList.showRounds = tournamentType.stringValueForKey(key: "showRounds")
        tournamentList.hype = info.boolValueForKey(key: "hype")
        tournamentList.isCompleteData = true
        tournamentList.userHype = true

        if let game:NSDictionary = info.object(forKey: "game") as! NSDictionary? {
            if game.allKeys.count>0 {
                tournamentList.gameId = game.stringValueForKey(key: "gameID")
                tournamentList.gameDiscription = game.stringValueForKey(key: "description")
                tournamentList.gameName = game.stringValueForKey(key: "name")
                
            }
        }
        tournamentList.maxPlayersInEachBracket = info.stringValueForKey(key: "maxPlayersInEachBracket")
        tournamentList.imageKay = info.stringValueForKey(key: "imageKey")
        tournamentList.completed = info.boolValueForKey(key: "completed")
        tournamentList.webURL = info.stringValueForKey(key: "webURL")
        tournamentList.venue = info.stringValueForKey(key: "venue")
        tournamentList.openSignup = info.stringValueForKey(key: "openSignup")

        tournamentList.tournamentDesciption = info.stringValueForKey(key: "description")
        tournamentList.creatorUserId = info.stringValueForKey(key: "creatorUserId")
        tournamentList.poolCount = info.stringValueForKey(key: "poolCount")
        
        var startKeyName:String = "startDateTime"
        var endKeyName:String = "endDateTime"
        
        if COMMON_SETTING.isEmptyStingOrWithBlankSpace(info.stringValueForKey(key: startKeyName)) {
            startKeyName = "startDate"
        }
        if COMMON_SETTING.isEmptyStingOrWithBlankSpace(info.stringValueForKey(key: endKeyName)) {
            endKeyName = "endDate"
        }
        
        tournamentList.startDateTime = info.stringValueForKey(key: startKeyName)
        tournamentList.endDateTime = info.stringValueForKey(key: endKeyName)
        tournamentList.tournamentName = info.stringValueForKey(key: "name")
        tournamentList.notificationMessage = info.stringValueForKey(key: "notificationMessage")
        tournamentList.twitterMessage = info.stringValueForKey(key: "twitterMessage")

        tournamentList.createdAt = info.stringValueForKey(key: "createdAt")
        tournamentList.lastUpdatedAt = info.stringValueForKey(key: "lastUpdatedAt")
        tournamentList.preRegister = info.boolValueForKey(key: "preRegister")
        tournamentList.considerLocation = info.stringValueForKey(key: "considerLocation")
        tournamentList.considerTeam = info.stringValueForKey(key: "considerTeam")
        
        tournamentList.latLong = info.stringValueForKey(key: "latLong")
        tournamentList.teamBasedTE = info.boolValueForKey(key: "teamBased")

        tournamentList.allowUserScoreSubmission = info.boolValueForKey(key: "allowUserScoreSubmission")
        
        tournamentList.checkInTime = info.stringValueForKey(key: "checkinTime")
        tournamentList.autoApprovalTime = info.stringValueForKey(key: "autoApprovalTime")
        tournamentList.discordChannel = info.boolValueForKey(key: "createDiscordChannel")
        tournamentList.shareURL = info.stringValueForKey(key: "shareUrl")

        if let twitterDetail:NSDictionary = info.object(forKey: "twitter") as? NSDictionary {
            if twitterDetail.allKeys.count>0 {
                tournamentList.twitterHandle = twitterDetail.stringValueForKey(key: "handle")
                tournamentList.twitterLink = twitterDetail.stringValueForKey(key: "link")
            }
        }else{
            tournamentList.twitterHandle = "";
            tournamentList.twitterLink = "";
        }

        let poolName:NSMutableString = ""
        
        let pool:NSArray = info.object(forKey: "poolNames") as! NSArray
        
        for var name in pool{
            poolName.append(name as! String)
        }
        
        if poolName.length > 0 {
            tournamentList.poolName = poolName.substring(to: poolName.length-1)
        }else
        {
            tournamentList.poolName = ""
        }

        if let adminDetail:NSDictionary = info.object(forKey: "adminDetails") as? NSDictionary {
            if adminDetail.allKeys.count>0 {
                tournamentList.creatorUserName = adminDetail.stringValueForKey(key: "username")
                tournamentList.creatorImageKey = adminDetail.stringValueForKey(key: "imageKey")
                tournamentList.creatorDisplayName = adminDetail.stringValueForKey(key: "name")
                
            }
        }
        
        if let seasonDetail:NSDictionary = info.object(forKey: "season") as? NSDictionary {
            if seasonDetail.allKeys.count>0 {
                tournamentList.seasonId = seasonDetail.stringValueForKey(key: "seasonID")
                tournamentList.seasonName = seasonDetail.stringValueForKey(key: "name")
                tournamentList.seasonImageKay = seasonDetail.stringValueForKey(key: "imageKey")
                
            }
        }
        
        if let eventDetail:NSDictionary = info.object(forKey: "event") as? NSDictionary {
            if eventDetail.allKeys.count>0 {
                tournamentList.eventName = eventDetail.stringValueForKey(key: "name")
                tournamentList.eventId = eventDetail.stringValueForKey(key: "eventID")
                tournamentList.eventImageKey = eventDetail.stringValueForKey(key: "imageKey")
                
            }
        }
        if let arrPlayers:NSArray = info.object(forKey: "players") as? NSArray {
            if arrPlayers.count > 0 {
                for var playerDetail in arrPlayers{
                    let playerInfo:TEPlayerDetails = TEPlayerDetails.insertPlayerDetail(info: playerDetail as! NSDictionary, context: context, isPlayerApproves: true)
                    tournamentList.addToPlayer(playerInfo)
                }
            }
        }

        if let arrPlayers:NSArray = info.object(forKey: "participationRequests") as? NSArray {
            if arrPlayers.count > 0 {
                for var playerDetail in arrPlayers{
                    let playerInfo:TEPlayerDetails = TEPlayerDetails.insertPlayerDetail(info: playerDetail as! NSDictionary, context: context, isPlayerApproves: false)
                    tournamentList.addToPlayer(playerInfo)
                }
            }
        }
        
        if let arrBrackets:NSArray = info.object(forKey: "brackets") as? NSArray {
            if arrBrackets.count > 0 {
                for var bracketDetail in arrBrackets{
                    let bracketInfo:TETournamentBracket = TETournamentBracket.insertBracket(info: bracketDetail as! NSDictionary, conetxt: context)
                    tournamentList.addToBracket(bracketInfo)
                }
            }
        }
        
        if let arrStaff:NSArray = info.object(forKey: "staff") as? NSArray {
            if arrStaff.count > 0 {
                for var staffDetail in arrStaff{
                    let staffInfo:TEStaffDetail = TEStaffDetail.insertStaff(info: staffDetail as! NSDictionary, conetxt: context)
                    tournamentList.addToStaff(staffInfo)
                }
            }
        }
        return tournamentList
    }
    
    static func fetchTournamentListDetail(predicate:NSPredicate, context:NSManagedObjectContext) -> NSArray
    {
        let fetchRequest:NSFetchRequest = TETournamentList.newFetchRequest(in: context)
        fetchRequest.predicate = predicate
        
        var fetchedObjects:NSArray = NSArray()
        do {
            fetchedObjects = try context.fetch(fetchRequest) as NSArray
        } catch let error {
            print(error.localizedDescription)
        }
        return fetchedObjects
    }
    
    //MARK: Parsers
    
    static func parseTournamentListMiniDetails(arrTournamentList:NSArray, context:NSManagedObjectContext) -> NSMutableArray
    {
        let tournamentList = NSMutableArray()
        
        for info in arrTournamentList {
            let tournament = TETournamentList.insertTournamentMiniDetails(info: info as! NSDictionary, context: context, isDummy: false, isUserHype: false)
            tournamentList.add(tournament)
        }
        
        self.save(context)
        
        let sortDiscriptor = NSSortDescriptor.init(key: "lastUpdatedAt", ascending: false)
        let arr = tournamentList.sortedArray(using: [sortDiscriptor])
        
        return NSMutableArray.init(array:arr)
    }
    
    static func parseTournamentListDetails(arrTournamentList:NSArray, context:NSManagedObjectContext) -> NSMutableArray
    {
        let tournamentList = NSMutableArray()
        
        for info in arrTournamentList {
            let predicate = NSPredicate(format: "tournamentID == %@", (info as AnyObject).stringValueForKey(key: "tournamentID"))
            let filterObjetcs:NSArray = TETournamentList.fetchTournamentListDetail(predicate: predicate, context: context)
            
            if filterObjetcs.count == 0 {
                let tournament = TETournamentList.insertTournamentDetails(info: info as! NSDictionary, context: context, isDummy: false, isUserHype: false)
                tournamentList.add(tournament)
            }
            else{
                let tournament = TETournamentList.updateTournamentDetails(info: info as! NSDictionary, tournamentList: filterObjetcs.firstObject as! TETournamentList, context: context)
                tournamentList.add(tournament)
            }
        }
        
        self.save(context)
        
        let sortDiscriptor = NSSortDescriptor.init(key: "lastUpdatedAt", ascending: false)
        let arr = tournamentList.sortedArray(using: [sortDiscriptor])
        
        return NSMutableArray.init(array:arr)
    }
    
    static func insertNewTournamentDetail(arrTournamentDetail:NSDictionary, context:NSManagedObjectContext) -> TETournamentList
    {
        let tournamentList:TETournamentList = TETournamentList.insertTournamentDetails(info: arrTournamentDetail, context: context, isDummy: false, isUserHype: false)
        do{
        try context.save()
        } catch let Error{
        print(Error.localizedDescription)
        }
        return tournamentList
    }
    
    static func fetchTournamentListDetail(predicate:NSPredicate, context:NSManagedObjectContext) -> NSArray
    {
        let fetchRequest:NSFetchRequest = TETournamentList.newFetchRequest(in: context)
        fetchRequest.predicate = predicate
        
        var fetchedObjects:NSArray = NSArray()
        do {
            fetchedObjects = try context.fetch(fetchRequest) as NSArray
        } catch let error {
            print(error.localizedDescription)
        }
        return fetchedObjects
    }

 
}
