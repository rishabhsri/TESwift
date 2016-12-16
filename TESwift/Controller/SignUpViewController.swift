//
//  SignUpViewController.swift
//  TESwift
//
//  Created by V Group Inc. on 12/9/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class SignUpViewController: SocialConnectViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtDisplayname: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtEmailId: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var profilePicBtn: UIButton!
    @IBOutlet weak var socialConnectWidth: NSLayoutConstraint!
    @IBOutlet weak var viewForSocial: UIView!
    @IBOutlet weak var viewForSignUp: UIView!
    @IBOutlet weak var viewForLogin: UIView!
    @IBOutlet weak var socialConnectHieght: NSLayoutConstraint!
    
    @IBOutlet weak var scrollData: UIScrollView!
    @IBOutlet weak var lblAlready: UILabel!
    var isImageAdded = false
    var activeField = UITextField()
    var textField = UITextField()
    let imagePicker = UIImagePickerController()
    
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
        
        lblAlready.textColor = UIColor (colorLiteralRed: 124.0/255.0, green: 198.0/255.0, blue: 228.0/255.0, alpha: 1.0)
        
        if DeviceType.IS_IPHONE_5
        {
            self.socialConnectHieght.constant = 40
            self.socialConnectWidth.constant = 40
            
        }
    }
    
    func getUserSignup(_ userInfo: NSMutableDictionary) -> Void {
        
        //On Success Call
        let success:successHandler = {responseObject,requestType in
            // Success call implementation
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            print(responseDict)
        }
        
        //On Failure Call
        let failure:falureHandler = {error,responseMessage,requestType in
            
            // Falure call implementation
            print(responseMessage)
        }
         ServiceCall.sharedInstance.sendRequest(parameters: userInfo, urlType: RequestedUrlType.GetUserSignUp, method: "POST", successCall: success, falureCall: failure)
        
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func actionOnSignUpBtn(_ sender: AnyObject) {
        self.uploadImage()
        if self.isValid() {
            print("everything is fine!!")
            if isImageAdded {
                self.uploadImage()
            }else
            {
                let userInfo = NSMutableDictionary()
                userInfo.setObject("", forKey:"country" as NSCopying)
                userInfo.setObject("", forKey:"phoneNumber" as NSCopying)
                userInfo.setObject("", forKey: "city" as NSCopying)
                userInfo.setObject("", forKey: "imageKey" as NSCopying)
                userInfo.setObject("", forKey: "state" as NSCopying)
                userInfo.setObject("",forKey:"location" as NSCopying)
                
                userInfo.setObject(self.txtUsername.text!, forKey: "username" as NSCopying)
                userInfo.setObject(self.txtDisplayname.text!, forKey: "name" as NSCopying)
                userInfo.setObject(self.txtPassword.text!, forKey: "password" as NSCopying)
                userInfo.setObject(self.txtEmailId.text!, forKey: "email" as NSCopying)
                userInfo.setObject(self.txtLocation.text!, forKey: "location" as NSCopying)
                
                self.getUserSignup(userInfo )
            }
        }
    }
    
    @IBAction func actionOnProfilePicBtn(_ sender: AnyObject)
    {
           let optionMenu = UIAlertController(title: nil, message: "Add Photo", preferredStyle: .actionSheet)
            
            let addAction = UIAlertAction(title: "Take a photo", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
                {
                    self.imagePicker.delegate=self;
                    self.imagePicker.allowsEditing = true
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    self.present(self.imagePicker, animated: true, completion: nil)
                }else
                {
                    let alert = UIAlertController(title: "Message", message: kCameraNotAvailableMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
            
            let takeAction = UIAlertAction(title: "Choose from gallery", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                self.imagePicker.delegate=self;
                self.imagePicker.allowsEditing = true
                
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                optionMenu.dismiss(animated: true, completion: nil)
            })
            
            optionMenu.addAction(addAction)
            optionMenu.addAction(takeAction)
            optionMenu.addAction(cancelAction)
            
            self.present(optionMenu, animated: true, completion: nil)
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
        
        let success:uploadImageSuccess = {imageKey in
            // Success call implementation
            print(imageKey)
        }
        
        //On Falure Call
        let falure:uploadImageFailed = {error,responseMessage in
            
            // Falure call implementation
            print(responseMessage)
        }
        
          ServiceCall.sharedInstance.uploadImage(image: self.profilePicBtn.currentBackgroundImage, urlType: RequestedUrlType.UploadImage, successCall: success, falureCall: falure)
        
    }
        
    override func onLogInSuccess(_ userInfo: NSDictionary) -> Void {
        
        commonSetting.userLoginInfo = userInfo
        self.hideHUD()
        let storyBoard = UIStoryboard(name: "Storyboard", bundle: nil)
        let dbController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewControllerID") as! SWRevealViewController
        self.navigationController?.pushViewController(dbController, animated:true)
    }
    func onLogInFailure(_ userInfo: String) -> Void {
        self.hideHUD()
        self.showAlert(title: "Error", message: userInfo, tag: 200)
    }
    

    
   //MARK:- Textfield delegate
    
    //MARK:- Textfield delegate
    
    
    // return NO to disallow editing.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    
    // became first responder
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        addDismisskeyboardTapGesture()
        
        if IS_IPAD {
            
            if (textField == txtPassword || textField == txtConfirmPassword){
                let scrollPoint = CGPoint(x: CGFloat(0), y: CGFloat(391 - 300))
                self.scrollData.contentSize = CGSize(width: 320, height: 600)
                self.scrollData.setContentOffset(scrollPoint, animated: true)
            }
            else if(textField == txtEmailId || textField == txtLocation){
                let scrollPoint = CGPoint(x: CGFloat(0), y: CGFloat(391 - 250))
                self.scrollData.contentSize = CGSize(width: 320, height: 600)
                self.scrollData.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    func textFieldDidEndEditing(_ textField: UITextField){
        
    }
    
    // return NO to not change text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let length = txtUsername.text!.characters.count
        
        if textField == txtUsername && length >= 50 {
            return false
        }
        else if textField == txtDisplayname && (textField.text!.characters.count) >= 50 {
            return false
        }
        else if textField == txtEmailId && (textField.text?.characters.count)! >= 150{
            return false
        }
        else if (textField == txtPassword || textField == txtConfirmPassword) && (textField.text?.characters.count)! >= 50{
            return false
        }
        
        return true
    }
    
    // called when clear button pressed. return NO to ignore (no notifications)
    func textFieldShouldClear(_ textField: UITextField) -> Bool{
        return true
    }
    
    // called when 'return' key pressed. return NO to ignore.
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == txtUsername {
            txtDisplayname.becomeFirstResponder()
        }
        else if textField == txtDisplayname {
            txtPassword.becomeFirstResponder()
        }
        else if textField == txtPassword {
            
            txtConfirmPassword.becomeFirstResponder()
        }
        else if textField == txtConfirmPassword {
            txtEmailId.becomeFirstResponder()
        }
        else if textField == txtEmailId{
            txtLocation.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK:- Keyboard add and Remove Notification
    
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
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profilePicBtn.setBackgroundImage(pickedImage, for: UIControlState.normal)
            self.profilePicBtn.layer.cornerRadius = self.profilePicBtn.frame.size.height/2
            self.profilePicBtn.layer.masksToBounds = true;
            isImageAdded = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
