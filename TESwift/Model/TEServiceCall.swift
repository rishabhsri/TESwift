//
//  TEServiceCall.swift
//  TESwift
//
//  Created by Rajanikant Shukla on 08/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//


import Foundation
import UIKit

enum RequestedUrlType {
    case GetUserLogin
    case GetUserProfileData
    case GetAllNotification
}

let ServerURL = "https://api.tournamentedition.com/tournamentapis/web/srf/services/"
let Main_Header = ServerURL + "main"
let File_Header = ServerURL + "file"
let Admin_Header = ServerURL + "admin"
let Network_Header = ServerURL + "network"

typealias successHandler = (Any?,RequestedUrlType) -> Void
typealias falureHandler = (NSError, String ,RequestedUrlType) -> Void

class ServiceCall: NSObject {
    
    //Methods
    class var sharedInstance: ServiceCall {
        struct Singleton {
            static let instance = ServiceCall()
        }
        return Singleton.instance
    }
    
    func getRequestUrl(urlType: RequestedUrlType , parameter:NSMutableDictionary ) -> String {
        
        var urlString:String = ""
        
        switch urlType
        {
        case .GetUserLogin:
            urlString = String(format: "%@/login",Network_Header)
            break
            
        case .GetUserProfileData:
            urlString = String(format: "%@/user/profile/web", Network_Header)
            break
            
        case .GetAllNotification:
            urlString = String(format: "%@/notifications", Main_Header)
            break
        }
        
        return urlString
    }
    
    func sendRequest(parameters:NSMutableDictionary ,urlType:RequestedUrlType,method:String,successCall:@escaping successHandler,falureCall:@escaping falureHandler) -> Void {
        
        let strURL = getRequestUrl(urlType: urlType, parameter: parameters)
        let manager:AFHTTPSessionManager = AFHTTPSessionManager.init(baseURL: NSURL(string: strURL) as URL?)
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var authKey:String = ""
        
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "authkey") != nil {
            authKey = defaults.value(forKey: "authkey") as! String
        }
        
        if method == "GET" {
            
            manager.get(strURL, parameters: parameters, progress: nil,
                        success:{(task,responseObject) in
                            
                            if task.state == URLSessionTask.State.canceling || task.state == URLSessionTask.State.suspended
                            {
                                return
                            }
                            
                            if task.state == URLSessionTask.State.completed
                            {
                                successCall(responseObject,urlType)
                            }else
                            {
                                let error:NSError = NSError();
                                falureCall(error,"request failed",urlType)
                            }
                            
            }, failure: {(task,error) in
                
                falureCall(error as NSError,error.localizedDescription,urlType)
                
            })
            
        }else if method == "POST"
        {
            
            if urlType != .GetUserLogin {
                manager.requestSerializer.setValue(authKey,forHTTPHeaderField:"AUTH-KEY")
            }
            
            manager.post(strURL, parameters: parameters, progress: nil,
                         success:{(task, responseObject) in
                            
                            if task.state == URLSessionTask.State.canceling || task.state == URLSessionTask.State.suspended
                            {
                                return
                            }
                            
                            if task.state == URLSessionTask.State.completed
                            {
                                if let httpResponse:HTTPURLResponse = task.response as? HTTPURLResponse
                                {
                                    if(httpResponse.statusCode == 200)
                                    {
                                        if urlType == .GetUserLogin {
                                            
                                            if let headers = httpResponse.allHeaderFields as NSDictionary? as! [String:String]?
                                            {
                                                let cookieString:String = headers["Set-Cookie"]!
                                                let seperatedStrings:Array = cookieString.components(separatedBy: ";")
                                                let seperatedStrings2:Array = (seperatedStrings.first?.components(separatedBy: "="))!
                                                let authKey:String = seperatedStrings2.last!
                                                
                                                defaults.set(authKey, forKey: "authkey")
                                                defaults.synchronize()
                                            }
                                        }
                                    }
                                }
                                
                                successCall(responseObject,urlType)
                            }else
                            {
                                let error:NSError = NSError();
                                falureCall(error,"request failed",urlType)
                            }
                            
            }, failure: {(task, error) in
                
                falureCall(error as NSError,error.localizedDescription,urlType)
            })
            
            
        }else if method == "PUT" || method == "DELETE"
        {
            
            manager.requestSerializer.setValue(authKey,forHTTPHeaderField:"AUTH-KEY")
            
            if method == "PUT" {
                manager.put(strURL, parameters: parameters,
                            success:{(task, responseObject) in
                                
                                if task.state == URLSessionTask.State.canceling || task.state == URLSessionTask.State.suspended
                                {
                                    return
                                }
                                
                                if task.state == URLSessionTask.State.completed
                                {
                                    successCall(responseObject,urlType)
                                }else
                                {
                                    let error:NSError = NSError();
                                    falureCall(error,"request failed",urlType)
                                }
                                
                }, failure: {(task, error) in
                    
                    falureCall(error as NSError,error.localizedDescription,urlType)
                })
                
            }else
            {
                manager.delete(strURL, parameters: parameters,
                               success:{(task, responseObject) in
                                
                                if task.state == URLSessionTask.State.canceling || task.state == URLSessionTask.State.suspended
                                {
                                    return
                                }
                                
                                if task.state == URLSessionTask.State.completed
                                {
                                    successCall(responseObject,urlType)
                                }else
                                {
                                    let error:NSError = NSError();
                                    falureCall(error,"request failed",urlType)
                                }
                                
                }, failure: {(task, error) in
                    
                    falureCall(error as NSError,error.localizedDescription,urlType)
                })
                
            }
        }
    }
}

