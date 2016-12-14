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
    case DownloadImage
}

let ServerURL = "https://api.tournamentedition.com/tournamentapis/web/srf/services/"
let Main_Header = ServerURL + "main"
let File_Header = ServerURL + "file"
let Admin_Header = ServerURL + "admin"
let Network_Header = ServerURL + "network"

let imageDownloadURL = "https://s3.amazonaws.com/vgroup-tournament"

// Service Call response handlers

typealias successHandler = (Any?,RequestedUrlType) -> Void
typealias falureHandler = (NSError, String ,RequestedUrlType) -> Void

typealias uploadImageSuccess = (String) -> Void
typealias uploadImageFailed = (NSError, String) -> Void

typealias downloadImageSuccess = (UIImage,String) -> Void
typealias downloadImageFailed = (NSError, String) -> Void

class ServiceCall: NSObject {
    
    //Local Variables
    var sessionManager:AFHTTPSessionManager
    var imageDownloadManager:AFHTTPSessionManager
    
    //Methods
    class var sharedInstance: ServiceCall {
        struct Singleton {
            static let instance = ServiceCall()
        }
        return Singleton.instance
    }
    
     override init() {
        
        self.sessionManager = AFHTTPSessionManager()
        self.sessionManager.requestSerializer = AFJSONRequestSerializer()
        self.sessionManager.responseSerializer = AFJSONResponseSerializer()
        
        self.imageDownloadManager = AFHTTPSessionManager()
        self.imageDownloadManager.requestSerializer = AFJSONRequestSerializer()
        self.imageDownloadManager.responseSerializer = AFHTTPResponseSerializer()
        
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
        case .DownloadImage:
            urlString = String(format: "%@/%@",imageDownloadURL,parameter.value(forKey: "imageKey") as! String)
            break
        }
        
        return urlString
    }
    
    func sendRequest(parameters:NSMutableDictionary ,urlType:RequestedUrlType,method:String,successCall:@escaping successHandler,falureCall:@escaping falureHandler) -> Void {
        
        if !commonSetting.isInternetAvailable {
            
            let error:NSError = NSError();
            falureCall(error,"Internet is not available",urlType)
        }
        
        let strURL = getRequestUrl(urlType: urlType, parameter: parameters)
       
        let manager:AFHTTPSessionManager = self.sessionManager
        
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
    
    func uploadImage(image:UIImage?,parameter:NSDictionary,urlType:RequestedUrlType,successCall:@escaping uploadImageSuccess,falureCall:@escaping uploadImageFailed){
        
        if image == nil {
            let error:NSError = NSError();
            falureCall(error,"Invalid Parameter")
        }
        
        
        
    }
    
    func downloadImage(imageKey:String,urlType:RequestedUrlType,successCall:@escaping downloadImageSuccess,falureCall:@escaping downloadImageFailed){
        
        if commonSetting.isEmptySting(imageKey) {
            let error:NSError = NSError();
            falureCall(error,"Invalid Parameter")
        }
        
        let parameters:NSMutableDictionary = NSMutableDictionary()
        parameters.setValue(imageKey, forKey: "imageKey")
        
        let strURL = getRequestUrl(urlType: urlType, parameter:parameters)
        
        let manager:AFHTTPSessionManager = self.imageDownloadManager

        manager.get(strURL, parameters: nil, progress: nil,
                    success:{(task,responseObject) in
                        
                        if task.state == URLSessionTask.State.canceling || task.state == URLSessionTask.State.suspended
                        {
                            return
                        }
                        
                        if task.state == URLSessionTask.State.completed
                        {
                            if let image:UIImage = UIImage.init(data: responseObject as! Data)
                            {
                                successCall(image,imageKey)
                            }else
                            {
                                let error:NSError = NSError();
                                falureCall(error,"request failed")
                            }
                            
                        }else
                        {
                            let error:NSError = NSError();
                            falureCall(error,"request failed")
                        }
                        
        }, failure: {(task,error) in
            
            falureCall(error as NSError,error.localizedDescription)
            
        })
   }
    
}

