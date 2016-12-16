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
    
    static func parsetMyProfileDetail(myProfileInfo:NSDictionary, context: NSManagedObjectContext) {
        
        let personInfo:NSMutableDictionary? = myProfileInfo.value(forKey: "person") as! NSMutableDictionary?
        
        let myprofile:TEMyProfile = TEMyProfile.newObject(in: context)
        myprofile.setValue(myProfileInfo.value(forKey: "email"), forKey: "emailid")
        
        if personInfo != nil {
            myprofile.setValue(personInfo?.value(forKey: "city"), forKey: "city")
            myprofile.setValue(personInfo?.value(forKey: "country"), forKey: "country")
            myprofile.setValue(personInfo?.value(forKey: "imageKey"), forKey: "imageKey")
            myprofile.setValue(personInfo?.value(forKey: "location"), forKey: "location")
            myprofile.setValue(personInfo?.value(forKey: "name"), forKey: "name")
            myprofile.setValue(personInfo?.value(forKey: "phoneNumber"), forKey: "phoneNumber")
            myprofile.setValue(personInfo?.value(forKey: "state"), forKey: "state")
            myprofile.setValue(personInfo?.value(forKey: "userID"), forKey: "userid")
            myprofile.setValue(personInfo?.value(forKey: "username"), forKey: "username")
            myprofile.setValue(personInfo?.value(forKey: "discordName"), forKey: "discordname")
            myprofile.setValue(personInfo?.value(forKey: "age") as! NSNumber, forKey: "age")
            myprofile.setValue(personInfo?.value(forKey: "sex"), forKey: "gender")
            myprofile.setValue(personInfo?.value(forKey: "messagingSetting"), forKey: "messageSetting")
            myprofile.setValue(personInfo?.value(forKey: "mailSetting"), forKey: "mailSetting")
            myprofile.setValue(personInfo?.value(forKey: "teamIcon"), forKey: "teamIconUrl")
        }
        
        
        if myProfileInfo.object(forKey: "fbUser") != nil {
            let  fbInfo:UserSocialDetail = UserSocialDetail.insertUserDetails(info:myProfileInfo.value(forKey: "fbUser") as! NSDictionary, context:context, socialMediaType:"FACEBOOK")
            myprofile.addToSocialdetails(fbInfo)
        }
        if myProfileInfo.object(forKey: "twitterUser") != nil {
            let  twitterInfo:UserSocialDetail = UserSocialDetail.insertUserDetails(info:myProfileInfo.value(forKey: "twitterUser") as! NSDictionary, context:context, socialMediaType:"TWITTER")
            myprofile.addToSocialdetails(twitterInfo)
            
        }
        if myProfileInfo.object(forKey: "twitchUser") != nil {
            let  twitchInfo:UserSocialDetail = UserSocialDetail.insertUserDetails(info:myProfileInfo.value(forKey: "twitchUser") as! NSDictionary, context:context, socialMediaType:"TWITCH")
            myprofile.addToSocialdetails(twitchInfo)
            
        }
        if myProfileInfo.object(forKey: "googleUser") != nil {
            let  gpInfo:UserSocialDetail = UserSocialDetail.insertUserDetails(info:myProfileInfo.value(forKey: "googleUser") as! NSDictionary, context:context, socialMediaType:"GOOGLEPLUS")
            myprofile.addToSocialdetails(gpInfo)
            
        }
        
        if myProfileInfo.object(forKey: "subscription") != nil {
            myprofile.subscriptionType = myProfileInfo.stringValueForKey(key: "subscription")
            myprofile.showTeamIcon = myProfileInfo.boolValueForKey(key: "showTeamIcon")
        }
        
        myprofile.tournament = TETournamentList()
        let settings:NSArray? = myProfileInfo.object(forKey: "settings") as! NSArray?
        
        if settings != nil {
            myprofile.setValue(TEMyProfile.notificationTypeValue(settings!, type: "follow".capitalized) as NSNumber, forKey: "follow")
            myprofile.setValue(TEMyProfile.notificationTypeValue(settings!, type: "notify_approved_player".capitalized) as NSNumber, forKey: "notify_approved_player")
            myprofile.setValue(TEMyProfile.notificationTypeValue(settings!, type: "notify_followers".capitalized) as NSNumber, forKey: "notify_followers")
            myprofile.setValue(TEMyProfile.notificationTypeValue(settings!, type: "notify_match_admin".capitalized) as NSNumber, forKey: "notify_match_admin")
            myprofile.setValue(TEMyProfile.notificationTypeValue(settings!, type: "notify_match_player".capitalized) as NSNumber, forKey: "notify_match_player")
            myprofile.setValue(TEMyProfile.notificationTypeValue(settings!, type: "notify_tournament_player".capitalized) as NSNumber, forKey: "notify_tournament_players")
            myprofile.setValue(TEMyProfile.notificationTypeValue(settings!, type: "player_added_to_tournament".capitalized) as NSNumber, forKey: "player_Added_to_tournament")
            myprofile.setValue(TEMyProfile.notificationTypeValue(settings!, type: "tournament_started".capitalized) as NSNumber, forKey: "tournament_started")
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

