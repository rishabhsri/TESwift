//
//  SettingViewController.swift
//  TESwift
//
//  Created by V Group Inc. on 12/22/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit
import CoreLocation

enum SwitchType : Int {
    case MAILSWITCH = 0
    case MESSAGINGSWITCH
    case LOCATIONSWITCH
}

class SettingViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate, UIPickerViewDelegate,UITextFieldDelegate {
    
     var userID = ""
     var msgSettingTag:Int = 0
     var noOfOFFMsgSettings = 0
     var profileImageKey = ""
     var teamIconImageKey = ""
     var heightAdj: Float = 0.0
     var linkAccountHeight: Float = 0.0
    
    @IBOutlet weak var lblNotifySettingTop: NSLayoutConstraint!
    @IBOutlet weak var lblBrainTreeTop: NSLayoutConstraint!
    @IBOutlet weak var messagingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnSubscriber: UIButton!
    @IBOutlet weak var lblSubscriberValue: UILabel!
    @IBOutlet weak var notifySettingYConstant: NSLayoutConstraint!
    @IBOutlet weak var lblNotificationSetting: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var lblNotifySettingTitle: UILabel!
    @IBOutlet weak var lblSocialConnectTitle: UILabel!
    @IBOutlet weak var lblTeamPicture: UILabel!
    @IBOutlet weak var btnTeamPicture: UIButton!
    @IBOutlet weak var lblTeamPicturetitle: UILabel!
    @IBOutlet weak var lblBrainTreeAccTitle: UIButton!
    @IBOutlet weak var lblSubscriber: UILabel!
    @IBOutlet weak var lblTermsConditionTitle: UIButton!
    @IBOutlet weak var lblPrivacyPolicyTitle: UIButton!
    @IBOutlet weak var profilePicButton: UIButton!
    
    
    
    @IBOutlet weak var mailSwitch: UISwitch!
    @IBOutlet weak var messagingSwitch: UISwitch!
    @IBOutlet weak var switchFollow: UISwitch!
    @IBOutlet weak var switchNotify_Approved_Player: UISwitch!
    @IBOutlet weak var switchNotify_Followers: UISwitch!
    @IBOutlet weak var switchNotify_Match_Admin: UISwitch!
    @IBOutlet weak var SwitchNotify_Match_Player: UISwitch!
    @IBOutlet weak var switchNotify_Tournament_Players: UISwitch!
    @IBOutlet weak var switchPlayer_Added_To_Tournament: UISwitch!
    @IBOutlet weak var switchTournament_Started: UISwitch!
   
    @IBOutlet weak var messagingCategoryView: UIView!
    
    @IBOutlet weak var ContainerViewHieght: NSLayoutConstraint!
    
    
    var activeTextField = UITextField()
    let imagePicker = UIImagePickerController()
    var locationManager = CLLocationManager()
    var aryAge:NSMutableArray = NSMutableArray()
    var aryGender:NSMutableArray = NSMutableArray()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePickerViewDta()
       
        self.styleGuide()
        
        self.setupMenu()
        
        self.updateSettingDetails()
        self.linkAccountHeight = 0.0
        self.configurePickerView()
            //Add Dismiss Keyboard Tap Gesture
        self.addDismisskeyboardTapGesture()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    //MARK:- Utility Methods
    func styleGuide()->Void {
        
        self.txtName.attributedPlaceholder = NSAttributedString(string:"Name",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        self.txtEmail.attributedPlaceholder = NSAttributedString(string:"EmailID",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        self.txtPhoneNumber.attributedPlaceholder = NSAttributedString(string:"Phone Number",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        self.txtAge.attributedPlaceholder = NSAttributedString(string:"Age",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        self.txtGender.attributedPlaceholder = NSAttributedString(string:"Gender",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        self.txtLocation.attributedPlaceholder = NSAttributedString(string:"Enter location Manually",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        
        self.lblNotifySettingTitle.textColor = StyleGuide.labelBlueColor()
        self.lblSocialConnectTitle.textColor = StyleGuide.labelBlueColor()
        self.lblTeamPicturetitle.textColor = StyleGuide.labelBlueColor()
        self.lblSubscriber.textColor = StyleGuide.labelBlueColor()
        
    }
    
    func isValid() -> Bool {
        
        var flag:Bool = true
        
        if (self.txtName.text!.isEmpty)
        {
            self.showAlert(title: kError, message: kEnterUsername)
            flag = false
        }else if(commonSetting.isEmptyStingOrWithBlankSpace(self.txtEmail.text!))
        {
            self.showAlert(title: kError, message: kEnterEmail)
            flag = false
        }else if(!commonSetting.validateEmailID(emailID: self.txtEmail.text!))
        {
            self.showAlert(title: kError, message: kInvalidEmail)
            flag = false
        }else if(!commonSetting.validateNumber(self.txtPhoneNumber.text!))
        {
            self.showAlert(title: kError, message: kEnterValidAge)
            flag = false
        }else if !(self.txtGender.text == "M") || (self.txtGender.text == "F")
        {
            self.showAlert(title: kError, message: kEnterValidsGender)
            flag = false

        }else if(self.txtLocation.text?.isEmpty)!
        {
            self.showAlert(title: kError, message: kEnterLocation)
            flag = false
        }

        return flag
    }
    
    func isCasualSubscriber() -> Bool {
        if commonSetting.myProfile.showTeamIcon.hashValue == 1 {
            return true
        }
        return false
    }
    
    func updateSettingDetails()  {
        let predicate = NSPredicate(format: "username == %@", (commonSetting.userLoginInfo.stringValueForKey(key: "username")))
        commonSetting.myProfile = TEMyProfile.fetchMyProfileDetail(context: self.manageObjectContext(), predicate: predicate)
       
        if self.isCasualSubscriber(){
            self.lblTeamPicture.isHidden = false
            self.btnTeamPicture.isHidden = false
             self.lblNotifySettingTop.constant = 106
//            self.ContainerViewHieght.constant =  self.ContainerViewHieght.constant + 106
        }
        else{
            lblTeamPicture.isHidden = true
            btnTeamPicture.isHidden = true
            self.lblNotifySettingTop.constant = 0
            self.ContainerViewHieght.constant =  self.ContainerViewHieght.constant - 106
        }
        
        self.txtName.text = commonSetting.myProfile.name
        self.txtEmail.text = commonSetting.myProfile.emailid
        self.txtPhoneNumber.text = commonSetting.myProfile.phoneNumber
        self.txtLocation.text = commonSetting.myProfile.location
        
        self.userID = commonSetting.myProfile.userid!
        self.txtAge.text = String(format: "%d",commonSetting.myProfile.age)
        self.txtGender.text = commonSetting.myProfile.gender
        
        self.messagingSwitch.isOn = commonSetting.myProfile.messageSetting
        self.mailSwitch.isOn = commonSetting.myProfile.mailSetting
        
        if (commonSetting.myProfile.messageSetting) {
            self.switchFollow.isOn = commonSetting.myProfile.follow
            self.switchNotify_Followers.isOn = commonSetting.myProfile.notify_followers
            self.switchNotify_Approved_Player.isOn = commonSetting.myProfile.notify_approved_player
            self.switchNotify_Tournament_Players.isOn = commonSetting.myProfile.notify_topurnament_player
            self.switchNotify_Match_Admin.isOn = commonSetting.myProfile.notify_match_admin
            self.switchPlayer_Added_To_Tournament.isOn = commonSetting.myProfile.player_Added_to_tournament
            self.SwitchNotify_Match_Player.isOn = commonSetting.myProfile.notify_match_palyer
            self.switchTournament_Started.isOn = commonSetting.myProfile.tournament_started
            self.messagingCategoryView.isHidden = false
            
        }
        else{
            self.messagingCategoryView.isHidden = true
                
                
        }
        
        self.updateSubscriptionDetials()
        
    }
    
    
    func updateSubscriptionDetials() -> Void {

//        if (commonSetting.isEmptyStingOrWithBlankSpace(commonSetting.myProfile.subscriptionType!)) {
//            self.lblSubscriberValue.text = ""
//            self.btnSubscriber.setBackgroundImage( UIImage(named: "hype_transparent_small")!, for: UIControlState.normal)
//        }
//        else{
//            self.lblSubscriberValue.text = commonSetting.myProfile.subscriptionType?.capitalized
//           self.btnSubscriber.setBackgroundImage(UIImage(named: "hype_completed")!,for: UIControlState.normal)
//            
//        }
    }
    
    
    //MARK:- IBAction Methods
    
    @IBAction func switchValuesChanged(_ sender: Any) {
         let settingSwitch = (sender as! UISwitch)
         msgSettingTag = settingSwitch.tag
        
        switch msgSettingTag {
        
        case SwitchType.MESSAGINGSWITCH.rawValue :
            
            if self.messagingSwitch.isOn {
                self.switchFollow.isOn = commonSetting.myProfile.follow
                self.switchNotify_Followers.isOn = commonSetting.myProfile.notify_followers
                self.switchNotify_Approved_Player.isOn = commonSetting.myProfile.notify_approved_player
                self.switchNotify_Tournament_Players.isOn = commonSetting.myProfile.notify_topurnament_player
                self.switchNotify_Match_Admin.isOn = commonSetting.myProfile.notify_match_admin
                self.switchPlayer_Added_To_Tournament.isOn = commonSetting.myProfile.player_Added_to_tournament
                self.SwitchNotify_Match_Player.isOn = commonSetting.myProfile.notify_match_palyer
                self.switchTournament_Started.isOn = commonSetting.myProfile.tournament_started
                self.messagingCategoryView.isHidden = false
                self.ContainerViewHieght.constant = self.ContainerViewHieght.constant + 323
                 self.lblBrainTreeTop.constant = 70
  
            }
            else{
                self.switchFollow.isOn = false
                self.switchNotify_Followers.isOn = false
                self.switchNotify_Approved_Player.isOn = false
                self.switchNotify_Tournament_Players.isOn = false
                self.switchNotify_Match_Admin.isOn = false
                self.switchPlayer_Added_To_Tournament.isOn = false
                self.SwitchNotify_Match_Player.isOn = false
                self.switchTournament_Started.isOn = false
                self.messagingCategoryView.isHidden = true
                self.ContainerViewHieght.constant = self.ContainerViewHieght.constant - 323
                self.lblBrainTreeTop.constant = -270
            }
        break
        
        case SwitchType.MAILSWITCH.rawValue:
            break
            
        case SwitchType.LOCATIONSWITCH.rawValue:
            if settingSwitch.isOn {
                self.btnLocation.isEnabled = true
                self.txtLocation.isEnabled = true
            }
            else{
                self.btnLocation.isEnabled = false
                self.txtLocation.isEnabled = false
            }
          break
            
        default:
            break
        }

    }
    
//    func checksForMsgSettingSwitches() -> Void {
//        var noOfDisabledSwitches :NSInteger = 0
//        
//        for view :UIView in messagingCategoryView.subviews {
//            if view.isKind(of: UISwitch()) {
//               var setting = view as! UISwitch
//                if !(setting.isOn) {
//                    noOfDisabledSwitches += 1
//                }
//            }
//        }
//        
//    }
//
    @IBAction func getUserLocation(_ sender: AnyObject) {
        self.showHUD()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func btnDoneClicked(_ sender: AnyObject) {
        if isValid() {
            
            self.rightButtonClickAction()
            
        }
        
    }
    
   
    func rightButtonClickAction()  {
       
        self.updateUserDetails()
    }
   
    func updateUserDetails() ->Void  {
       
        self.getUserDetails(self.createUpdateProfileRequest() as! NSMutableDictionary)
    }
    
    func createUpdateProfileRequest()->NSDictionary {
        
        let userInfo = NSMutableDictionary()
        userInfo.setValue(self.txtPhoneNumber.text, forKey:"phoneNumber")
        userInfo.setValue(self.txtName.text, forKey:"name")
         userInfo.setValue(self.txtEmail.text, forKey:"email")
        if !(commonSetting.isEmptyStingOrWithBlankSpace(self.txtAge.text!))
        {
           userInfo.setValue(NSNumber.init(value: Int(self.txtAge.text!)!), forKey: "age")
        }
        if !(commonSetting.isEmptyStingOrWithBlankSpace(self.txtGender.text!)) {
            userInfo.setValue(self.txtGender.text, forKey: "sex")

        }
        if !(commonSetting.isEmptyStingOrWithBlankSpace(self.txtLocation.text!)) {
            userInfo.setValue(self.txtLocation.text, forKey: "location")
            
        }
        if !(commonSetting.isEmptyStingOrWithBlankSpace(self.profileImageKey)) {
            userInfo.setValue(self.profileImageKey, forKey: "imageKey")
        }
        else{
           userInfo.setValue(commonSetting.myProfile.imageKey, forKey: "imageKey")
        }
        
        if !(commonSetting.isEmptyStingOrWithBlankSpace(self.teamIconImageKey)) {
            userInfo.setValue(self.teamIconImageKey, forKey: "teamIcon")
        }
        else{
            userInfo.setValue(commonSetting.myProfile.teamIconUrl, forKey: "teamIcon")
        }
        
        userInfo.setValue(NSNumber.init(value: Int(self.userID)!), forKey: "userID")
        userInfo.setValue(NSNumber.init(value: self.mailSwitch.isOn), forKey: "mailSetting")
        userInfo.setValue(NSNumber.init(value: self.messagingSwitch.isOn), forKey: "messagingSetting")
        
       var arySettings:NSMutableArray = NSMutableArray()
    
       
                arySettings.add(NSDictionary.init(object: NSArray.init(object: (NSNumber.init(value: self.switchFollow.isOn))), forKey: "FOLLOW" as NSCopying))
        arySettings.add(NSDictionary.init(object: NSArray.init(object: (NSNumber.init(value: self.switchNotify_Approved_Player.isOn))), forKey: "NOTIFY_APPROVED_PLAYER" as NSCopying))
        arySettings.add(NSDictionary.init(object: NSArray.init(object: (NSNumber.init(value: self.switchNotify_Followers.isOn))), forKey: "NOTIFY_FOLLOWERS" as NSCopying))
        arySettings.add(NSDictionary.init(object: NSArray.init(object: (NSNumber.init(value: self.switchNotify_Match_Admin.isOn))), forKey: "NOTIFY_MATCH_ADMIN" as NSCopying))
         arySettings.add(NSDictionary.init(object: NSArray.init(object: (NSNumber.init(value: self.SwitchNotify_Match_Player.isOn))), forKey: "NOTIFY_MATCH_PLAYER" as NSCopying))
         arySettings.add(NSDictionary.init(object: NSArray.init(object: (NSNumber.init(value: self.switchNotify_Tournament_Players.isOn))), forKey: "NOTIFY_TOURNAMENT_PLAYERS" as NSCopying))
        arySettings.add(NSDictionary.init(object: NSArray.init(object: (NSNumber.init(value: self.switchPlayer_Added_To_Tournament.isOn))), forKey: "PLAYER_ADDED_TO_TOURNAMENT" as NSCopying))
        arySettings.add(NSDictionary.init(object: NSArray.init(object: (NSNumber.init(value: self.switchTournament_Started.isOn))), forKey: "TOURNAMENT_STARTED" as NSCopying))
        print(arySettings)
       
//       let dicReq = NSMutableDictionary.init(object: userInfo, forKey: "person" as NSCopying)
        let dicReq = NSMutableDictionary.init(objects: [userInfo,arySettings], forKeys: ["person" as NSCopying,"settings" as NSCopying])
       return  dicReq
    }
    
    func getUserDetails(_ userInfo: NSMutableDictionary) -> Void {
        
        //On Success Call
        let success:successHandler = {responseObject,requestType in
            // Success call implementation
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            print(responseDict)
        }
        
        //On Failure Call
        let falure:falureHandler = {error,responseMessage,requestType in
            
                   }
        print(userInfo)
        ServiceCall.sharedInstance.sendRequest(parameters: userInfo, urlType: RequestedUrlType.UpdateUserProfile, method: "PUT", successCall: success, falureCall: falure)
        
    }

    
    
    @IBAction func actionOnProfilePic(_ sender: Any) {
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

    
    // MARK:- CLLocation button Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let userLocation : CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation, completionHandler: {(placemarks, error)->Void in
            
            var placemark:CLPlacemark!
            
            if error == nil && (placemarks?.count)! > 0 {
                placemark = (placemarks?[0])! as CLPlacemark
                
                var addressString : String = ""
                
                if placemark.isoCountryCode == "TW" {
                    if placemark.country != nil {
                        addressString = placemark.country!
                    }
                    
                    if placemark.locality != nil {
                        addressString = addressString + placemark.locality!
                    }
                    
                } else {
                    if placemark.locality != nil {
                        addressString = addressString + placemark.locality! + ", "
                    }
                    
                    if placemark.country != nil {
                        addressString = addressString + placemark.country!
                    }
                }
                print(addressString)
                self.txtLocation.text = addressString
                self.hideHUD()
            }
            
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error while updating location " + error.localizedDescription)
    }
    
    // MARK:- Picker View Methods
    
    func configurePickerView() {
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        self.txtAge.inputView = pickerView
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width:self.view.frame.size.width, height: 40))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(SettingViewController.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([flexSpace,flexSpace,doneButton], animated: true)
        
        self.txtAge.inputAccessoryView = toolBar

    }
    
    func configurePickerViewDta()
    {
       
       self.aryAge = NSMutableArray()
       for i in 10..<100 {
        self.aryAge.add(String(format: "%d",i))
      }
  }
    
    func donePressed(sender: UIBarButtonItem) {
        
        self.txtAge.resignFirstResponder()
        
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        
        self.txtAge.text = "10"
        
     self.txtAge.resignFirstResponder()
    }
    
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.aryAge.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let title: String = self.aryAge.object(at: row) as! String
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtAge.text = self.aryAge.object(at: row) as? String

    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any])
    {
        if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.profilePicButton.setBackgroundImage(pickerImage, for: UIControlState.normal)
            self.profilePicButton.layer.cornerRadius = self.profilePicButton.frame.size.height/2
            self.profilePicButton.layer.masksToBounds = true;
//            isImageAdded = true
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }



}
