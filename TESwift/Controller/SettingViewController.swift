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

class SettingViewController: SocialConnectViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate, UIPickerViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate {

    @IBOutlet weak var brainTreeTopIpad: NSLayoutConstraint!
    @IBOutlet weak var messageViewHieghtIpad: NSLayoutConstraint!
    @IBOutlet weak var widthTeamPic: NSLayoutConstraint!
    @IBOutlet weak var hieghtTeamPic: NSLayoutConstraint!
    @IBOutlet weak var widthFbBtn: NSLayoutConstraint!
    @IBOutlet weak var hieghtFbBtn: NSLayoutConstraint!
    var userID:String = ""
    var msgSettingTag:Int = 0
    var noOfOFFMsgSettings = 0
    var profileImageKey = ""
    var teamIconImageKey = ""
    var heightMessageViewValue: CGFloat? = 0
    var heightMessageViewValueOfIpad: CGFloat?
    var linkAccountHeight: Float = 0.0
    var isImagedPicked = false
    var didEmailChanged = false
    var noOfMsgSetting :NSInteger = 0
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
    
    var popover:UIPopoverController?=nil
    var pickerView = UIPickerView()
    var activeTextField = UITextField()
    let imagePicker = UIImagePickerController()
    var locationManager = CLLocationManager()
    var aryAge:NSMutableArray = NSMutableArray()
    var aryGender:NSMutableArray = NSMutableArray()
    var autoLocationList:NSArray = NSArray()
    var myProfile:TEMyProfile?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.heightMessageViewValue = self.messagingViewHeight.constant
        self.heightMessageViewValueOfIpad = self.messageViewHieghtIpad.constant
       
        self.updateSettingDetails()
        
        self.configureLocationTableView()
        
        self.configurePickerView()
      
        if self.messagingSwitch.isOn == false {
            if IS_IPAD {
                self.messageViewHieghtIpad.constant = 0
                self.ContainerViewHieght.constant = self.ContainerViewHieght.constant - (self.heightMessageViewValueOfIpad)!
            }
            else{
                self.messagingCategoryView.isHidden = true
                self.messagingViewHeight.constant = 0
                self.ContainerViewHieght.constant = self.ContainerViewHieght.constant - (self.heightMessageViewValue)!
            }
        }
        print( self.ContainerViewHieght.constant)
        print(self.messagingViewHeight.constant)
        print(self.lblBrainTreeTop.constant)
        self.configurePickerViewData()
       
        self.styleGuide()
        
        self.setupMenu()
       
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
        
        if DeviceType.IS_IPHONE_5 && DeviceType.IS_IPHONE_4_OR_LESS {
            self.hieghtFbBtn.constant = 40
            self.widthFbBtn.constant = 40
            self.hieghtTeamPic.constant = 50
            self.widthTeamPic.constant = 50
        }
        
    }
    
    func isValid() -> Bool {
        
        var flag:Bool = true
        
        if (self.txtName.text!.isEmpty)
        {
            self.showAlert(title: kError, message: kEnterUsername)
            flag = false
        }else if(COMMON_SETTING.isEmptyStingOrWithBlankSpace(self.txtEmail.text!))
        {
            self.showAlert(title: kError, message: kEnterEmail)
            flag = false
        }else if(!COMMON_SETTING.validateEmailID(emailID: self.txtEmail.text!))
        {
            self.showAlert(title: kError, message: kInvalidEmail)
            flag = false
        }else if(!COMMON_SETTING.validateNumber(self.txtPhoneNumber.text!))
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
        if COMMON_SETTING.myProfile?.showTeamIcon.hashValue == 1 {
            return true
        }
        return false
    }
    
    func updateSettingDetails()
    {
        let predicate = NSPredicate(format: "username == %@", (COMMON_SETTING.userDetail?.userName)!)
        
        COMMON_SETTING.myProfile = TEMyProfile.fetchMyProfileDetail(context: self.manageObjectContext(), predicate: predicate)
        
        if self.isCasualSubscriber(){
            self.lblTeamPicture.isHidden = false
            self.btnTeamPicture.isHidden = false
            self.lblNotifySettingTop.constant =  IS_IPAD ? 116 : 106
            self.ContainerViewHieght.constant =  self.ContainerViewHieght.constant + 106
        }
        else{
            lblTeamPicture.isHidden = true
            btnTeamPicture.isHidden = true
            self.lblNotifySettingTop.constant = 0
            if IS_IPAD {
                self.ContainerViewHieght.constant =  self.ContainerViewHieght.constant - 116
            }
            else{
            self.ContainerViewHieght.constant =  self.ContainerViewHieght.constant - 106
        }
    }
        
        self.txtName.text = COMMON_SETTING.myProfile?.name
        self.txtEmail.text = COMMON_SETTING.myProfile?.emailid
        self.txtPhoneNumber.text = COMMON_SETTING.myProfile?.phoneNumber
        self.txtLocation.text = COMMON_SETTING.myProfile?.location
        
        self.userID = (COMMON_SETTING.myProfile?.userid)!
        self.txtAge.text = String(format: "%d",(COMMON_SETTING.myProfile?.age)!)
        self.txtGender.text = COMMON_SETTING.myProfile?.gender
        
        self.messagingSwitch.isOn = (COMMON_SETTING.myProfile?.messageSetting)!
        self.mailSwitch.isOn = (COMMON_SETTING.myProfile?.mailSetting)!
        
        
        if (COMMON_SETTING.myProfile?.messageSetting)!
        {
            self.switchFollow.isOn = (COMMON_SETTING.myProfile?.follow)!
            self.switchNotify_Followers.isOn = (COMMON_SETTING.myProfile?.notify_followers)!
            self.switchNotify_Approved_Player.isOn = (COMMON_SETTING.myProfile?.notify_approved_player)!
            self.switchNotify_Tournament_Players.isOn = (COMMON_SETTING.myProfile?.notify_topurnament_player)!
            self.switchNotify_Match_Admin.isOn = (COMMON_SETTING.myProfile?.notify_match_admin)!
            self.switchPlayer_Added_To_Tournament.isOn = (COMMON_SETTING.myProfile?.player_Added_to_tournament)!
            self.SwitchNotify_Match_Player.isOn = (COMMON_SETTING.myProfile?.notify_match_palyer)!
            self.switchTournament_Started.isOn = (COMMON_SETTING.myProfile?.tournament_started)!
            self.messagingCategoryView.isHidden = false
        }
        else{
            self.messagingCategoryView.isHidden = true
        }
        self.updateSubscriptionDetials()
        self.updateSocialConnection()
        self.setProfileImage()
    }
    
    
    func setProfileImage() {
        
        let imagekey:String = (COMMON_SETTING.myProfile?.imageKey)!
        
        if !COMMON_SETTING.isEmptyStingOrWithBlankSpace(imagekey)
        {
            //On Success Call
            let success:downloadImageSuccess = {image,imageKey in
                // Success call implementation
                self.setRoundImage(image: image, btnTag: self.profilePicButton.tag)
            }
            
            //On Falure Call
            let falure:downloadImageFailed = {error,responseMessage in
                // Falure call implementation
            }
            ServiceCall.sharedInstance.downloadImage(imageKey: imagekey, urlType: RequestedUrlType.DownloadImage, successCall: success, falureCall: falure)
        }
    }
    
    
    func setRoundImage(image: UIImage, btnTag: NSInteger) -> Void {
        let btn = self.view.viewWithTag(btnTag) as! UIButton
        btn.layoutIfNeeded()
        btn.setBackgroundImage(image, for: UIControlState.normal)
        btn.layer.cornerRadius = self.profilePicButton.frame.size.height/2
        btn.layer.masksToBounds = true
        
    }
    
    func updateSubscriptionDetials() -> Void {
        if (COMMON_SETTING.myProfile?.subscriptionType) != nil {
            self.lblSubscriberValue.text = COMMON_SETTING.myProfile?.subscriptionType?.capitalized
            self.btnSubscriber.setBackgroundImage(UIImage(named: "hype_completed")!,for: UIControlState.normal)
            
        }
        else{
            self.lblSubscriberValue.text = ""
            self.btnSubscriber.setBackgroundImage( UIImage(named: "hype_transparent_small")!, for: UIControlState.normal)
            
        }
    }
    
    // MARK: - Upload Image
    
    func uploadProfileImage() -> Void {
        
        let success:uploadImageSuccess = {imageKey in
            // Success call implementation
            print(imageKey)
            
            self.UpdateImage(imageKey: imageKey as NSString)
           
        }
        
        //On Falure Call
        let falure:uploadImageFailed = {error,responseMessage in
            
            // Falure call implementation
            print(responseMessage)
            self.UpdateImage(imageKey: "")
        }
        
        ServiceCall.sharedInstance.uploadImage(image: self.profilePicButton.currentBackgroundImage, urlType: RequestedUrlType.UploadImage, successCall: success, falureCall: falure)
    }
    
    func UpdateImage(imageKey : NSString) -> Void {
        self.hideHUD()
        if self.isImagedPicked {
            self.isImagedPicked = false
            self.profileImageKey = imageKey as String

            self.updateUserDetails()
        }
    
    }
    
    
    
    //MARK:- IBAction Methods
    
    @IBAction func switchValuesChanged(_ sender: Any) {
        
        let settingSwitch = (sender as! UISwitch)
        msgSettingTag = settingSwitch.tag
        switch msgSettingTag {
            
        case SwitchType.MESSAGINGSWITCH.rawValue :
            
            if self.messagingSwitch.isOn {
                
                self.switchFollow.isOn = (COMMON_SETTING.myProfile?.follow)!
                self.switchNotify_Followers.isOn = (COMMON_SETTING.myProfile?.notify_followers)!
                self.switchNotify_Approved_Player.isOn = (COMMON_SETTING.myProfile?.notify_approved_player)!
                self.switchNotify_Tournament_Players.isOn = (COMMON_SETTING.myProfile?.notify_topurnament_player)!
                self.switchNotify_Match_Admin.isOn = (COMMON_SETTING.myProfile?.notify_match_admin)!
                self.switchPlayer_Added_To_Tournament.isOn = (COMMON_SETTING.myProfile?.player_Added_to_tournament)!
                self.SwitchNotify_Match_Player.isOn = (COMMON_SETTING.myProfile?.notify_match_palyer)!
                self.switchTournament_Started.isOn = (COMMON_SETTING.myProfile?.tournament_started)!
                self.messagingCategoryView.isHidden = false
               
                if IS_IPAD {
                    self.messageViewHieghtIpad.constant = 172
                    self.ContainerViewHieght.constant = self.ContainerViewHieght.constant + (self.heightMessageViewValueOfIpad)!
                    
                    self.brainTreeTopIpad.constant = 18
                }
                else{
                self.messagingViewHeight.constant = 323
                self.ContainerViewHieght.constant = self.ContainerViewHieght.constant + (self.heightMessageViewValue)!
                
               self.lblBrainTreeTop.constant = 70
            }
        }
           else
            {
                self.switchFollow.isOn = false
                self.switchNotify_Followers.isOn = false
                self.switchNotify_Approved_Player.isOn = false
                self.switchNotify_Tournament_Players.isOn = false
                self.switchNotify_Match_Admin.isOn = false
                self.switchPlayer_Added_To_Tournament.isOn = false
                self.SwitchNotify_Match_Player.isOn = false
                self.switchTournament_Started.isOn = false
               
                self.messagingCategoryView.isHidden = true
                
                if IS_IPAD {
                    self.messageViewHieghtIpad.constant = 0
                    self.ContainerViewHieght.constant = self.ContainerViewHieght.constant - (self.heightMessageViewValueOfIpad)!
                    self.brainTreeTopIpad.constant = 18
                }
                else{
                self.messagingViewHeight.constant = 0
                self.ContainerViewHieght.constant = self.ContainerViewHieght.constant - (self.heightMessageViewValue)!
                self.lblBrainTreeTop.constant = 70
            }
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
    

    func updateSocialConnection() -> Void {
        if let socailConnectFB:UserSocialDetail = TEMyProfile.fetchUserSocailDetails(for: COMMON_SETTING.myProfile!, with: self.context!, socialType: "FACEBOOK")
        {
            COMMON_SETTING.isFBConnect = true
        }
        else{
            COMMON_SETTING.isFBConnect = false
        }
        
        if let socailConnectTwitter:UserSocialDetail = TEMyProfile.fetchUserSocailDetails(for: COMMON_SETTING.myProfile!, with: self.context!, socialType: "TWITTER")
        {
            COMMON_SETTING.isTwitterConnect = true
        }
        else{
            COMMON_SETTING.isTwitterConnect = false
        }
        
        if let socailConnectGoogle:UserSocialDetail = TEMyProfile.fetchUserSocailDetails(for: COMMON_SETTING.myProfile!, with: self.context!, socialType: "GOOGLEPLUS")
        {
            COMMON_SETTING.isGoogleConnect = true
        }
        else{
            COMMON_SETTING.isGoogleConnect = false
        }
        if let socailConnectTwitch:UserSocialDetail = TEMyProfile.fetchUserSocailDetails(for: COMMON_SETTING.myProfile!, with: self.context!, socialType: "TWITCH")
        {
            COMMON_SETTING.isTwitchConnect = true
        }
        else{
            COMMON_SETTING.isTwitchConnect = false
        }
        
        // update selected images of social connect
        if COMMON_SETTING.isFBConnect {
            self.imgFBConnected.isHidden = false
        }
        else{
            self.imgFBConnected.isHidden = true
        }
        if COMMON_SETTING.isTwitterConnect {
            self.imgTwitterConnected.isHidden = false
        }
        else{
            self.imgTwitterConnected.isHidden = true
        }
        if COMMON_SETTING.isGoogleConnect {
            self.imgGoogleConnected.isHidden = false
        }
        else{
            self.imgGoogleConnected.isHidden = true
        }
        if COMMON_SETTING.isTwitchConnect {
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
            if self.isImagedPicked {
             self.uploadProfileImage()
             self.showHUD()
            }
            else{
            self.updateUserDetails()
            }
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
        if !(COMMON_SETTING.isEmptyStingOrWithBlankSpace(self.txtAge.text!))
        {
            userInfo.setValue(NSNumber.init(value: Int(self.txtAge.text!)!), forKey: "age")
        }
        if !(COMMON_SETTING.isEmptyStingOrWithBlankSpace(self.txtGender.text!)) {
            userInfo.setValue(self.txtGender.text, forKey: "sex")
            
        }
        if !(COMMON_SETTING.isEmptyStingOrWithBlankSpace(self.txtLocation.text!)) {
            userInfo.setValue(self.txtLocation.text, forKey: "location")
            
        }
        if !(COMMON_SETTING.isEmptyStingOrWithBlankSpace(self.profileImageKey)) {
            userInfo.setValue(self.profileImageKey, forKey: "imageKey")
        }
        else{
            userInfo.setValue(COMMON_SETTING.myProfile?.imageKey, forKey: "imageKey")
        }
        
        if !(COMMON_SETTING.isEmptyStingOrWithBlankSpace(self.teamIconImageKey)) {
            userInfo.setValue(self.teamIconImageKey, forKey: "teamIcon")
        }
        else{
            userInfo.setValue(COMMON_SETTING.myProfile?.teamIconUrl, forKey: "teamIcon")
        }
        
        userInfo.setValue(NSNumber.init(value: Int(self.userID)!), forKey: "userID")
        userInfo.setValue(NSNumber.init(value: self.mailSwitch.isOn), forKey: "mailSetting")
        userInfo.setValue(NSNumber.init(value: self.messagingSwitch.isOn), forKey: "messagingSetting")
        
        
        if !(COMMON_SETTING.isEmptyStingOrWithBlankSpace(self.profileImageKey)) {

            userInfo.setValue(self.profileImageKey, forKey: "imageKey")
        }else{
            userInfo.setValue(COMMON_SETTING.myProfile?.imageKey, forKey: "imageKey")
        }
        
        let arySettings:NSMutableArray = NSMutableArray()
        
        arySettings.add( NSDictionary.init(objects: [NSNumber.init(value: self.switchFollow.isOn),"FOLLOW"], forKeys: ["setting" as NSCopying,"type" as NSCopying]))
        arySettings.add( NSDictionary.init(objects: [NSNumber.init(value: self.switchNotify_Approved_Player.isOn),"NOTIFY_APPROVED_PLAYER"], forKeys: ["setting" as NSCopying,"type" as NSCopying]))
        
       arySettings.add( NSDictionary.init(objects: [NSNumber.init(value: self.switchNotify_Followers.isOn),"NOTIFY_FOLLOWERS"], forKeys: ["setting" as NSCopying,"type" as NSCopying]))
        
        arySettings.add( NSDictionary.init(objects: [NSNumber.init(value: self.switchNotify_Match_Admin.isOn),"NOTIFY_MATCH_ADMIN"], forKeys: ["setting" as NSCopying,"type" as NSCopying]))
        
        arySettings.add( NSDictionary.init(objects: [NSNumber.init(value: self.SwitchNotify_Match_Player.isOn),"NOTIFY_MATCH_PLAYER"], forKeys: ["setting" as NSCopying,"type" as NSCopying]))
        
        arySettings.add( NSDictionary.init(objects: [NSNumber.init(value: self.switchNotify_Tournament_Players.isOn),"NOTIFY_TOURNAMENT_PLAYERS"], forKeys: ["setting" as NSCopying,"type" as NSCopying]))
        
        arySettings.add( NSDictionary.init(objects: [NSNumber.init(value: self.switchPlayer_Added_To_Tournament.isOn),"PLAYER_ADDED_TO_TOURNAMENT"], forKeys: ["setting" as NSCopying,"type" as NSCopying]))
        
        arySettings.add( NSDictionary.init(objects: [NSNumber.init(value: self.switchTournament_Started.isOn),"TOURNAMENT_STARTED"], forKeys: ["setting" as NSCopying,"type" as NSCopying]))
        
        //let dicReq = NSMutableDictionary.init(object: userInfo, forKey: "person" as NSCopying)
        let dicReq = NSMutableDictionary.init(objects: [userInfo,arySettings], forKeys: ["person" as NSCopying,"settings" as NSCopying])
        return  dicReq
    }
    
    func getUserDetails(_ userInfo: NSMutableDictionary) -> Void {
        
        //On Success Call
        let success:successHandler = {responseObject,requestType in
            // Success call implementation
            let responseDict = serviceCall.parseResponse(responseObject: responseObject as Any)
            if self.didEmailChanged {
                self.didEmailChanged = false
                self.showAlert(title: kMessage, message: "An email has been sent for email verfication.")
                
            }
            else{
            
            TEMyProfile.deleteAllFormMyProfile(context: self.manageObjectContext())
            let responseDict = serviceCall.parseResponse(responseObject: responseObject as Any)
            
            self.showAlert(title: kMessage, message: "Profile updated successfully")
            print(responseDict)
            }
            
            TEMyProfile.insertMyProfileDetail(myProfileInfo: responseDict, context: self.manageObjectContext(), isSocialResponse: true)
            
             self.updateSettingDetails()
            
        }
        
        //On Failure Call
        let falure:falureHandler = {error,responseMessage,requestType in
            self.showAlert(title: kMessage, message:responseMessage)
           
        }
        print(userInfo)
        ServiceCall.sharedInstance.sendRequest(parameters: userInfo, urlType: RequestedUrlType.UpdateUserProfile, method: "PUT", successCall: success, falureCall: falure)
        
    }
    
    @IBAction func socialConnectViaFacebook(_ sender: Any) {
        
        if !COMMON_SETTING.isInternetAvailable {
            self.showNoInternetAlert()
            return
        }
        if COMMON_SETTING.isFBConnect{
            
            let refreshAlert = UIAlertController(title: kMessage, message: kDisconnect, preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: kOK, style: .default, handler: { (action: UIAlertAction!) in
                
                COMMON_SETTING.isFBConnect = false
                self.imgFBConnected.isHidden = true
                let dicReq = NSMutableDictionary.init(object: "facebook", forKey: "socialType" as NSCopying)
                
                self.getSocialDisconnect(dicReq)
                
                
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
        if !COMMON_SETTING.isInternetAvailable {
            self.showNoInternetAlert()
            return
        }
        if COMMON_SETTING.isTwitterConnect{
            
            let refreshAlert = UIAlertController(title: kMessage, message: kDisconnect, preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: kOK, style: .default, handler: { (action: UIAlertAction!) in
                
                COMMON_SETTING.isTwitterConnect = false
                self.imgTwitterConnected.isHidden = true
                
                
                let dicReq = NSMutableDictionary.init(object: "twitter", forKey: "socialType" as NSCopying)
                
                self.getSocialDisconnect(dicReq)

                
                
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
        if !COMMON_SETTING.isInternetAvailable {
            self.showNoInternetAlert()
            return
        }
        if COMMON_SETTING.isGoogleConnect{
            
            let refreshAlert = UIAlertController(title: kMessage, message: kDisconnect, preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: kOK, style: .default, handler: { (action: UIAlertAction!) in
                COMMON_SETTING.isGoogleConnect = false
                self.imgGoogleConnected.isHidden = true
                
                let dicReq = NSMutableDictionary.init(object: "google", forKey: "socialType" as NSCopying)
                
                self.getSocialDisconnect(dicReq)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: kCancel, style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        }
        else{
            super.socialLoginViaGooglePlus(sender)        }
    }
    @IBAction func socialConnectViaTwitch(_ sender: Any) {
        
        if !COMMON_SETTING.isInternetAvailable {
            self.showNoInternetAlert()
            return
        }
        if COMMON_SETTING.isTwitchConnect{
            
            let refreshAlert = UIAlertController(title: kMessage, message: kDisconnect, preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: kOK, style: .default, handler: { (action: UIAlertAction!) in
                
                COMMON_SETTING.isTwitchConnect = false
                self.imgTwitchConnected.isHidden = true
                let dicReq = NSMutableDictionary.init(object: "twitch", forKey: "socialType" as NSCopying)
                
                self.getSocialDisconnect(dicReq)

            }))
            
            refreshAlert.addAction(UIAlertAction(title: kCancel, style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        }
        else{
            super.socialLoginViaTwitch(sender)
            
        }
    }
    
     //MARK:- SocialDisconnect Methods
    
    func getSocialDisconnect(_ userInfo: NSMutableDictionary) -> Void {
        
        //On Success Call
        let success:successHandler = {responseObject,requestType in
            // Success call implementation
            let responseDict = serviceCall.parseResponse(responseObject: responseObject as Any)
            
            self.updateSocialConnection()
            print(responseDict)
        }
        
        //On Failure Call
        let falure:falureHandler = {error,responseMessage,requestType in
            
        }
        print(userInfo)
        serviceCall.sendRequest(parameters: userInfo, urlType: RequestedUrlType.DisconnectSocialLogin, method: "POST", successCall: success, falureCall: falure)
        
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
            
            if IS_IPHONE{
            self.present(self.imagePicker, animated: true, completion: nil)
            }
            else{
                self.popover=UIPopoverController.init(contentViewController:self.imagePicker)
                
                self.popover!.present(from: self.profilePicButton.frame, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            optionMenu.dismiss(animated: true, completion: nil)
        })
        
        optionMenu.addAction(addAction)
        optionMenu.addAction(takeAction)
        optionMenu.addAction(cancelAction)
        if IS_IPHONE {
            self.present(optionMenu, animated: true, completion: nil)

        }
        else{
            popover = UIPopoverController.init(contentViewController: optionMenu)
            
            popover!.present(from: self.profilePicButton.frame, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        }
        
        
    }
    
    //MARK:- Social Login response
    override func onLogInSuccess(_ userInfo: NSDictionary,connectType:SocialConnectType) -> Void {
        self.hideHUD()
        
        if connectType == SocialConnectType.FACEBOOK {
            COMMON_SETTING.isFBConnect = true
            self.imgFBConnected.isHidden = false
        }
        else if connectType == SocialConnectType.TWITTER {
            COMMON_SETTING.isTwitterConnect = true
            self.imgTwitchConnected.isHidden = false
        }
        else if connectType == SocialConnectType.GOOGLEPLUS {
            COMMON_SETTING.isGoogleConnect = true
            self.imgGoogleConnected.isHidden = false
        }
        else if connectType == SocialConnectType.TWITCH {
            COMMON_SETTING.isTwitchConnect = true
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
       
        pickerView = UIPickerView.init(frame: CGRect(x: 0, y: 467, width: 375, height: 200))
        pickerView.backgroundColor = UIColor.black
        pickerView.delegate = self
        
        self.txtAge.inputView = pickerView
        self.txtGender.inputView = pickerView
        
       let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 375, height: 40))
        toolBar.backgroundColor = UIColor.black
        toolBar.barTintColor = UIColor.black
        toolBar.tintColor = UIColor.white
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(SettingViewController.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: #selector(SettingViewController.tappedToolBarBtn(sender:)))
        
        toolBar.setItems([flexSpace,doneButton], animated: true)
        
        self.txtAge.inputAccessoryView = toolBar
        self.txtGender.inputAccessoryView = toolBar

        
    }
    
    func configurePickerViewData()
    {
            self.aryAge = NSMutableArray()
            for i in 10..<100 {
                self.aryAge.add(String(format: "%d",i))
            }
         self.aryGender = ["M","F"]
        
    }
    
    func donePressed(sender: UIBarButtonItem) {
        if self.activeTextField == self.txtAge {
        self.txtAge.resignFirstResponder()
        }
        else{
        self.txtGender.resignFirstResponder()
        }
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        
    self.activeTextField.resignFirstResponder()
    }
    
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if self.activeTextField == self.txtAge {
            return self.aryAge.count
        }else if self.activeTextField == self.txtGender
        {
            return self.aryGender.count
        }

        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if self.activeTextField == self.txtAge {
        let title: String = self.aryAge.object(at: row) as! String
        return title
        }
        else if self.activeTextField == self.txtGender
         {
            let title: String = self.aryGender.object(at: row) as! String
            return title
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.activeTextField == self.txtAge {
             self.txtAge.text = self.aryAge.object(at: row) as? String
        }
        else if self.activeTextField == self.txtGender
        {
            self.txtGender.text = self.aryGender.object(at: row) as? String
        }
        self.activeTextField.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var attributedString = NSAttributedString()
        if self.activeTextField == self.txtAge {
            attributedString = NSAttributedString(string: self.aryAge[row] as! String, attributes: [NSForegroundColorAttributeName : UIColor.black])
        }
        else if self.activeTextField == self.txtGender
        {
            attributedString = NSAttributedString(string: self.aryGender[row] as! String, attributes: [NSForegroundColorAttributeName : UIColor.black])
        }
        
        return attributedString
    }
    

    
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any])
    {
        
        if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.profilePicButton.setBackgroundImage(pickerImage, for: UIControlState.normal)
            self.profilePicButton.layer.cornerRadius = self.profilePicButton.frame.size.height/2
            self.profilePicButton.layer.masksToBounds = true;
            self.isImagedPicked = true

        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- Textfield delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        self.activeTextField = textField
        if  self.activeTextField == self.txtAge || self.activeTextField == self.txtGender {
           self.pickerView.isHidden = false
        }
        
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
        
        if textField == self.txtEmail {
            if (self.txtEmail.text == COMMON_SETTING.myProfile?.emailid){
                self.didEmailChanged = false
            }
            else{
                self.didEmailChanged = true
            }
        }
        addDismisskeyboardTapGesture()
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
            let responseDict = serviceCall.parseResponse(responseObject: responseObject as Any)
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
