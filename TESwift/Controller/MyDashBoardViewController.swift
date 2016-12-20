//
//  MyDashBoardViewController.swift
//  TESwift
//
//  Created by Apple on 12/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class MyDashBoardViewController: BaseViewController, UITableViewDataSource, UIScrollViewDelegate {
    
    //TopView outlets
    @IBOutlet weak var topViewBGImg: UIImageView!
    @IBOutlet weak var userProImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var emaillbl: UILabel!
    
    //Bottomview outlets
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var hypBtn: UIButton!
    @IBOutlet weak var tournamentsBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    
    //autolayout constants                              // Actual values
    @IBOutlet weak var menuBtnTop: NSLayoutConstraint!  // 30
    @IBOutlet weak var profileImageWidth: NSLayoutConstraint!// 140
    @IBOutlet weak var usernameTop: NSLayoutConstraint!// 21
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!//317
    @IBOutlet weak var profileImageTop: NSLayoutConstraint!//40
    @IBOutlet weak var emailTop: NSLayoutConstraint!// 5
    
    //Local Variables
    var isSwipedUp = false
    var currentButtonIndex:NSInteger = 0
    
    //Arrays for Hype, tournaments and notifications
    var hypetoShowArray:NSArray = NSArray()
    var tournamentsToShowArray:NSArray = NSArray()
    var notificationToShowArray:NSArray = NSArray()
    var userProfileInfo:NSMutableDictionary = NSMutableDictionary()
    
    //MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showHUD()
        
        self.setUpStyleGuide()
        
        self.setupMenu()
        
        tableView.estimatedRowHeight = 139.0
        
        self.setupData()
        
        self.saveUserDetails(loginInfo: commonSetting.userLoginInfo)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utilities
    
    func setUpStyleGuide() -> Void {
        self.notificationBtn.alpha = 0.25
        self.hypBtn.alpha = 1.0
        self.tournamentsBtn.alpha = 0.25
        currentButtonIndex = 1
    }
    
    func setupData() -> Void {
        
        self.addSwipeGesture()
        
        self.setProfileData(userInfo: commonSetting.userLoginInfo)
        
        self.getUserProfileData()
        
        saveUserDetails(loginInfo: commonSetting.userLoginInfo)
        
    }
    
    func saveUserDetails(loginInfo: NSDictionary) -> Void {
        
        //                let userInfo:NSMutableDictionary = NSMutableDictionary()
        //
        //                userInfo.setValue(loginInfo.value(forKey: "name"), forKey: "name")
        //                userInfo.setValue(loginInfo.value(forKey: "email"), forKey: "email")
        //                userInfo.setValue(loginInfo.value(forKey: "userID"), forKey: "userID")
        //                userInfo.setValue(loginInfo.value(forKey: "username"), forKey: "username")
        //                userInfo.setValue(loginInfo.value(forKey: "userSubscription") as! Bool, forKey: "userSubscription")
        //
        //                _ = UserDetails.insertUserDetails(info:userInfo, context:self.manageObjectContext())
        //                UserDetails.save(self.manageObjectContext())
        //
        //                let predi = NSPredicate(format: "age = %d", 33)
        //                let user = UserDetails.fetchUserDetailsFor(context: self.manageObjectContext(), predicate: predi)
        //                print(user)
    }
    
    func setProfileData(userInfo:NSDictionary) {
        
        self.userNameLbl.text = userInfo.stringValueForKey(key: "name").uppercased()
        self.emaillbl.text = userInfo.stringValueForKey(key: "email")
        let imagekey:String = userInfo.stringValueForKey(key: "imageKey")
        
        if !commonSetting.isEmptySting(imagekey)
        {
            // For storing temporary imageKey for using in MenuViewController
            
            commonSetting.imageKeyProfile = imagekey
            //On Success Call
            let success:downloadImageSuccess = {image,imageKey in
                // Success call implementation
                
                self.userProImage.setRoundedImage(image: image, borderWidth: ProfileImageBorder, imageWidth: self.profileImageWidth.constant)
                self.topViewBGImg.image = image
                
                self.setBlurImage(imageView: self.topViewBGImg)
                
            }
            
            //On Falure Call
            let falure:downloadImageFailed = {error,responseMessage in
                
                // Falure call implementation
                
            }
            
            ServiceCall.sharedInstance.downloadImage(imageKey: imagekey, urlType: RequestedUrlType.DownloadImage, successCall: success, falureCall: falure)
        }
    }
    
    
    func setupMenu() -> Void {
        if  revealViewController() != nil {
            menuButton.addTarget(revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            if DeviceType.IS_IPHONE_5
            {
                self.revealViewController().rearViewRevealWidth = 250
            }else
            {
                self.revealViewController().rearViewRevealWidth = 300
            }
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    func getMyProfile() {
        //On success
        
        let success: successHandler = {responseObject, responseType in
            
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            print(responseDict)
            TEMyProfile.deleteAllFormMyProfile(context:self.manageObjectContext())
            TEMyProfile.parsetMyProfileDetail(myProfileInfo: responseDict, context: self.manageObjectContext())
            
        }
        let failure: falureHandler = {error, responseString, responseType in
            
            print(responseString)
        }
        
        // Service call for get user profile data (Hypes, upcomings, person, followers)
        // ServiceCall.sharedInstance.sendRequest(parameters: NSMutableDictionary(), urlType: RequestedUrlType.GetMyProfile, method: "GET", successCall: success, falureCall: failure)
        
        
    }
    
    func getUserProfileData(){
        
        //On success
        let success: successHandler = {responseObject, responseType in
            
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            print(responseDict)
            
            if responseType == RequestedUrlType.GetUserProfileData {
                
                //initialize hype list
                if let array:NSArray =  responseDict.object(forKey: "hypes") as? NSArray
                {
                    self.hypetoShowArray = array
                }
                //initialize tournament list
                if let array:NSArray =  responseDict.object(forKey: "upcoming") as? NSArray
                {
                    self.tournamentsToShowArray = array
                }
                
                //Parse User Data
                self.parseUserInfo(userInfo: responseDict.object(forKey: "person") as! NSDictionary)
                
            }else if responseType == RequestedUrlType.GetAllNotification
            {
                //initialize hype list
                if let array:NSArray =  responseDict.object(forKey: "list") as? NSArray
                {
                    self.notificationToShowArray = array
                }
            }
            self.hideHUD()
            
        }
        let failure: falureHandler = {error, responseString, responseType in
            
            self.hideHUD()
            print(responseString)
        }
        
        // Service call for get user profile data (Hypes, upcomings, person, followers)
        ServiceCall.sharedInstance.sendRequest(parameters: NSMutableDictionary(), urlType: RequestedUrlType.GetUserProfileData, method: "GET", successCall: success, falureCall: failure)
        
        // Service call for notifications
        ServiceCall.sharedInstance.sendRequest(parameters: NSMutableDictionary(), urlType: RequestedUrlType.GetAllNotification, method: "GET", successCall: success, falureCall: failure)
        
    }
    
    func parseUserInfo(userInfo:NSDictionary) {
        
        self.userProfileInfo.setDictionary(userInfo as! [AnyHashable : Any])
        self.userProfileInfo.addEntries(from: commonSetting.userLoginInfo as! [AnyHashable : Any])
        self.setProfileData(userInfo: self.userProfileInfo)
        self.tableView.reloadData()
        
    }
    
    private func scrollViewWillEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(scrollView.contentOffset, animated: true)
    }
    
    
    //MARK:- SwipeGesture methods
    
    func addSwipeGesture(){
        
        let swipeUpGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(MyDashBoardViewController.swipeUpHandler(sender:)))
        swipeUpGesture.direction = UISwipeGestureRecognizerDirection.up
        
        let swipeDownGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(MyDashBoardViewController.swipeDownHandler(sender:)))
        swipeDownGesture.direction = UISwipeGestureRecognizerDirection.down
        
        self.topViewBGImg.addGestureRecognizer(swipeUpGesture)
        self.topViewBGImg.addGestureRecognizer(swipeDownGesture)
    }
    
    func swipeUpHandler(sender:UISwipeGestureRecognizer){
        
        if self.isSwipedUp {
            return
        }
        
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            
            self.profileImageWidth.constant = 70
            self.headerViewHeight.constant = 182
            self.profileImageTop.constant = 15
            self.menuBtnTop.constant = 15
            self.usernameTop.constant = 4
            self.emailTop.constant = 2
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            
        }, completion: {(isCompleted) -> Void in
            self.isSwipedUp = true
        })
        
        commonSetting.animateProfileImage(imageView: self.userProImage)
        
    }
    func swipeDownHandler(sender:UISwipeGestureRecognizer){
        
        if !self.isSwipedUp {
            return
        }
        
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            
            self.profileImageWidth.constant = 140
            self.headerViewHeight.constant = 317
            self.profileImageTop.constant = 40
            self.menuBtnTop.constant = 30
            self.usernameTop.constant = 21
            self.emailTop.constant = 5
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            
        }, completion: {(isCompleted) -> Void in
            self.isSwipedUp = false
        })
        
        commonSetting.animateProfileImage(imageView: self.userProImage)
    }
    
    // MARK: - IBOutlet Actions
    @IBAction func notificationAction(_ sender: AnyObject) {
        
        self.notificationBtn.alpha = 1.0
        self.hypBtn.alpha = 0.25
        self.tournamentsBtn.alpha = 0.25
        currentButtonIndex = 0
        self.tableView.reloadData()
        
    }
    
    @IBAction func tournamentAction(_ sender: AnyObject) {
        self.notificationBtn.alpha = 0.25
        self.hypBtn.alpha = 0.25
        self.tournamentsBtn.alpha = 1.0
        currentButtonIndex = 2
        self.tableView.reloadData()
    }
    
    @IBAction func hypeAction(_ sender: AnyObject) {
        self.notificationBtn.alpha = 0.25
        self.hypBtn.alpha = 1.0
        self.tournamentsBtn.alpha = 0.25
        currentButtonIndex = 1
        self.tableView.reloadData()
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int = 0
        if currentButtonIndex == 0 {
            count = notificationToShowArray.count
            
        }else if currentButtonIndex == 1
        {
            count = hypetoShowArray.count
            
        }else
        {
            count = tournamentsToShowArray.count
        }
        
        if count == 0{
            let noDataLabel:UILabel  = UILabel.init(frame: CGRect(x:0,y:0,width:tableView.bounds.size.width,height:tableView.bounds.size.height))
            noDataLabel.text = "No data available";
            noDataLabel.textColor = UIColor.lightGray
            noDataLabel.textAlignment = NSTextAlignment.center;
            tableView.backgroundView = noDataLabel;
        }
        else{
            tableView.backgroundView   = nil;
        }
        return count
    }
    
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        
        tableView.rowHeight = 139.0
        
        let cell:UITableViewCell
        if currentButtonIndex == 0 {
            
            cell = self.configureNotificationCell(tableView: tableView, indexPath: indexPath)
            tableView.rowHeight = 50.0
            
        }else if currentButtonIndex == 1
        {
            cell = self.configureHypeCell(tableView: tableView, indexPath: indexPath)
            
        }else
        {
            cell = self.configureTournamentCell(tableView: tableView, indexPath: indexPath)
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    
    func  configureHypeCell(tableView:UITableView, indexPath:IndexPath) -> hypeTableViewCell {
        
        let cell:hypeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "hypeTableViewCell", for: indexPath) as! hypeTableViewCell
        
        let hypeInfo:NSDictionary = self.parseResponse(responseObject: hypetoShowArray.object(at: indexPath.row))
        
        
        // SETUP HYPE BORDER IMAGE
        if hypeInfo.stringValueForKey(key: "hypableType") == "TOURNAMENT" {
            cell.hypeBorderImg.image = UIImage(named: "HypeImageBorder")
        }else
        {
            cell.hypeBorderImg.image = UIImage(named: "EventCellHyped")
        }
        cell.hypeBgImg.image = nil
        let imageKey = hypeInfo.stringValueForKey(key: "imageKey")
        
        weak var weakCell:hypeTableViewCell? = cell
        
        let sucess:downloadImageSuccess = {image, imageKey in
            
            weakCell!.hypeBgImg.image = image
            weakCell!.progressBar.stopAnimating()
            
        }
        
        let failure:downloadImageFailed = {error, responseString in
            
            // On failure implementation
        }
        
        // CAll api if image key available..
        if imageKey != "" {
            cell.progressBar.startAnimating()
            ServiceCall.sharedInstance.downloadImage(imageKey: imageKey, urlType: RequestedUrlType.DownloadImage, successCall: sucess, falureCall: failure)
        }else
        {
            // set default image if image key is not available..
            cell.progressBar.stopAnimating()
            cell.hypeBgImg.image = UIImage(named: "Default")
        }
        
        cell.hypNameLbl.text = hypeInfo.stringValueForKey(key: "name")
        cell.gameLbl.text = hypeInfo.stringValueForKey(key: "game")
        cell.locationLbl.text = hypeInfo.stringValueForKey(key: "venue")
        cell.dateLbl.text = self.getLocaleDateStringFromString(dateString: hypeInfo.stringValueForKey(key: "startDate"))
        
        return cell
    }
    
    
    func  configureTournamentCell(tableView:UITableView, indexPath:IndexPath) -> hypeTableViewCell {
        
        let cell:hypeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "hypeTableViewCell", for: indexPath) as! hypeTableViewCell
        
        let tournaInfo:NSDictionary = self.parseResponse(responseObject: tournamentsToShowArray.object(at: indexPath.row))
        
        let val = tournaInfo.value(forKey: "hype") as! NSNumber
        
        if val == 0 {
            cell.hypeBorderImg.image = UIImage(named: "ImageBorder")
        }else
        {
            cell.hypeBorderImg.image = UIImage(named: "HypeImageBorder")
        }
        
        cell.hypeBorderImg.image = UIImage(named: "ImageBorder")
        
        cell.hypeBgImg.image = nil
        
        let imageKey = tournaInfo.stringValueForKey(key: "imageKey")
        
        weak var weakCell:hypeTableViewCell? = cell
        
        let sucess:downloadImageSuccess = {image, imageKey in
            
            weakCell!.hypeBgImg.image = image
            weakCell!.progressBar.stopAnimating()
        }
        
        let failure:downloadImageFailed = {error, responseString in
            
            // On failure implementation
        }
        if imageKey != "" {
            cell.progressBar.startAnimating()
            ServiceCall.sharedInstance.downloadImage(imageKey: imageKey, urlType: RequestedUrlType.DownloadImage, successCall: sucess, falureCall: failure)
        }else
        {
            cell.progressBar.stopAnimating()
            cell.hypeBgImg.image = UIImage(named: "Default")
        }
        cell.hypNameLbl.text = tournaInfo.stringValueForKey(key: "name").uppercased()
        cell.gameLbl.text = tournaInfo.stringValueForKey(key: "game")
        cell.locationLbl.text = tournaInfo.stringValueForKey(key: "venue")
        cell.dateLbl.text = self.getFormattedDateString(info: tournaInfo, indexPath: indexPath, format: "yyyy")
        
        
        return cell
    }
    
    func  configureNotificationCell(tableView:UITableView, indexPath:IndexPath) -> NotificationTableViewCell {
        
        let cell:NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor.darkGray
        
        let notificationInfo:NSDictionary = self.parseResponse(responseObject: notificationToShowArray.object(at: indexPath.row))
        
        var message:String = notificationInfo.stringValueForKey(key: "notificationHeader")
        
        var attributedStringMessage = NSMutableAttributedString(string: message, attributes: [NSForegroundColorAttributeName : UIColor.white])
        
        let map:NSDictionary = self.parseResponse(responseObject: notificationInfo.value(forKey: "map") as Any)
        
        let tournamentInfo:NSDictionary = self.getNotificationMapInfo(notification: map, key: "tournamentinfo")
        let eventInfo:NSDictionary = self.getNotificationMapInfo(notification: map, key: "eventinfo")
        let seasonInfo:NSDictionary = self.getNotificationMapInfo(notification: map, key: "seasoninfo")
        let userInfo:NSDictionary = self.getNotificationMapInfo(notification: map, key: "userinfo")
        
        var fontForHeighlight:UIFont = StyleGuide.fontFutaraBold(withFontSize: 14)
        if IS_IPAD {
            fontForHeighlight = StyleGuide.fontFutaraBold(withFontSize: 18)
        }
        
        if !userInfo.stringValueForKey(key: "name").isEmpty {
            var name = userInfo.stringValueForKey(key: "name")
            message = message.replacingOccurrences(of: name, with: String.init(format: "@%@", name))
            name = String.init(format: "@%@", name)
            let range = (message as NSString).range(of:name)
            
            attributedStringMessage = NSMutableAttributedString(string: message, attributes: [NSForegroundColorAttributeName : UIColor.white])
            attributedStringMessage.addAttribute(NSForegroundColorAttributeName, value: kLightBlueColor , range: range)
            attributedStringMessage.addAttribute(NSFontAttributeName, value: fontForHeighlight, range: range)
        }
        
        if !tournamentInfo.stringValueForKey(key: "name").isEmpty {
            let name = tournamentInfo.stringValueForKey(key: "name")
            let range = (message as NSString).range(of:name)
            attributedStringMessage.addAttribute(NSForegroundColorAttributeName, value: kLightBlueColor , range: range)
            attributedStringMessage.addAttribute(NSFontAttributeName, value: fontForHeighlight, range: range)
        }
        
        if !seasonInfo.stringValueForKey(key: "name").isEmpty {
            let name = seasonInfo.stringValueForKey(key: "name")
            let range = (message as NSString).range(of:name)
            attributedStringMessage.addAttribute(NSForegroundColorAttributeName, value: kLightBlueColor , range: range)
            attributedStringMessage.addAttribute(NSFontAttributeName, value: fontForHeighlight, range: range)
        }
        
        if !eventInfo.stringValueForKey(key: "name").isEmpty {
            let name = eventInfo.stringValueForKey(key: "name")
            let range = (message as NSString).range(of:name)
            attributedStringMessage.addAttribute(NSForegroundColorAttributeName, value: kLightBlueColor , range: range)
            attributedStringMessage.addAttribute(NSFontAttributeName, value: fontForHeighlight, range: range)
        }
        
        cell.notificationTextView.text = nil
        cell.notificationTextView.attributedText = nil
        cell.notificationTextView.attributedText = attributedStringMessage
        
        return cell
    }
    
    func getNotificationMapInfo(notification:NSDictionary, key:String) -> NSDictionary {
        if let tournamentInfo:NSArray = notification.value(forKey: key) as? NSArray
        {
            let dictionary:NSDictionary = self.parseResponse(responseObject: tournamentInfo.firstObject as Any)
            return dictionary
        }
        return NSDictionary()
    }
    
}
