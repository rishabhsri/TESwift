//
//  TEStaffDetail+CoreDataClass.swift
//  TESwift
//
//  Created by Apple on 22/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import Foundation
import CoreData


public class TEStaffDetail: TESwiftModel {
    
    
    static func insertStaff(info: NSDictionary, conetxt: NSManagedObjectContext) -> TEStaffDetail
    {
        let staffDetail:TEStaffDetail = TEStaffDetail.newObject(in: conetxt)
        
        staffDetail.name = info.stringValueForKey(key: "name")
        staffDetail.country = info.stringValueForKey(key: "country")
        staffDetail.email = info.stringValueForKey(key: "email")
        staffDetail.imageKey = info.stringValueForKey(key: "imageKey")
        staffDetail.location = info.stringValueForKey(key: "location")
        staffDetail.phoneNumber = info.stringValueForKey(key: "phoneNumber")
        staffDetail.state = info.stringValueForKey(key: "state")
        staffDetail.userID = info.stringValueForKey(key: "userID")
        staffDetail.username = info.stringValueForKey(key: "username")
        staffDetail.city = info.stringValueForKey(key: "city")
        
        return staffDetail
    }
}
