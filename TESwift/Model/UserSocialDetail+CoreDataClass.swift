//
//  UserSocialDetail+CoreDataClass.swift
//
//
//  Created by Apple on 16/12/16.
//
//

import Foundation
import CoreData


public class UserSocialDetail: TESwiftModel {
    
    static func insertUserDetails(info:NSDictionary, context:NSManagedObjectContext, socialMediaType:String) -> UserSocialDetail {
        
        let userSocialDetail:UserSocialDetail = UserSocialDetail.newObject(in: context)
        
        if socialMediaType == "FACEBOOK" {
            
            userSocialDetail.emailId = info.stringValueForKey(key: "email")
            userSocialDetail.name = info.stringValueForKey(key: "name")
            userSocialDetail.userName = info.stringValueForKey(key: "username")
            userSocialDetail.imageKey = info.stringValueForKey(key: "imageKey")
            userSocialDetail.userId = info.stringValueForKey(key: "id")
            userSocialDetail.connectType = "FACEBOOK"
            
        }
        if socialMediaType == "TWITTER" {
            userSocialDetail.emailId = ""
            
            userSocialDetail.name = info.stringValueForKey(key: "name")
            userSocialDetail.userName = info.stringValueForKey(key: "twitterHandle")
            userSocialDetail.imageKey = info.stringValueForKey(key: "imageKey")
            userSocialDetail.userId = info.stringValueForKey(key: "id")
            userSocialDetail.link = info.stringValueForKey(key: "twitterLink")
            userSocialDetail.connectType = "TWITTER"
            
        }
        if socialMediaType == "TWITCH" {
            userSocialDetail.emailId = info.stringValueForKey(key: "mail")
            userSocialDetail.name = info.stringValueForKey(key: "name")
            userSocialDetail.userName = info.stringValueForKey(key: "displayName")
            userSocialDetail.imageKey = info.stringValueForKey(key: "imageKey")
            userSocialDetail.userId = info.stringValueForKey(key: "id")
            userSocialDetail.link = info.stringValueForKey(key: "twitchLink")
            userSocialDetail.connectType = "TWITCH"
            
            
        }
        if socialMediaType == "GOOGLEPLUS" {
            userSocialDetail.emailId = ""
            userSocialDetail.name = info.stringValueForKey(key: "name")
            userSocialDetail.userName = info.stringValueForKey(key: "screenName")
            userSocialDetail.imageKey = info.stringValueForKey(key: "imageKey")
            userSocialDetail.userId = info.stringValueForKey(key: "id")
            userSocialDetail.connectType = "GOOGLEPLUS"
            
        }
        return userSocialDetail
    }
    
}
