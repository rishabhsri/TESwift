//
//  SocialLoginViewController.swift
//  TESwift
//
//  Created by Rajanikant Shukla on 14/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

protocol SocialLoginViewControllerDelegate
{
    func didSocialLoginSuccessfully(sessionKey:String,connectType:SocialConnectType)
    func didSocialLoginFailed(errorString:String,connectType:SocialConnectType)
}

class SocialLoginViewController: BaseViewController,UIWebViewDelegate {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var pwdButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    
    //local variables
    var socialConnectType:SocialConnectType?
    var delegate: SocialLoginViewControllerDelegate?
    //var cameFromSignup:Bool = false
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadWebView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
     super.viewDidDisappear(animated)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Utilities
    
    func loadWebView() {
        
        var urlString:String = ""
        
        switch self.socialConnectType!
        {
        case .FACEBOOK:
            urlString = String(format: "%@/login/facebook",Network_Header)
            self.titleLabel.text = "Facebook Login"
            break
            
        case .GOOGLEPLUS:
            urlString = String(format: "%@/login/google", Network_Header)
            self.titleLabel.text = "GooglePlus Login"
            break
            
        case .TWITCH:
            urlString = String(format: "%@/login/twitch", Network_Header)
            self.titleLabel.text = "Twitch Login"
            break
            
        case .TWITTER:
            urlString = String(format: "%@/web/connecttournament/twitter", Network_Header)
            self.titleLabel.text = "Twitter Login"
            break
        case .NON:
            return

        }
        
        let webRequest:NSMutableURLRequest = NSMutableURLRequest(url: URL(string: urlString)!)
        
        //Delete cookie
        URLCache.shared.removeCachedResponse(for: webRequest as URLRequest)
        let cookieStorage:HTTPCookieStorage = HTTPCookieStorage.shared
        for cookie in cookieStorage.cookies! {
            cookieStorage.deleteCookie(cookie)
        }
        /*
         if (cookie.domain.contains("twitch") || cookie.domain.contains("google") || cookie.domain.contains("facebook")) {
         cookieStorage.deleteCookie(cookie)
         }
         */
        
        let defaults = UserDefaults.standard
        if let authKey:String = defaults.value(forKey: "authkey") as! String? {
            
            let cookieProperties: [HTTPCookiePropertyKey: Any] = [HTTPCookiePropertyKey.name: "AUTH-KEY", HTTPCookiePropertyKey.value: authKey]
            if let cookie = HTTPCookie.init(properties: cookieProperties)
            {
                let headers:NSDictionary = HTTPCookie.requestHeaderFields(with: [cookie]) as NSDictionary
                webRequest.allHTTPHeaderFields = headers as? [String : String]
            }
        }
        
        self.showHUD()
        self.webView.loadRequest(webRequest as URLRequest)
        
    }
    
    // MARK: - IBAction Methods
    
    @IBAction func actionOnRefresh(_ sender: Any)
    {
    }
    
    @IBAction func actionOnStop(_ sender: Any)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.webView.stopLoading()
    }
    
    @IBAction func actionOnClose(_ sender: Any)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.showHUD()
        self.delegate?.didSocialLoginFailed(errorString: "", connectType: self.socialConnectType!)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Web View Delegates
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        let urlString:String = (request.url?.absoluteString)!
        
        if let rangeObj:Range = urlString.range(of: "external")
        {
            if !rangeObj.isEmpty
            {
                let seperatedStrings:Array = urlString.components(separatedBy: "/")
                if seperatedStrings.count > 0 {
                    let authKey:String = (seperatedStrings.last?.replacingOccurrences(of: "#_=_", with: ""))!
                    if !authKey.isEmpty {
                        let defaults = UserDefaults.standard
                        defaults.set(authKey, forKey: "authkey")
                        defaults.synchronize()
                    }
                    self.showHUD()
                    self.delegate?.didSocialLoginSuccessfully(sessionKey: authKey, connectType: self.socialConnectType!)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }else
        {
            if let errorRangeObj:Range = urlString.range(of: "error/message/")
            {
                if !errorRangeObj.isEmpty
                {
                    let seperatedStrings:Array = urlString.components(separatedBy: "/")
                    if seperatedStrings.count > 0 {
                        let authKey:String = (seperatedStrings.last?.replacingOccurrences(of: "#_=_", with: ""))!
                        let errorString:String = authKey.removingPercentEncoding!
                        self.showHUD()
                        self.delegate?.didSocialLoginFailed(errorString: errorString, connectType: self.socialConnectType!)
                        self.dismiss(animated: true, completion: nil)
                    }
                }else
                {
                    self.showHUD()
                    self.delegate?.didSocialLoginFailed(errorString: "", connectType: self.socialConnectType!)
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
        }
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.updateButtons()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.updateButtons()
        self.hideHUD()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        self.updateButtons()
        self.hideHUD()
    }
    
    func updateButtons()
    {
        self.pwdButton.isEnabled = webView.canGoForward;
        self.backButton.isEnabled = webView.canGoBack;
        self.stopButton.isEnabled = webView.isLoading;
    }
}
