//
//  TETournamentList+Parsing.swift
//  TESwift
//
//  Created by Rajanikant Shukla on 13/01/17.
//  Copyright © 2017 V group Inc. All rights reserved.
//

import UIKit

extension  TETournamentList
{
    //MARK: Parsers
    
    static func parseTournamentListMiniDetails(arrTournamentList:NSArray, context:NSManagedObjectContext) -> NSMutableArray
    {
        let tournamentList = NSMutableArray()
        
        for info in arrTournamentList {
            let tournament = TETournamentList.insertTournamentMiniDetails(info: info as! NSDictionary, context: context, isDummy: false, isUserHype: false)
            tournamentList.add(tournament)
        }
        
        let sortDiscriptor = NSSortDescriptor.init(key: "lastUpdatedAt", ascending: false)
        let arr = tournamentList.sortedArray(using: [sortDiscriptor])
        
        return NSMutableArray.init(array:arr)
    }
    
    static func parseTournamentListDetails(arrTournamentList:NSArray, context:NSManagedObjectContext) -> NSMutableArray
    {
        let tournamentList = NSMutableArray()
        
        for info in arrTournamentList {
            let predicate = NSPredicate(format: "tournamentID == %@", (info as! NSDictionary).stringValueForKey(key: "tournamentID"))
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
        
        let sortDiscriptor = NSSortDescriptor.init(key: "lastUpdatedAt", ascending: false)
        let arr = tournamentList.sortedArray(using: [sortDiscriptor])
        
        return NSMutableArray.init(array:arr)
    }
    
    static func parseSearchTournamentListDetails(arrTournamentList:NSArray, context:NSManagedObjectContext) -> NSMutableArray
    {
        let tournamentList = NSMutableArray()
        
        for info in arrTournamentList {
            let predicate = NSPredicate(format: "tournamentID == %@", (info as! NSDictionary).stringValueForKey(key: "tournamentID"))
            let filterObjetcs:NSArray = TETournamentList.fetchTournamentListDetail(predicate: predicate, context: context)
            
            if filterObjetcs.count == 0 {
                let tournament = TETournamentList.insertSearchTournamentDetails(info: info as! NSDictionary, context: context, isDummy: false)
                tournamentList.add(tournament)
            }
            else{
                let tournament:TETournamentList = filterObjetcs.firstObject as! TETournamentList
                tournamentList.add(tournament)
            }
        }
        
        return tournamentList
    }
}
