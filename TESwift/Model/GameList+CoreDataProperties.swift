//
//  GameList+CoreDataProperties.swift
//  TESwift
//
//  Created by Apple on 29/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import Foundation
import CoreData


extension GameList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameList> {
        return NSFetchRequest<GameList>(entityName: "GameList");
    }

    @NSManaged public var name: String?
    @NSManaged public var gameID: String?
    @NSManaged public var gameDescripton: String?

}
