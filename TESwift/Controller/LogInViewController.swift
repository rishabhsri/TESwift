//
//  LogInViewController.swift
//  TESwift
//
//  Created by Apple on 09/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class LogInViewController: SocialConnectViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtUsernameTop: NSLayoutConstraint!
    @IBOutlet weak var socialConnectHieght: NSLayoutConstraint!
    @IBOutlet weak var socialConnectWidth: NSLayoutConstraint!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewForLogin: UIView!
    @IBOutlet var viewForArrow: UIView!
    @IBOutlet weak var viewForSocial: UIView!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var userGuest: UIButton!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var newLbl: UILabel!
    @IBOutlet weak var scrollData: UIScrollView!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.deregisterFromKeyboardNotifications()
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
        newLbl.textColor = UIColor (colorLiteralRed: 124.0/255.0, green: 198.0/255.0, blue: 228.0/255.0, alpha: 1.0)
        
        if (IS_IPHONE_5) {
            self.socialConnectHieght.constant = 40
            self.socialConnectWidth.constant = 40
            self.txtUsernameTop.constant = 30
        }
    }
    
    func validate() -> Bool {
        
        if commonSetting.isEmptySting(txtUsername.text!) || commonSetting.isEmptySting(txtPassword.text!) {
            
            self.showAlert(title: "Message", message: "Username or password either null or consist blanks.", tag: 100)
            return false
        }
        
        return true
    }
    
    func getUserLogin(_ userInfo: NSMutableDictionary) -> Void {
        
        //On Success Call
        let success:successHandler = {responseObject,requestType in
            
            self.hideHUD()
            // Success call implementation
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            
            print(responseDict)
            
            if responseDict.value(forKey: "userID") != nil {
                self.onLogInSuccess(responseDict)
            }
        }
        
        //On Falure Call
        let falure:falureHandler = {error,responseMessage,requestType in
            self.hideHUD()
            // Falure call implementation
            
            print(responseMessage)
            self.onLogInFailure(responseMessage)
        }
        
        self.showHUD()
        ServiceCall.sharedInstance.sendRequest(parameters: userInfo, urlType: RequestedUrlType.GetUserLogin, method: "POST", successCall: success, falureCall: falure)
        
    }
    
    override func onLogInSuccess(_ userInfo: NSDictionary) -> Void {
        
        commonSetting.userLoginInfo = userInfo
        
        let storyBoard = UIStoryboard(name: "Storyboard", bundle: nil)
        let dbController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewControllerID") as! SWRevealViewController
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
        
        self.viewForArrow.isHidden = true
        self.viewForLogin.isHidden = false
        self.viewForSocial.isHidden = false
        
        // Instantiate SecondViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "signupViewController") as UIViewController
        
        // Take user to SecondViewController
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    //MARK:- Textfield delegate
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == txtUsername {
            txtPassword.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    // return NO to disallow editing.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    // became first responder
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        addDismisskeyboardTapGesture()
        
        if IS_IPAD {
            if (textField == txtUsername){
                let scrollPoint = CGPoint(x: CGFloat(0), y: CGFloat(255 - 200))
                self.scrollData.contentSize = CGSize(width: 320, height: 600)
                self.scrollData.setContentOffset(scrollPoint, animated: true)
            }
            else if(textField == txtPassword){
                let scrollPoint = CGPoint(x: CGFloat(0), y: CGFloat(255 - 200))
                self.scrollData.contentSize = CGSize(width: 320, height: 600)
                self.scrollData.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    //Mark:- Keyboard add and Remove Notification
    
    func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(_ aNotification: Notification){
        
    }
    
    func keyboardWillBeHidden(_ aNotification: Notification) {
        if IS_IPAD {
            self.scrollData.contentSize = CGSize(width: CGFloat(320), height: CGFloat(400))
            self.scrollData.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}
