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
    case DownloadImage
    case UploadImage
    case GetUserSignUp
    case GetUnAuthSearchedLocation
    case GetMyProfile
    case CheckUserNameExists
    case CheckEmailIdExists
    case GetCurrentAndUpcomingTournament
    case GetTournamentById
    case HypeSearch
    case GetNotificationList
    case UniversalSearch
    case GetUsersTournament
    case SearchTournament
    case UpdateUserProfile
    case GetGameList
    case DisconnectSocialLogin
}

let ServerURL = "https://api.tournamentedition.com/tournamentapis/web/srf/services/"
let Main_Header = ServerURL + "main"
let File_Header = ServerURL + "file"
let Admin_Header = ServerURL + "admin"
let Network_Header = ServerURL + "network"
let Hype_Header = ServerURL + "hype"

let imageDownloadURL = "https://s3.amazonaws.com/vgroup-tournament"

// Service Call response handlers

typealias successHandler = (Any?,RequestedUrlType) -> Void
typealias falureHandler = (NSError, String ,RequestedUrlType) -> Void

typealias searchSuccessHandler = (Any?,RequestedUrlType) -> Void
typealias searchFalureHandler = (NSError, String ,RequestedUrlType) -> Void

typealias uploadImageSuccess = (String) -> Void
typealias uploadImageFailed = (NSError, String) -> Void

typealias downloadImageSuccess = (UIImage,String) -> Void
typealias downloadImageFailed = (NSError, String) -> Void

class ServiceCall: NSObject {
    
    //Local Variables
    var sessionManager:AFHTTPSessionManager
    var imageDownloadManager:AFHTTPSessionManager
    var searchManager:AFHTTPSessionManager
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
        
        self.searchManager = AFHTTPSessionManager()
        self.searchManager.requestSerializer = AFJSONRequestSerializer()
        self.searchManager.responseSerializer = AFHTTPResponseSerializer()
        
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
            
        case .GetNotificationList:
            urlString = String(format: "%@/notifications", Main_Header)
            break
        case .DownloadImage:
            urlString = String(format: "%@/%@",imageDownloadURL,parameter.value(forKey: "imageKey") as! String)
            break
        case .UploadImage:
            urlString = String(format: "%@",File_Header)
            break
        case .GetUserSignUp:
            urlString = String(format: "%@/user/register",Network_Header)
            break
            
        case .GetUnAuthSearchedLocation:
            urlString = String(format: "%@unauthenticated/search/location?query=%@",ServerURL,parameter.value(forKey: "locationText") as! String)
            break
        case .GetMyProfile:
            urlString = String(format: "%@/user/profile",Network_Header)
            break
            
        case .CheckUserNameExists:
            urlString = String(format: "%@unauthenticated/find/user/%@",ServerURL,parameter.stringValueForKey(key: "username"))
            break
        case .CheckEmailIdExists:
            urlString = String(format: "%@unauthenticated/find/email/%@",ServerURL,parameter.stringValueForKey(key: "email"))
            break
        case .GetCurrentAndUpcomingTournament:
            urlString = String(format: "%@/tournament/state/active/%@",Main_Header,parameter.stringValueForKey(key: "userID"))
            break
        case .HypeSearch:
            urlString = String(format: "%@/search",Hype_Header)
            break
        case .UniversalSearch:
            urlString = String(format: "%@/search?q=%@",Main_Header,parameter.stringValueForKey(key: "searchText"))
            break
        case .GetTournamentById:
            urlString = String(format: "%@/tournament/%d",Main_Header,parameter.intValueForKey(key: "tournamentID"))
            break
        case .GetUsersTournament:
            urlString = String(format: "%@/tournament/administeredbyme",Main_Header)
            break
        case .SearchTournament:
            urlString = String(format: "%@/tournament?name=%@",Main_Header,parameter.stringValueForKey(key: "searchText"))
        case .GetGameList:
            urlString = String(format: "%@/games",Main_Header)
            break
        case .UpdateUserProfile:
            urlString = String(format: "%@/user/update/profile",Network_Header)
            break
        
        case .DisconnectSocialLogin:
            urlString = String(format: "%@/user/disconnect/socialnetwork/%@",Network_Header,parameter.stringValueForKey(key: "socialType"))
            break
    
        }
        
        return urlString
    }
    
    func sendRequest(parameters:NSMutableDictionary ,urlType:RequestedUrlType,method:String,successCall:@escaping successHandler,falureCall:@escaping falureHandler) -> Void {
        
        if !commonSetting.isInternetAvailable {
            
            let error:NSError = NSError();
            falureCall(error,kNoInternetConnect,urlType)
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
        
        if urlType == .GetCurrentAndUpcomingTournament
        {
            manager.requestSerializer.setValue("\(PAGE_SIZE)", forHTTPHeaderField: "pagesize")
            manager.requestSerializer.setValue(parameters.stringValueForKey(key: "pagenumber"), forHTTPHeaderField: "pagenumber")
        }else if urlType == .HypeSearch
        {
            manager.requestSerializer.setValue("\(HYPE_PAGE_LIMIT)", forHTTPHeaderField: "pagesize")
            manager.requestSerializer.setValue(parameters.stringValueForKey(key: "pagenumber"), forHTTPHeaderField: "pagenumber")
        }else if urlType == .GetUsersTournament
        {
            manager.requestSerializer.setValue("\(PAGE_SIZE)", forHTTPHeaderField: "pagesize")
            manager.requestSerializer.setValue(parameters.stringValueForKey(key: "pagenumber"), forHTTPHeaderField: "pagenumber")
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
                                DispatchQueue.main.async {
                                    successCall(responseObject,urlType)
                                }
                            }else
                            {
                                let error:NSError = NSError();
                                falureCall(error,"request failed",urlType)
                            }
                            
            }, failure: {(task,error) in
                
                let errorMessage:String = self.parseErrorMessage(error: error)
                if !errorMessage.isEmpty
                {
                    falureCall(error as NSError,errorMessage,urlType)
                }else
                {
                    falureCall(error as NSError,error.localizedDescription,urlType)
                }
                
            })
            
        }else if method == "POST"
        {
            
            if (urlType != .GetUserLogin || urlType != .GetUserSignUp){
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
                                        if (urlType == .GetUserLogin || urlType == .GetUserSignUp){
                                            
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
                                
                                DispatchQueue.main.async {
                                    successCall(responseObject,urlType)
                                }
                            }else
                            {
                                let error:NSError = NSError();
                                falureCall(error,"request failed",urlType)
                            }
                            
            }, failure: {(task, error) in
                
                let errorMessage:String = self.parseErrorMessage(error: error)
                if !errorMessage.isEmpty
                {
                    falureCall(error as NSError,errorMessage,urlType)
                }else
                {
                    falureCall(error as NSError,error.localizedDescription,urlType)
                }
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
                                    DispatchQueue.main.async {
                                        successCall(responseObject,urlType)
                                    }
                                }else
                                {
                                    let error:NSError = NSError();
                                    falureCall(error,"request failed",urlType)
                                }
                                
                }, failure: {(task, error) in
                    
                    let errorMessage:String = self.parseErrorMessage(error: error)
                    if !errorMessage.isEmpty
                    {
                        falureCall(error as NSError,errorMessage,urlType)
                    }else
                    {
                        falureCall(error as NSError,error.localizedDescription,urlType)
                    }
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
                                    DispatchQueue.main.async {
                                        successCall(responseObject,urlType)
                                    }
                                }else
                                {
                                    let error:NSError = NSError();
                                    falureCall(error,"request failed",urlType)
                                }
                                
                }, failure: {(task, error) in
                    
                    let errorMessage:String = self.parseErrorMessage(error: error)
                    if !errorMessage.isEmpty
                    {
                        falureCall(error as NSError,errorMessage,urlType)
                    }else
                    {
                        falureCall(error as NSError,error.localizedDescription,urlType)
                    }
                })
            }
        }
    }
    
    func parseErrorMessage(error:Error) -> String {
        
        let errorObj:NSError = error as NSError
        if let infoData:Data =  errorObj.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data
        {
            if let errResponse: String = String(data:infoData, encoding: String.Encoding.utf8)
            {
                let responseDict = BaseViewController().parseResponse(responseObject: errResponse as Any)
                if let array:NSArray = responseDict.value(forKey: "errorMessages") as? NSArray {
                    if let errorMessage:String = array.firstObject as? String
                    {
                        return errorMessage
                    }
                }
            }
        }
        return ""
    }
    
    func uploadImage(image:UIImage?,urlType:RequestedUrlType,successCall:@escaping uploadImageSuccess,falureCall:@escaping uploadImageFailed){
        
        if image == nil {
            let error:NSError = NSError();
            falureCall(error,"Invalid Parameter")
        }else if !commonSetting.isInternetAvailable {
            let error:NSError = NSError();
            falureCall(error,kNoInternetConnect)
        }
        
        var receivedImage:UIImage = image!
        receivedImage = UIImage.fixrotation(receivedImage)
        let imageData:Data = UIImageJPEGRepresentation(receivedImage, 0.1)!
        
        let strURL = getRequestUrl(urlType: urlType, parameter:NSMutableDictionary())
        
        let manager:AFHTTPSessionManager = AFHTTPSessionManager()
        self.imageDownloadManager.requestSerializer = AFHTTPRequestSerializer()
        self.imageDownloadManager.responseSerializer = AFHTTPResponseSerializer()
        
        
        
        manager.post(strURL, parameters: nil, constructingBodyWith:{(formData: AFMultipartFormData) in
            formData.appendPart(withFileData: imageData, name: "file", fileName: "image.jpg", mimeType: "image/jpeg")
        }, progress: nil,
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
                        if let resosneString:String = responseObject as? String{
                            successCall(resosneString)
                        }
                    }
                }
            }else
            {
                let error:NSError = NSError();
                falureCall(error,"request failed")
            }
            
        }, failure: {(task, error) in
            
            let errorMessage:String = self.parseErrorMessage(error: error)
            if !errorMessage.isEmpty
            {
                falureCall(error as NSError,errorMessage)
            }else
            {
                falureCall(error as NSError,error.localizedDescription)
            }
        })
        
    }
    
    func downloadImage(imageKey:String,urlType:RequestedUrlType,successCall:@escaping downloadImageSuccess,falureCall:@escaping downloadImageFailed){
        
        if !commonSetting.isInternetAvailable {
            let error:NSError = NSError();
            falureCall(error,kNoInternetConnect)
        }else if commonSetting.isEmptyStingOrWithBlankSpace(imageKey) {
            let error:NSError = NSError();
            falureCall(error,"Invalid Parameter")
        }
        
        if let cachedImage:UIImage = self.getImageForKey(imageKey: imageKey)
        {
            successCall(cachedImage,imageKey)
        }else
        {
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
                                    self.saveImage(imageData: responseObject as! Data, imageKey: imageKey)
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
                
                let errorMessage:String = self.parseErrorMessage(error: error)
                if !errorMessage.isEmpty
                {
                    falureCall(error as NSError,errorMessage)
                }else
                {
                    falureCall(error as NSError,error.localizedDescription)
                }
                
            })
        }
    }
    
    func sendSearchRequest(searchText:String ,urlType:RequestedUrlType,pageNumber:String,successCall:@escaping searchSuccessHandler,falureCall:@escaping searchFalureHandler) -> Void
    {
        
        let parameter:NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(searchText, forKey: "searchText")
        
        let strURL = getRequestUrl(urlType: urlType, parameter: parameter)
        
        let manager:AFHTTPSessionManager = self.sessionManager
        
        self.cancleAllSearchRequests()
        
        //            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        //            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var authKey:String = ""
        
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "authkey") != nil {
            authKey = defaults.value(forKey: "authkey") as! String
        }
        
        manager.requestSerializer.setValue("\(PAGE_SIZE)", forHTTPHeaderField: "pagesize")
        manager.requestSerializer.setValue(pageNumber, forHTTPHeaderField: "pagenumber")
        
        
        manager.get(strURL, parameters: parameter, progress: nil,
                    success:{(task,responseObject) in
                        
                        if task.state == URLSessionTask.State.canceling || task.state == URLSessionTask.State.suspended
                        {
                            return
                        }
                        
                        if task.state == URLSessionTask.State.completed
                        {
                            DispatchQueue.main.async {
                                successCall(responseObject,urlType)
                            }
                        }else
                        {
                            let error:NSError = NSError();
                            falureCall(error,"request failed",urlType)
                        }
                        
        }, failure: {(task,error) in
            
            let errorMessage:String = self.parseErrorMessage(error: error)
            if !errorMessage.isEmpty
            {
                falureCall(error as NSError,errorMessage,urlType)
            }else
            {
                falureCall(error as NSError,error.localizedDescription,urlType)
            }
            
        })
    }
    
    func cancleAllSearchRequests() {
        self.searchManager.operationQueue.cancelAllOperations()
    }
    
    
    func getImageForKey(imageKey:String) -> UIImage?{
        
        if commonSetting.isEmptyStingOrWithBlankSpace(imageKey)
        {
            return nil
        }else
        {
            let filePath:String = self.getDocumentsDirectoryPath().appendingFormat("/%@.png", imageKey)
            if let image = UIImage(contentsOfFile: filePath)
            {
                return image
            }else
            {
                return nil
            }
        }
    }
    
    func saveImage(imageData:Data,imageKey:String) {
        
        let filePath:String = self.getDocumentsDirectoryPath().appendingFormat("/%@.png", imageKey)
        let fileURL = NSURL(string:"file://\(filePath)")
        
        do {
            try imageData.write(to: fileURL as! URL, options: .atomic)
            print("saved")
        } catch {
            print(error)
        }
    }
    
    func deleteCacheImageForKey(imageKey:String) {
        let filePath:String = self.getDocumentsDirectoryPath().appendingFormat("/%@.png", imageKey)
        do {
            try FileManager.default.removeItem(atPath: filePath)
        } catch {
            print(error)
        }
    }
    
    func getDocumentsDirectoryPath() -> String {
        
        let documentsDirectory:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let imageDirectoryPath:String = documentsDirectory.appendingFormat("/%@", "TESWIFTIMAGES")
        
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: imageDirectoryPath, isDirectory:&isDir) {
            if !isDir.boolValue {
                do {
                    try FileManager.default.createDirectory(atPath: imageDirectoryPath, withIntermediateDirectories: false, attributes: nil)
                } catch let error as NSError {
                    print(error.localizedDescription);
                }
            }
        } else {
            do {
                try FileManager.default.createDirectory(atPath: imageDirectoryPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        return imageDirectoryPath
    }
    
}

