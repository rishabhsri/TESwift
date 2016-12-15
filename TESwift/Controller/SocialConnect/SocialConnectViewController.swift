//
//  SocialConnectViewController.swift
//  TESwift
//
//  Created by Rajanikant Shukla on 14/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class SocialConnectViewController: BaseViewController,SocialLoginViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Social Connect handlers
    
    //MARK: Facebook Login
    @IBAction func socialLoginViaFacebook(_ sender: Any)
    {
        let storyBoard = UIStoryboard(name: "Storyboard", bundle: nil)
        let socialLoginController = storyBoard.instantiateViewController(withIdentifier: "SocialLoginViewControllerID") as! SocialLoginViewController
        socialLoginController.socialConnectType = .FACEBOOK
        socialLoginController.delegate = self
        self.navigationController?.present(socialLoginController, animated: true, completion: nil)
    }
    
    //MARK: GooglePlus Login
    @IBAction func socialLoginViaGooglePlus(_ sender: Any)
    {
        let storyBoard = UIStoryboard(name: "Storyboard", bundle: nil)
        let socialLoginController = storyBoard.instantiateViewController(withIdentifier: "SocialLoginViewControllerID") as! SocialLoginViewController
        socialLoginController.socialConnectType = .GOOGLEPLUS
        socialLoginController.delegate = self
        self.navigationController?.present(socialLoginController, animated: true, completion: nil)
    }
    
    //MARK: Twitch Login
    @IBAction func socialLoginViaTwitch(_ sender: Any)
    {
        let storyBoard = UIStoryboard(name: "Storyboard", bundle: nil)
        let socialLoginController = storyBoard.instantiateViewController(withIdentifier: "SocialLoginViewControllerID") as! SocialLoginViewController
        socialLoginController.socialConnectType = .TWITCH
        socialLoginController.delegate = self
        self.navigationController?.present(socialLoginController, animated: true, completion: nil)
    }
    
    //MARK:- SocialLoginViewController Delegates
    
    func didSocialLoginSuccessfully(sessionKey: String, connectType: SocialConnectType) {
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isSocialLogin")
        defaults.removeObject(forKey: "authkey")
        defaults.synchronize()
        
        let parameters:NSMutableDictionary = NSMutableDictionary()
        parameters.setValue(sessionKey, forKey: "key")
        
        self.proceedLogin(parameters)
        
    }
    
    func proceedLogin(_ userInfo: NSMutableDictionary) {
        //On Success Call
        
        let success:successHandler = {responseObject,requestType in
            // Success call implementation
            let responseDict:NSDictionary = self.parseResponse(responseObject: responseObject as Any)
            
            if responseDict.intValueForKey(key: "validUserName") == 1
            {
                if responseDict.boolValueForKey(key: "loggedIn") {
                    self.onLogInSuccess(responseDict)
                }
            }else
            {
                // ask for new username
            }
        }
        
        //On Falure Call
        let falure:falureHandler = {error,responseMessage,requestType in
            
            // Falure call implementation
            self.showAlert(title: kError, message: responseMessage, tag: 0)
            
        }
        
        ServiceCall.sharedInstance.sendRequest(parameters: userInfo, urlType: RequestedUrlType.GetUserLogin, method: "POST", successCall: success, falureCall: falure)
    }
    
    func didSocialLoginFailed(errorString:String,connectType:SocialConnectType)
    {
        if !commonSetting.isEmptySting(errorString) {
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.showAlert(title: kError, message: errorString, tag: 0)
            }
        }
    }
    
    func onLogInSuccess(_ userInfo: NSDictionary) -> Void {
        
        //overrided in child
    }
    
}
