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
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    @IBAction func actionGetUserLocation(_ sender: AnyObject) {
    }
    
    //MARK:- Utility Methods
    
    func isValid() -> Bool {
        
        var flag:Bool = true
        
        if (self.isEmptySting(self.txtUsername.text!))
        {
            self.showAlert(title: kError, message: kEnterUsername, tag: 0)
           flag = false
        }else if(self.isEmptySting(self.txtDisplayname.text!))
        {
            self.showAlert(title: kError, message: kEnterDisplayname, tag: 0)
            flag = false
        }else if(self.isEmptySting(self.txtPassword.text!))
        {
            self.showAlert(title: kError, message: kEnterPassword, tag: 0)
            flag = false
        }else if(!CommonSetting.sharedInstance.validatePassword(password: self.txtPassword.text!))
        {
            self.showAlert(title: kError, message: kPasswordRulesMessage, tag: 0)
            flag = false
        }else if(self.isEmptySting(self.txtConfirmPassword.text!))
        {
            self.showAlert(title: kError, message: kEnterConfirmPassword, tag: 0)
            flag = false
        }else if(self.txtPassword.text != self.txtConfirmPassword.text)
        {
            self.showAlert(title: kError, message: kEnterSamePassword, tag: 0)
            flag = false
        }else if(self.isEmptySting(self.txtEmailId.text!))
        {
            self.showAlert(title: kError, message: kEnterEmail, tag: 0)
            flag = false
        }else if(!CommonSetting.sharedInstance.validateEmailID(emailID: self.txtEmailId.text!))
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
