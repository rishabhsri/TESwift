//
//  TournamentHelper.swift
//  TESwift
//
//  Created by Rajanikant Shukla on 11/01/17.
//  Copyright © 2017 V group Inc. All rights reserved.
//

import UIKit

typealias teHelper_Success_CallBack = (NSArray) -> Void
typealias teHelper_Falure_CallBack = (NSError, String) -> Void

class TournamentHelper: NSObject
{
    func getTournamentByUser(pageNumber:String,success:@escaping teHelper_Success_CallBack,failure:@escaping teHelper_Falure_CallBack)
    {
        let success: successHandler = {responseObject, responseType in
            
            let responseDict = serviceCall.parseResponse(responseObject: responseObject as Any)
            print(responseDict)
            if let arrTournaments:NSArray = responseDict.object(forKey: "list") as? NSArray
            {
                let arrTournamentList:NSArray = TETournamentList.parseTournamentListMiniDetails(arrTournamentList: arrTournaments, context: APP_DELEGATE.persistentContainer.viewContext)
                success(arrTournamentList)
                
                 TETournamentList.save(APP_DELEGATE.persistentContainer.viewContext)
            }
        }
        let failure: falureHandler = {error, responseString, responseType in
            failure(error,responseString)
        }
        
        let requestDict:NSMutableDictionary = NSMutableDictionary()
        requestDict.setValue("false", forKey: "empty")
        requestDict.setValue(COMMON_SETTING.myProfile?.userid, forKey: "userID")
        requestDict.setValue(pageNumber, forKey: "pagenumber")
        
        // Service call for get user profile data (Hypes, upcomings, person, followers)
        ServiceCall.sharedInstance.sendRequest(parameters: requestDict, urlType: RequestedUrlType.GetUsersTournament, method: "GET", successCall: success, falureCall: failure)
    }
    
    func getTournamentByID(tournamentID:String,success:@escaping teHelper_Success_CallBack,failure:@escaping teHelper_Falure_CallBack)
    {
        let success: successHandler = {responseObject, responseType in
            
            let context = APP_DELEGATE.persistentContainer.viewContext
            
            let responseDict = serviceCall.parseResponse(responseObject: responseObject as Any)
            
            let tournamentID:String = responseDict.stringValueForKey(key: "tournamentID")
            
            let predicate = NSPredicate(format: "tournamentID == [c]%@", tournamentID)
            let array:NSArray = TETournamentList.fetchTournamentListDetail(predicate: predicate, context:context )
            
            if let tournamentDetail:TETournamentList = array.lastObject as! TETournamentList?
            {
                let tournamentObj:TETournamentList = TETournamentList.updateTournamentDetails(info: responseDict, tournamentList: tournamentDetail, context: context)
                success([tournamentObj])
            }else
            {
                let tournamentObj:TETournamentList = TETournamentList.insertTournamentDetails(info: responseDict, context: context, isDummy: false, isUserHype: false)
                success([tournamentObj])
            }
            
        }
        let failure: falureHandler = {error, responseString, responseType in
            failure(error,responseString)
        }
        
        let requestDict:NSMutableDictionary = NSMutableDictionary()
        requestDict.setValue(tournamentID, forKey: "tournamentid")
        ServiceCall.sharedInstance.sendRequest(parameters: requestDict, urlType: RequestedUrlType.GetTournamentByID, method: "GET", successCall: success, falureCall: failure)
    }

}
