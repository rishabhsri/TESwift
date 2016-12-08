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
}

let ServerURL = "https://api.tournamentedition.com/tournamentapis/web/srf/services/"
let Main_Header = ServerURL + "main"
let File_Header = ServerURL + "file"
let Admin_Header = ServerURL + "admin"
let Network_Header = ServerURL + "network"

typealias successHandler = (NSDictionary ,RequestedUrlType) -> Void
typealias falureHandler = (String ,RequestedUrlType) -> Void

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
            fallthrough
        default :
            urlString = ""
        }
        return urlString
    }
    
    func sendRequest(parameters:NSMutableDictionary ,urlType:RequestedUrlType,method:String,successCall:@escaping successHandler,falureCall:@escaping falureHandler) -> Void {
        
        let strURL = getRequestUrl(urlType: urlType, parameter: parameters)
        let manager:AFHTTPSessionManager = AFHTTPSessionManager.init(baseURL: NSURL(string: strURL) as URL?)
        
        let defaults = UserDefaults.standard
        
        if method == "GET" {
            if defaults.value(forKey: "authkey") != nil {
                manager.requestSerializer.setValue(defaults.value(forKey: "authkey") as? String,forHTTPHeaderField:"AUTH-KEY")
            }
            
            manager.get(strURL, parameters: parameters, progress: nil,
                        success:{(task,responseObject) in
                            
                            if task.state == URLSessionTask.State.canceling || task.state == URLSessionTask.State.suspended
                            {
                                return
                            }
                            
                            if task.state == URLSessionTask.State.completed
                            {
                                let responseDict:NSDictionary = responseObject as! NSDictionary
                                successCall(responseDict,urlType)
                            }else
                            {
                                falureCall("request failed",urlType)
                            }
                            
            }, failure: {(task,error) in
                
                falureCall(error.localizedDescription,urlType)
                
            })
            
        }else if method == "POST"
        {
            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if urlType != .GetUserLogin {
                if defaults.value(forKey: "authkey") != nil {
                    manager.requestSerializer.setValue(defaults.value(forKey: "authkey") as? String,forHTTPHeaderField:"AUTH-KEY")
                }
            }
            
            manager.post(strURL, parameters: parameters, progress: nil,
                         success:{(task, responseObject) in
                            
                            if task.state == URLSessionTask.State.canceling || task.state == URLSessionTask.State.suspended
                            {
                                return
                            }
                            
                            if task.state == URLSessionTask.State.completed
                            {
                                let responseDict:NSDictionary = responseObject as! NSDictionary
                                 successCall(responseDict,urlType)
                            }else
                            {
                                falureCall("request failed",urlType)
                            }
                            
            }, failure: {(task, error) in
                
                falureCall(error.localizedDescription,urlType)
            })
            
            
        }else if method == "PUT" || method == "DELETE"
        {
            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if defaults.value(forKey: "authkey") != nil {
                manager.requestSerializer.setValue(defaults.value(forKey: "authkey") as? String,forHTTPHeaderField:"AUTH-KEY")
            }
            if method == "PUT" {
                manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
                manager.put(strURL, parameters: parameters,
                            success:{(task, responseObject) in
                                
                                if task.state == URLSessionTask.State.canceling || task.state == URLSessionTask.State.suspended
                                {
                                    return
                                }
                                
                                if task.state == URLSessionTask.State.completed
                                {
                                    let responseDict:NSDictionary = responseObject as! NSDictionary
                                     successCall(responseDict,urlType)
                                }else
                                {
                                    falureCall("request failed",urlType)
                                }
                                
                }, failure: {(task, error) in
                    
                    falureCall(error.localizedDescription,urlType)
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
                                    let responseDict:NSDictionary = responseObject as! NSDictionary
                                     successCall(responseDict,urlType)
                                }else
                                {
                                    falureCall("request failed",urlType)
                                }
                                
                }, failure: {(task, error) in
                    
                    falureCall(error.localizedDescription,urlType)
                })
                
            }
        }
    }
}

