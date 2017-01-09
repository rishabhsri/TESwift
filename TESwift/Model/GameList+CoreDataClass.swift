//
//  GameList+CoreDataClass.swift
//  TESwift
//
//  Created by Apple on 29/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import Foundation
import CoreData


public class GameList: TESwiftModel {

    static func insertGameList(list:NSArray, context:NSManagedObjectContext) -> NSMutableArray
        
    {
        let gameList = NSMutableArray()
        for dic in list {
            let gameDetail:GameList = GameList.newObject(in: context)
            let diction:NSDictionary = dic as! NSDictionary
            gameDetail.name = diction.stringValueForKey(key: "name")
            gameDetail.gameID = diction.stringValueForKey(key: "gameID")
            gameDetail.gameDescripton = diction.stringValueForKey(key: "desciption")
            gameList.add(gameDetail)
        }
        GameList.save(context)
        return gameList
    }
    
    
    
    static func fetchGameList(predicate:NSPredicate, context:NSManagedObjectContext) -> NSArray
        
    {
        let fetchRequest:NSFetchRequest = GameList.newFetchRequest(in: context)
        
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
