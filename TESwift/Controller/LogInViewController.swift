//
//  LogInViewController.swift
//  TESwift
//
//  Created by Apple on 09/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit


<<<<<<< HEAD
class LogInViewController: BaseViewController  {
=======
class LogInViewController: BaseViewController , UITextFieldDelegate {
>>>>>>> 6cb238485efd6d5a7b9d4f4d4e22027efc1dc64f

    @IBOutlet weak var txtUsernameTop: NSLayoutConstraint!
    @IBOutlet weak var socialConnectHieght: NSLayoutConstraint!
    @IBOutlet weak var socialConnectWidth: NSLayoutConstraint!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
   
    @IBOutlet weak var viewForLogin: UIView!
    @IBOutlet var viewForArrow: UIView!
    
    @IBOutlet weak var viewForSocial: UIView!
   
    var signupViewController = SignUpViewController()
    
    @IBAction func actionOnSignup(_ sender: AnyObject) {
        
        // Instantiate SecondViewController
         signupViewController = self.storyboard?.instantiateViewController(withIdentifier: "signupViewController") as! SignUpViewController
        
        
        // Take user to SecondViewController
        self.navigationController?.pushViewController(signupViewController, animated: true)
        
    }
    
<<<<<<< HEAD
=======
    @IBAction func loginAction(_ sender: AnyObject) {
    }
   
    
>>>>>>> 6cb238485efd6d5a7b9d4f4d4e22027efc1dc64f
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPassword.tag = 1;
        self.addDismisskeyboardTapGesture()
        self.styleGuide()

        // Do any additional setup after loading the view.
    }

    
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

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: AnyObject) {
        
        if self.validate() {
            
            let userInfo:NSMutableDictionary = ["username" : txtUsername.text! as String, "password" : txtPassword.text! as String]
            
            self.getUserLogin(userInfo)
        }
    }

    func validate() -> Bool {
        
        if self.isEmptySting(txtUsername.text!) || self.isEmptySting(txtPassword.text!) {
            
            
            self.showAlert("Message", "Username or password either null or consist blanks.", 100)
            
            return false
        }
        
        return true
    }
    
    func getUserLogin(_ userInfo: NSMutableDictionary) -> Void {
        
    
        ServiceCall.sharedInstance.sendRequest(parameters: userInfo, urlType: RequestedUrlType.GetUserLogin, method: "GET", successCall: (serviceCallOnSuccess(NSDictionary?, _callType: RequestedUrlType)), falureCall: (serviceCallOnFailure(String?, RequestedUrlType)))
        
        }
    
    //MARK: -Service Call response ---
    
    func serviceCallOnSuccess(_ data: NSDictionary, _callType: RequestedUrlType) -> Void {
        
    }
    
    func serviceCallOnFailure(_ data: String, _callType: RequestedUrlType) -> Void {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
