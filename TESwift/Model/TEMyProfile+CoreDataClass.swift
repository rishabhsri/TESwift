//
//  TEMyProfile+CoreDataClass.swift
//
//
//  Created by Apple on 16/12/16.
//
//

import Foundation
import CoreData


public class TEMyProfile: TESwiftModel {
    
    static func deleteAllFormMyProfile(context:NSManagedObjectContext) {
        
        _ = TEMyProfile.newObject(in: context)
        TEMyProfile.deleteAllFromEntity(inManage: context)
    }
    
    static func insertMyProfileDetail(myProfileInfo:NSDictionary, context: NSManagedObjectContext) {
        
        let personInfo:NSDictionary? = myProfileInfo.object(forKey: "person") as! NSDictionary?
        
        let myprofile:TEMyProfile = TEMyProfile.newObject(in: context)
        myprofile.setValue(myProfileInfo.value(forKey: "email"), forKey: "emailid")
        
        if personInfo != nil {
            
            myprofile.city = personInfo?.stringValueForKey(key: "city")
            myprofile.country = personInfo?.stringValueForKey(key: "country")
            myprofile.imageKey = personInfo?.stringValueForKey(key: "imageKey")
            myprofile.location = personInfo?.stringValueForKey(key: "location")
            myprofile.name = personInfo?.stringValueForKey(key: "name")
            myprofile.phoneNumber = personInfo?.stringValueForKey(key: "phoneNumber")
            myprofile.state = personInfo?.stringValueForKey(key: "state")
            myprofile.userid = personInfo?.stringValueForKey(key: "userID")
            myprofile.username = personInfo?.stringValueForKey(key: "username")
            myprofile.discordname = personInfo?.stringValueForKey(key: "discordName")
            myprofile.age = Int16((personInfo?.intValueForKey(key: "age"))! as Int)
            myprofile.gender = personInfo?.stringValueForKey(key: "sex")
            myprofile.messageSetting = (personInfo?.boolValueForKey(key: "messagingSetting"))!
            myprofile.mailSetting = (personInfo?.boolValueForKey(key: "mailSetting"))!
            myprofile.teamIconUrl = personInfo?.stringValueForKey(key: "teamIcon")
            
        }
        
        // Configure Social media info
        if let fbInfo:NSDictionary = myProfileInfo.object(forKey: "fbUser") as? NSDictionary {
            let  fbInfo:UserSocialDetail = UserSocialDetail.insertUserDetails(info:fbInfo, context:context, socialMediaType:"FACEBOOK")
            myprofile.addToSocialdetails(fbInfo)
        }
        
        if let twitterInfo:NSDictionary = myProfileInfo.object(forKey: "twitterUser") as? NSDictionary
        {
            let  twitterInfo:UserSocialDetail = UserSocialDetail.insertUserDetails(info:twitterInfo, context:context, socialMediaType:"TWITTER")
            myprofile.addToSocialdetails(twitterInfo)
            
        }
        
        if let twitchInfo:NSDictionary = myProfileInfo.object(forKey: "twitchUser") as? NSDictionary {
            let  twitchInfo:UserSocialDetail = UserSocialDetail.insertUserDetails(info:twitchInfo, context:context, socialMediaType:"TWITCH")
            myprofile.addToSocialdetails(twitchInfo)
            
        }
        if let gPInfo:NSDictionary = myProfileInfo.object(forKey: "googleUser") as? NSDictionary {
            let  gpInfo:UserSocialDetail = UserSocialDetail.insertUserDetails(info:gPInfo, context:context, socialMediaType:"GOOGLEPLUS")
            myprofile.addToSocialdetails(gpInfo)
            
        }
        
        if let subInfo:NSDictionary = myProfileInfo.object(forKey: "subscription") as? NSDictionary {
            myprofile.subscriptionType = subInfo.stringValueForKey(key: "subscription")
            myprofile.showTeamIcon = subInfo.boolValueForKey(key: "showTeamIcon")
        }
        
        //  myprofile.tournament = TETournamentList()
        
        
        if let settings:NSArray = myProfileInfo.object(forKey: "settings") as? NSArray {
            
            myprofile.follow = TEMyProfile.notificationTypeValue(settings, type: "follow".uppercased())
            
            myprofile.notify_followers = TEMyProfile.notificationTypeValue(settings, type: "notify_followers".uppercased())
            
            myprofile.notify_approved_player = TEMyProfile.notificationTypeValue(settings, type: "notify_approved_player".uppercased())
            
            myprofile.notify_match_admin = TEMyProfile.notificationTypeValue(settings, type: "notify_match_admin".uppercased())
            
            myprofile.notify_match_palyer = TEMyProfile.notificationTypeValue(settings, type: "notify_match_player".uppercased())
            
            myprofile.notify_topurnament_player = TEMyProfile.notificationTypeValue(settings, type: "notify_tournament_players".uppercased())
            
            myprofile.player_Added_to_tournament = TEMyProfile.notificationTypeValue(settings, type: "player_Added_to_tournament".uppercased())
            
            myprofile.tournament_started = TEMyProfile.notificationTypeValue(settings, type: "tournament_started".uppercased())
            
        }
        
        
        TEMyProfile.save(context)
    }
    
    static func notificationTypeValue(_ settings: NSArray, type: String) -> Bool {
           var arry = settings.filtered(using: NSPredicate(format: "setting == %@", type))
           if arry.count == 1 {
            let dict = arry[0] as! NSDictionary
            return dict.value(forKey: "value") as! Bool
           }
           else {
            return true
           }
     }
    
}

