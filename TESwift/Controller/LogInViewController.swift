//
//  LogInViewController.swift
//  TESwift
//
//  Created by Apple on 09/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class LogInViewController: BaseViewController  {
    
    @IBOutlet weak var txtUsernameTop: NSLayoutConstraint!
    @IBOutlet weak var socialConnectHieght: NSLayoutConstraint!
    @IBOutlet weak var socialConnectWidth: NSLayoutConstraint!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewForLogin: UIView!
    @IBOutlet var viewForArrow: UIView!
    @IBOutlet weak var viewForSocial: UIView!
    
    var signupViewController = SignUpViewController()
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPassword.tag = 1;
        
        //Add Dismiss Keyboard Tap Gesture
        self.addDismisskeyboardTapGesture()
        
        // Set Style Guide
        self.styleGuide()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Utility Methods
    func styleGuide()->Void {
        
        txtUsername.attributedPlaceholder = NSAttributedString(string:"Username or Email-Id",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        txtPassword.attributedPlaceholder = NSAttributedString(string:"Password",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        if (IS_IPHONE_5) {
            self.socialConnectHieght.constant = 40
            self.socialConnectWidth.constant = 40
            self.txtUsernameTop.constant = 30
        }
    }
    
    func validate() -> Bool {
        
        if self.isEmptySting(txtUsername.text!) || self.isEmptySting(txtPassword.text!) {
    
            self.showAlert(title: "Message", message: "Username or password either null or consist blanks.", tag: 100)
            return false
        }
        
        return true
    }
    
    func getUserLogin(_ userInfo: NSMutableDictionary) -> Void {
        
        //On Success Call
        let success:successHandler = {responseObject,requestType in
            // Success call implementation
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            
            print(responseDict)
            
            if responseDict.value(forKey: "userID") != nil {
                self.onLogInSuccess(responseDict)
            }
        }
        
        //On Falure Call
        let falure:falureHandler = {error,responseMessage,requestType in
            
            // Falure call implementation
            
            print(responseMessage)
            self.onLogInFailure(responseMessage)
        }
        
        ServiceCall.sharedInstance.sendRequest(parameters: userInfo, urlType: RequestedUrlType.GetUserLogin, method: "POST", successCall: success, falureCall: falure)
        
    }
    
    func onLogInSuccess(_ userInfo: NSDictionary) -> Void {
        
        let storyBoard = UIStoryboard(name: "Storyboard", bundle: nil)
        let dbController = storyBoard.instantiateViewController(withIdentifier: "MyDashBoardViewController") as! MyDashBoardViewController
        dbController.userDataDict = userInfo
        self.navigationController?.pushViewController(dbController, animated:true)
    }
    
    func onLogInFailure(_ userInfo: String) -> Void {
        
       self.showAlert(title: "Error", message: userInfo, tag: 200)
    }

    
    //MARK:- IBAction Methods
    @IBAction func actionOnArrowUp(_ sender: AnyObject) {
        self.viewForArrow.isHidden = false
        self.viewForSocial.isHidden = true
        self.viewForLogin.isHidden = true
        
    }
    
    @IBAction func actionCloseSignUpViewBtn(_ sender: AnyObject) {
        self.viewForArrow.isHidden = true
        self.viewForSocial.isHidden = false
        self.viewForLogin.isHidden = false
        
    }

    @IBAction func loginAction(_ sender: AnyObject) {
        
        if self.validate() {
            
            let userInfo:NSMutableDictionary = ["username" : txtUsername.text! as String, "password" : txtPassword.text! as String]
            
            self.getUserLogin(userInfo)
        }
    }
    
    @IBAction func actionOnSignup(_ sender: AnyObject) {
        
        // Instantiate SecondViewController
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "signupViewController") as UIViewController
        
        // Take user to SecondViewController
        self.navigationController?.pushViewController(controller, animated: true)

        
    }
    
}
