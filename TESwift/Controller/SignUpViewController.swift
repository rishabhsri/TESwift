//
//  SignUpViewController.swift
//  TESwift
//
//  Created by V Group Inc. on 12/9/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtDisplayname: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtEmailId: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var profilePicBtn: UIButton!
    
    var isImageAdded = false
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var socialConnectWidth: NSLayoutConstraint!
    @IBOutlet weak var viewForSocial: UIView!
    @IBOutlet weak var viewForSignUp: UIView!
    @IBOutlet weak var viewForLogin: UIView!
   
    @IBOutlet weak var socialConnectHieght: NSLayoutConstraint!
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add Dismiss Keyboard Tap Gesture
        self.addDismisskeyboardTapGesture()
        
        // Set Style Guide
        self.styleGuide()

        //setup picker
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Utility Methods
    func styleGuide()->Void {
        
        txtUsername.attributedPlaceholder = NSAttributedString(string:"Username",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        txtDisplayname.attributedPlaceholder = NSAttributedString(string:"Display Name",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        txtPassword.attributedPlaceholder = NSAttributedString(string:"Password",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        txtConfirmPassword.attributedPlaceholder = NSAttributedString(string:"Confirm Password",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        txtEmailId.attributedPlaceholder = NSAttributedString(string:"Email-ID",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        txtLocation.attributedPlaceholder = NSAttributedString(string:"Location",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        if (IS_IPHONE_5) {
            self.socialConnectHieght.constant = 40
            self.socialConnectWidth.constant = 40
           
        }
    }
    
    
    //MARK:- IBAction Methods
    
    @IBAction func actionOnSignUpBtn(_ sender: AnyObject) {
        
        if self.isValid() {
            print("everything is fine!!")
            if isImageAdded {
                self.uploadImage()
            }else
            {
               // self.getUserSignup(<#T##userInfo: NSMutableDictionary##NSMutableDictionary#>)
            }
        }
    }
    
    @IBAction func actionOnProfilePicBtn(_ sender: AnyObject)
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func actionOnUpArrow(_ sender: AnyObject) {
        
        self.viewForLogin.isHidden = false
        self.viewForSocial.isHidden = true
        self.viewForSignUp.isHidden = true
        
    }
    @IBAction func actionOnCloseBtn(_ sender: AnyObject) {
        self.viewForLogin.isHidden = true
        self.viewForSocial.isHidden = false
        self.viewForSignUp.isHidden = false
    }
    
    @IBAction func actionGetUserLocation(_ sender: AnyObject) {
    }
    
    @IBAction func actionOnLoginBtn(_ sender: AnyObject) {
      _ = self.navigationController?.popViewController(animated: true)
        
    }
    //MARK:- Utility Methods
    
    func isValid() -> Bool {
        
        var flag:Bool = true
        
        if (commonSetting.isEmptySting(self.txtUsername.text!))
        {
            self.showAlert(title: kError, message: kEnterUsername, tag: 0)
           flag = false
        }else if(commonSetting.isEmptySting(self.txtDisplayname.text!))
        {
            self.showAlert(title: kError, message: kEnterDisplayname, tag: 0)
            flag = false
        }else if(commonSetting.isEmptySting(self.txtPassword.text!))
        {
            self.showAlert(title: kError, message: kEnterPassword, tag: 0)
            flag = false
        }else if(!commonSetting.validatePassword(password: self.txtPassword.text!))
        {
            self.showAlert(title: kError, message: kPasswordRulesMessage, tag: 0)
            flag = false
        }else if(commonSetting.isEmptySting(self.txtConfirmPassword.text!))
        {
            self.showAlert(title: kError, message: kEnterConfirmPassword, tag: 0)
            flag = false
        }else if(self.txtPassword.text != self.txtConfirmPassword.text)
        {
            self.showAlert(title: kError, message: kEnterSamePassword, tag: 0)
            flag = false
        }else if(commonSetting.isEmptySting(self.txtEmailId.text!))
        {
            self.showAlert(title: kError, message: kEnterEmail, tag: 0)
            flag = false
        }else if(!commonSetting.validateEmailID(emailID: self.txtEmailId.text!))
        {
            self.showAlert(title: kError, message: kInvalidEmail, tag: 0)
            flag = false
        }else if(self.txtLocation.text?.isEmpty)!
        {
            self.showAlert(title: kError, message: kEnterLocation, tag: 0)
            flag = false
        }
        return flag
    }
    
    func uploadImage() {
        
    }
    
    
    func getUserSignup(_ userInfo: NSMutableDictionary) -> Void {
        
        //On Success Call
        let success:successHandler = {responseObject,requestType in
            // Success call implementation
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            print(responseDict)
        }
        
        //On Falure Call
        let falure:falureHandler = {error,responseMessage,requestType in
            
            // Falure call implementation
            print(responseMessage)
        }
        
      //  ServiceCall.sharedInstance.sendRequest(parameters: userInfo, urlType: RequestedUrlType.GetUserLogin, method: "POST", successCall: success, falureCall: falure)
        
    }
    
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profilePicBtn.setBackgroundImage(pickedImage, for: UIControlState.normal)
            self.profilePicBtn.layer.cornerRadius = self.profilePicBtn.frame.size.height/2
            self.profilePicBtn.layer.masksToBounds = true;
            isImageAdded = true
        }
        
        dismiss(animated: true, completion: nil)
    }

    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
