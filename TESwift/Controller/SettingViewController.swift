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

class SettingViewController: SocialConnectViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate, UIPickerViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var userID = ""
    var msgSettingTag:Int = 0
    var noOfOFFMsgSettings = 0
    var profileImageKey = ""
    var teamIconImageKey = ""
    var heightAdj: Float = 0.0
    var linkAccountHeight: Float = 0.0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgTwitchConnected: UIImageView!
    @IBOutlet weak var imgGoogleConnected: UIImageView!
    @IBOutlet weak var imgTwitterConnected: UIImageView!
    @IBOutlet weak var imgFBConnected: UIImageView!
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
    var autoLocationList:NSArray = NSArray()
    var myProfile:TEMyProfile = TEMyProfile()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurePickerViewDta()
        
        self.styleGuide()
        
        self.setupMenu()
        
        self.updateSettingDetails()
        
        self.configureLocationTableView()
        
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
        if self.myProfile.showTeamIcon.hashValue == 1 {
            return true
        }
        return false
    }
    
    func updateSettingDetails()
    {
        let predicate = NSPredicate(format: "username == %@", (commonSetting.userLoginInfo.stringValueForKey(key: "username")))
        if  let profile:TEMyProfile = TEMyProfile.fetchMyProfileDetail(context: self.manageObjectContext(), predicate: predicate)
        {
            self.myProfile = profile
        }else{
            return
        }
        
        
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
        
        self.txtName.text = self.myProfile.name
        self.txtEmail.text = self.myProfile.emailid
        self.txtPhoneNumber.text = self.myProfile.phoneNumber
        self.txtLocation.text = self.myProfile.location
        
        self.userID = self.myProfile.userid!
        self.txtAge.text = String(format: "%d",self.myProfile.age)
        self.txtGender.text = self.myProfile.gender
        
        self.messagingSwitch.isOn = self.myProfile.messageSetting
        self.mailSwitch.isOn = self.myProfile.mailSetting
        
        
        if self.myProfile.messageSetting
        {
            self.switchFollow.isOn = self.myProfile.follow
            self.switchNotify_Followers.isOn = self.myProfile.notify_followers
            self.switchNotify_Approved_Player.isOn = self.myProfile.notify_approved_player
            self.switchNotify_Tournament_Players.isOn = self.myProfile.notify_topurnament_player
            self.switchNotify_Match_Admin.isOn = self.myProfile.notify_match_admin
            self.switchPlayer_Added_To_Tournament.isOn = self.myProfile.player_Added_to_tournament
            self.SwitchNotify_Match_Player.isOn = self.myProfile.notify_match_palyer
            self.switchTournament_Started.isOn = self.myProfile.tournament_started
            self.messagingCategoryView.isHidden = false
        }
        else{
            self.messagingCategoryView.isHidden = true
        }
        self.updateSubscriptionDetials()
        self.updateSocialConnection()
        self.setProfileImage(userInfo: commonSetting.userLoginInfo)
    }
    
    
    func setProfileImage(userInfo:NSDictionary) {
        
        let imagekey:String = userInfo.stringValueForKey(key: "imageKey")
        
        if !commonSetting.isEmptyStingOrWithBlankSpace(imagekey)
        {
            // For storing temporary imageKey for using in MenuViewController
            
            commonSetting.imageKeyProfile = imagekey
            //On Success Call
            let success:downloadImageSuccess = {image,imageKey in
                // Success call implementation
                
                self.profilePicButton.setImage(image, for: UIControlState.normal)
            }
            
            //On Falure Call
            let falure:downloadImageFailed = {error,responseMessage in
                
                // Falure call implementation
                
            }
            
            ServiceCall.sharedInstance.downloadImage(imageKey: imagekey, urlType: RequestedUrlType.DownloadImage, successCall: success, falureCall: falure)
        }
    }
    
    func updateSubscriptionDetials() -> Void {
        if (self.myProfile.subscriptionType) != nil {
            self.lblSubscriberValue.text = self.myProfile.subscriptionType?.capitalized
            self.btnSubscriber.setBackgroundImage(UIImage(named: "hype_completed")!,for: UIControlState.normal)
            
        }
        else{
            self.lblSubscriberValue.text = ""
            self.btnSubscriber.setBackgroundImage( UIImage(named: "hype_transparent_small")!, for: UIControlState.normal)
            
        }
    }
    
    
    //MARK:- IBAction Methods
    
    @IBAction func switchValuesChanged(_ sender: Any) {
        let settingSwitch = (sender as! UISwitch)
        msgSettingTag = settingSwitch.tag
        
        switch msgSettingTag {
            
        case SwitchType.MESSAGINGSWITCH.rawValue :
            
            if self.messagingSwitch.isOn {
                self.switchFollow.isOn = self.myProfile.follow
                self.switchNotify_Followers.isOn = self.myProfile.notify_followers
                self.switchNotify_Approved_Player.isOn = self.myProfile.notify_approved_player
                self.switchNotify_Tournament_Players.isOn = self.myProfile.notify_topurnament_player
                self.switchNotify_Match_Admin.isOn = self.myProfile.notify_match_admin
                self.switchPlayer_Added_To_Tournament.isOn = self.myProfile.player_Added_to_tournament
                self.SwitchNotify_Match_Player.isOn = self.myProfile.notify_match_palyer
                self.switchTournament_Started.isOn = self.myProfile.tournament_started
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
    
    func updateSocialConnection() -> Void {
        if let socailConnectFB:UserSocialDetail = TEMyProfile.fetchUserSocailDetails(for: self.myProfile, with: self.context!, socialType: "FACEBOOK")
        {
            commonSetting.isFBConnect = true
        }
        else{
            commonSetting.isFBConnect = false
        }
        
        if let socailConnectTwitter:UserSocialDetail = TEMyProfile.fetchUserSocailDetails(for: self.myProfile, with: self.context!, socialType: "TWITTER")
        {
            commonSetting.isTwitterConnect = true
        }
        else{
            commonSetting.isTwitterConnect = false
        }
        
        if let socailConnectGoogle:UserSocialDetail = TEMyProfile.fetchUserSocailDetails(for: self.myProfile, with: self.context!, socialType: "GOOGLEPLUS")
        {
            commonSetting.isGoogleConnect = true
        }
        else{
            commonSetting.isGoogleConnect = false
        }
        if let socailConnectTwitch:UserSocialDetail = TEMyProfile.fetchUserSocailDetails(for: self.myProfile, with: self.context!, socialType: "TWITCH")
        {
            commonSetting.isTwitchConnect = true
        }
        else{
            commonSetting.isTwitchConnect = false
        }
        
        // update selected images of social connect
        if commonSetting.isFBConnect {
            self.imgFBConnected.isHidden = false
        }
        else{
            self.imgFBConnected.isHidden = true
        }
        if commonSetting.isTwitterConnect {
            self.imgTwitterConnected.isHidden = false
        }
        else{
            self.imgTwitterConnected.isHidden = true
        }
        if commonSetting.isGoogleConnect {
            self.imgGoogleConnected.isHidden = false
        }
        else{
            self.imgGoogleConnected.isHidden = true
        }
        if commonSetting.isTwitchConnect {
            self.imgTwitchConnected.isHidden = false
        }
        else{
            self.imgTwitchConnected.isHidden = true
        }
    }
    
    @IBAction func getUserLocation(_ sender: AnyObject) {
        self.showHUD()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func btnDoneClicked(_ sender: AnyObject) {
        if isValid() {
            self.updateUserDetails()
        }
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
            userInfo.setValue(self.myProfile.imageKey, forKey: "imageKey")
        }
        
        if !(commonSetting.isEmptyStingOrWithBlankSpace(self.teamIconImageKey)) {
            userInfo.setValue(self.teamIconImageKey, forKey: "teamIcon")
        }
        else{
            userInfo.setValue(self.myProfile.teamIconUrl, forKey: "teamIcon")
        }
        
        userInfo.setValue(NSNumber.init(value: Int(self.userID)!), forKey: "userID")
        userInfo.setValue(NSNumber.init(value: self.mailSwitch.isOn), forKey: "mailSetting")
        userInfo.setValue(NSNumber.init(value: self.messagingSwitch.isOn), forKey: "messagingSetting")
        
        var arySettings:NSMutableArray = NSMutableArray()
        
        arySettings.add( NSDictionary.init(objects: [NSNumber.init(value: self.switchFollow.isOn),"FOLLOW"], forKeys: ["setting" as NSCopying,"type" as NSCopying]))
        arySettings.add( NSDictionary.init(objects: [NSNumber.init(value: self.switchNotify_Approved_Player.isOn),"NOTIFY_APPROVED_PLAYER"], forKeys: ["setting" as NSCopying,"type" as NSCopying]))
        
        arySettings.add( NSDictionary.init(objects: [NSNumber.init(value: self.switchNotify_Followers.isOn),"NOTIFY_FOLLOWERS"], forKeys: ["setting" as NSCopying,"type" as NSCopying]))
        
        arySettings.add( NSDictionary.init(objects: [NSNumber.init(value: self.switchNotify_Match_Admin.isOn),"NOTIFY_MATCH_ADMIN"], forKeys: ["setting" as NSCopying,"type" as NSCopying]))
        
        arySettings.add( NSDictionary.init(objects: [NSNumber.init(value: self.SwitchNotify_Match_Player.isOn),"NOTIFY_MATCH_PLAYER"], forKeys: ["setting" as NSCopying,"type" as NSCopying]))
        
        arySettings.add( NSDictionary.init(objects: [NSNumber.init(value: self.switchNotify_Tournament_Players.isOn),"NOTIFY_TOURNAMENT_PLAYERS"], forKeys: ["setting" as NSCopying,"type" as NSCopying]))
        
        arySettings.add( NSDictionary.init(objects: [NSNumber.init(value: self.switchPlayer_Added_To_Tournament.isOn),"PLAYER_ADDED_TO_TOURNAMENT"], forKeys: ["setting" as NSCopying,"type" as NSCopying]))
        
        arySettings.add( NSDictionary.init(objects: [NSNumber.init(value: self.switchTournament_Started.isOn),"TOURNAMENT_STARTED"], forKeys: ["setting" as NSCopying,"type" as NSCopying]))
        
        
        
        //               let dicReq = NSMutableDictionary.init(object: userInfo, forKey: "person" as NSCopying)
        let dicReq = NSMutableDictionary.init(objects: [userInfo,arySettings], forKeys: ["person" as NSCopying,"settings" as NSCopying])
        return  dicReq
    }
    
    func getUserDetails(_ userInfo: NSMutableDictionary) -> Void {
        
        //On Success Call
        let success:successHandler = {responseObject,requestType in
            // Success call implementation
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            
            self.showAlert(title: kMessage, message: "Profile updated successfully")
            print(responseDict)
        }
        
        //On Failure Call
        let falure:falureHandler = {error,responseMessage,requestType in
            
        }
        print(userInfo)
        ServiceCall.sharedInstance.sendRequest(parameters: userInfo, urlType: RequestedUrlType.UpdateUserProfile, method: "PUT", successCall: success, falureCall: falure)
        
    }
    
    @IBAction func socialConnectViaFacebook(_ sender: Any) {
        
        if !commonSetting.isInternetAvailable {
            self.showNoInternetAlert()
            return
        }
        if commonSetting.isFBConnect{
            
            let refreshAlert = UIAlertController(title: kMessage, message: kDisconnect, preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: kOK, style: .default, handler: { (action: UIAlertAction!) in
                
                commonSetting.isFBConnect = false
                self.imgFBConnected.isHidden = true
                let dicReq = NSMutableDictionary.init(object: "facebook", forKey: "socialType" as NSCopying)
                
                //                ServiceCall.sharedInstance.sendRequest(parameters: dicReq, urlType: RequestedUrlType.DisconnectSocialLogin, method: "POST", successCall: success, falureCall: falure)
                
            }))
            
            refreshAlert.addAction(UIAlertAction(title: kCancel, style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        }
        else{
            super.socialLoginViaFacebook(sender)
            
        }
    }
    @IBAction func socialConnectViaTwitter(_ sender: Any) {
        if !commonSetting.isInternetAvailable {
            self.showNoInternetAlert()
            return
        }
        if commonSetting.isTwitterConnect{
            
            let refreshAlert = UIAlertController(title: kMessage, message: kDisconnect, preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: kOK, style: .default, handler: { (action: UIAlertAction!) in
                
                commonSetting.isTwitterConnect = false
                self.imgTwitterConnected.isHidden = true
                
            }))
            
            refreshAlert.addAction(UIAlertAction(title: kCancel, style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        }
        else{
            super.socialLoginViaTwitter(sender)
        }
    }
    
    @IBAction func socialConnectViaGoogle(_ sender: Any) {
        if !commonSetting.isInternetAvailable {
            self.showNoInternetAlert()
            return
        }
        if commonSetting.isGoogleConnect{
            
            let refreshAlert = UIAlertController(title: kMessage, message: kDisconnect, preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: kOK, style: .default, handler: { (action: UIAlertAction!) in
                commonSetting.isGoogleConnect = false
                self.imgGoogleConnected.isHidden = true
            }))
            
            refreshAlert.addAction(UIAlertAction(title: kCancel, style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        }
        else{
            super.socialLoginViaGooglePlus(sender)        }
    }
    @IBAction func socialConnectViaTwitch(_ sender: Any) {
        
        if !commonSetting.isInternetAvailable {
            self.showNoInternetAlert()
            return
        }
        if commonSetting.isTwitchConnect{
            
            let refreshAlert = UIAlertController(title: kMessage, message: kDisconnect, preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: kOK, style: .default, handler: { (action: UIAlertAction!) in
                
                commonSetting.isTwitchConnect = false
                self.imgTwitchConnected.isHidden = true
            }))
            
            refreshAlert.addAction(UIAlertAction(title: kCancel, style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        }
        else{
            super.socialLoginViaTwitch(sender)
            
        }
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
    
    //MARK:- Social Login response
    override func onLogInSuccess(_ userInfo: NSDictionary,connectType:SocialConnectType) -> Void {
        self.hideHUD()
        
        if connectType == SocialConnectType.FACEBOOK {
            commonSetting.isFBConnect = true
            self.imgFBConnected.isHidden = false
        }
        else if connectType == SocialConnectType.TWITTER {
            commonSetting.isTwitterConnect = true
            self.imgTwitchConnected.isHidden = false
        }
        else if connectType == SocialConnectType.GOOGLEPLUS {
            commonSetting.isGoogleConnect = true
            self.imgGoogleConnected.isHidden = false
        }
        else if connectType == SocialConnectType.TWITCH {
            commonSetting.isTwitchConnect = true
            self.imgTwitchConnected.isHidden = false
        }
        
    }
    
    func onLogInFailure(_ userInfo: String) -> Void {
        self.hideHUD()
        self.showAlert(title: "Error", message: userInfo)
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
    
    
    //MARK:- Textfield delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    
    // became first responder
    func textFieldDidBeginEditing(_ textField: UITextField){
        addDismisskeyboardTapGesture()
        
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
        
        let length = txtName.text!.characters.count
        
        if textField == txtName && length >= 50 {
            return false
        }
            
        else if textField == txtEmail && (textField.text?.characters.count)! >= 150{
            return false
        }
        else if textField == txtLocation {
            self.perform(#selector(SettingViewController.textdidChange), with: self, afterDelay: 2.0)
        }
        
        return true
    }
    
    func textdidChange() -> Void {
        
        if txtLocation.text?.characters.count == 0{
            self.tableView.isHidden = true
            self.scrollView.isScrollEnabled = true
            self.addDismisskeyboardTapGesture()
        }
        if txtLocation.text!.characters.count > 2 {
            self.fetchAutocompleteLocation(keyword: self.txtLocation.text!)
            self.removeDismisskeyboardTapGesture()
            self.tableView.isHidden = false
            self.scrollView.isScrollEnabled = false
        }
    }
    
    
    // called when clear button pressed. return NO to ignore (no notifications)
    func textFieldShouldClear(_ textField: UITextField) -> Bool{
        return true
    }
    
    // called when 'return' key pressed. return NO to ignore.
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == txtName {
            txtEmail.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    //MARK:- Location search on location textfield method
    
    func fetchAutocompleteLocation(keyword: String) {
        
        let dicInfo = NSMutableDictionary()
        let str:String = keyword.replacingOccurrences(of: ",", with: "")
        dicInfo.setValue(str.replacingOccurrences(of: " ", with: ""), forKey: "locationText")
        
        let success:successHandler = {responseObject,requestType in
            // Success call implementation
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            print(responseDict)
            self.autoLocationList = responseDict["list"] as! NSArray
            //            var myNewName = NSMutableArray(array:self.autoLocationList)
            //            myNewName.removeAllObjects()
            
            self.tableView.reloadData()
            
        }
        
        //On Failure Call
        let failure:falureHandler = {error,responseMessage,requestType in
            
            // Falure call implementation
            print(responseMessage)
        }
        
        ServiceCall.sharedInstance.sendRequest(parameters: dicInfo, urlType: RequestedUrlType.GetUnAuthSearchedLocation, method: "GET", successCall: success, falureCall: failure)
        
    }
    
    
    //MARK:- TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return autoLocationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dict:NSDictionary =  self.autoLocationList.object(at: indexPath.row) as! NSDictionary
        
        //        let index = indexPath.row as Int
        cell.textLabel!.textColor = UIColor.white
        cell.textLabel!.text = dict.stringValueForKey(key: "formatted_address")
        // Returning the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!
        txtLocation.text = selectedCell.textLabel!.text!
        self.tableView.isHidden = true
        self.scrollView.isScrollEnabled = true
        self.addDismisskeyboardTapGesture()
    }
    
    
    
    func configureLocationTableView ()
    {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.black
        self.tableView.layer.cornerRadius = 5.0
    }
}
