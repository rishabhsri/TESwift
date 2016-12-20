//
//  MyDashBoardViewController.swift
//  TESwift
//
//  Created by Apple on 12/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class MyDashBoardViewController: BaseViewController, UITableViewDataSource,UITableViewDelegate {
    
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
    var isResponseReceived = false
    var isTournamentLoadMore = false
    var isHypeLoadMore = false
    var isNotificationLoadMore = false
    var tournamentPageIndex:NSInteger = 0
    var hypePageIndex:NSInteger = 0
    var notificationPageIndex:NSInteger = 0
    var currentButtonIndex:NSInteger = 0
    
    //Arrays for Hype, tournaments and notifications
    var hypetoShowArray:NSMutableArray = NSMutableArray()
    var tournamentsToShowArray:NSMutableArray = NSMutableArray()
    var notificationToShowArray:NSMutableArray = NSMutableArray()
    var userProfileInfo:NSMutableDictionary = NSMutableDictionary()
    
    //MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpStyleGuide()
        
        self.setupMenu()
        
        self.setupData()
        
        self.saveUserDetails(loginInfo: commonSetting.userLoginInfo)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utilities
    
    func setUpStyleGuide() -> Void {
        
        var fontSize:CGFloat = 17  //for iPad
        
        if IS_IPHONE {
            if DeviceType.IS_IPHONE_5 {
                fontSize = 12
            }else if DeviceType.IS_IPHONE_4_OR_LESS
            {
                fontSize = 10
            }else
            {
                fontSize = 15
            }
            self.notificationBtn.titleLabel?.font = StyleGuide.fontFutaraBold(withFontSize: fontSize)
            self.hypBtn.titleLabel?.font = StyleGuide.fontFutaraBold(withFontSize: fontSize)
            self.tournamentsBtn.titleLabel?.font = StyleGuide.fontFutaraBold(withFontSize: fontSize)
        }
    }
    
    func setupData() -> Void {
        
        self.addSwipeGesture()
        
        self.resetLoadMore()
        
        self.setupTableView()
        
        self.setProfileData(userInfo: commonSetting.userLoginInfo)
        
        self.getUserProfileData()
        
        saveUserDetails(loginInfo: commonSetting.userLoginInfo)
        
    }
    
    func resetLoadMore() {
        self.isTournamentLoadMore = false
        self.isHypeLoadMore = false
        self.isNotificationLoadMore = false
        self.tournamentPageIndex = 0
        self.hypePageIndex = 0
        self.notificationPageIndex = 0
        self.currentButtonIndex = 0
    }
    
    func setupTableView() {
        self.notificationBtn.alpha = 0.25
        self.hypBtn.alpha = 1.0
        self.tournamentsBtn.alpha = 0.25
        self.currentButtonIndex = 1
        self.tableView.estimatedRowHeight = 44;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView()
        
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
        
        if !commonSetting.isEmptyStingOrWithBlankSpace(imagekey)
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
    
    func parseUserInfo(userInfo:NSDictionary) {
        
        self.userProfileInfo.setDictionary(userInfo as! [AnyHashable : Any])
        self.userProfileInfo.addEntries(from: commonSetting.userLoginInfo as! [AnyHashable : Any])
        self.setProfileData(userInfo: self.userProfileInfo)
        
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
    
    //MARK:- Service Calls for data
    
    func getUserProfileData(){
        
        //On success
        let success: successHandler = {responseObject, responseType in
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            print(responseDict)
            self.isResponseReceived = true
            if responseType == RequestedUrlType.GetUserProfileData {
                
                //initialize hype list
                if let array:NSArray =  responseDict.object(forKey: "hypes") as? NSArray
                {
                    self.hypetoShowArray = NSMutableArray.init(array: array)
                    if self.hypetoShowArray.count < 10 {
                        self.isHypeLoadMore = false
                    }else
                    {
                        self.isHypeLoadMore = true
                        self.hypePageIndex = 1
                    }
                    
                }
                //initialize tournament list
                if let array:NSArray =  responseDict.object(forKey: "upcoming") as? NSArray
                {
                    self.tournamentsToShowArray = NSMutableArray.init(array: array)
                    if self.tournamentsToShowArray.count < 10 {
                        self.isTournamentLoadMore = false
                    }else
                    {
                        self.isTournamentLoadMore = true
                        self.tournamentPageIndex = 1
                    }
                }
                
                //Parse User Data
                self.parseUserInfo(userInfo: responseDict.object(forKey: "person") as! NSDictionary)
                
            }else if responseType == RequestedUrlType.GetAllNotification
            {
                //initialize hype list
                if let array:NSArray =  responseDict.object(forKey: "list") as? NSArray
                {
                    self.notificationToShowArray = NSMutableArray.init(array: array)
                    if self.notificationToShowArray.count < 10 {
                        self.isNotificationLoadMore = false
                    }else
                    {
                        self.isNotificationLoadMore = true
                        self.notificationPageIndex = 1
                    }
                }
            }
            self.tableView.reloadData()
            self.hideHUD()
            
        }
        let failure: falureHandler = {error, responseString, responseType in
            self.isResponseReceived = true
            self.hideHUD()
            print(responseString)
        }
        
        // Service call for get user profile data (Hypes, upcomings, person, followers)
        ServiceCall.sharedInstance.sendRequest(parameters: NSMutableDictionary(), urlType: RequestedUrlType.GetUserProfileData, method: "GET", successCall: success, falureCall: failure)
        
        // Service call for notifications
        ServiceCall.sharedInstance.sendRequest(parameters: NSMutableDictionary(), urlType: RequestedUrlType.GetAllNotification, method: "GET", successCall: success, falureCall: failure)
        
    }
    
    func getTournaments() {
        //On success
        let success: successHandler = {responseObject, responseType in
            
            self.hideHUD()
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            if responseType == RequestedUrlType.GetCurrentAndUpcomingTournament {
                
                //initialize hype list
                if let array:NSArray =  responseDict.object(forKey: "list") as? NSArray
                {
                    if array.count < 10 {
                        self.isTournamentLoadMore = false
                    }else
                    {
                        self.isTournamentLoadMore = true
                    }
                    self.tournamentsToShowArray.addObjects(from: array as! [Any])
                    self.tableView.reloadData()
                }
                
            }
        }
        let failure: falureHandler = {error, responseString, responseType in
            self.hideHUD()
            print(responseString)
        }
        
        self.showHUD()
        
        let requestDict:NSMutableDictionary = NSMutableDictionary()
        requestDict.setValue(self.userProfileInfo.stringValueForKey(key: "userID"), forKey: "userID")
        requestDict.setValue("\(self.tournamentPageIndex)", forKey: "pagenumber")
        // Service call for get user profile data (Hypes, upcomings, person, followers)
        ServiceCall.sharedInstance.sendRequest(parameters: requestDict, urlType: RequestedUrlType.GetCurrentAndUpcomingTournament, method: "GET", successCall: success, falureCall: failure)
    }
    
    func getNotifications() {
        
    }
    
    func getHypeTournaments() {
        
    }
    
    //MARK:- ScrollView Delegates
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if commonSetting.isInternetAvailable {
            if currentButtonIndex == 1 || currentButtonIndex == 2 {
                var endScrolling = 0.0
                var dimension = 0.0
                
                if IS_IPHONE {
                    endScrolling = Double(scrollView.contentOffset.y) + Double(scrollView.frame.size.height)
                    dimension = Double(scrollView.contentSize.height)
                }else
                {
                    endScrolling = Double(scrollView.contentOffset.x) + Double(scrollView.frame.size.width)
                    dimension = Double(scrollView.contentSize.width)
                }
                
                if endScrolling >= dimension {
                    
                    if currentButtonIndex == 2 && self.isTournamentLoadMore {
                        self.tournamentPageIndex += 1
                        self.isTournamentLoadMore = false
                        self.getTournaments()
                    }else if currentButtonIndex == 2 && self.isHypeLoadMore
                    {
                        self.hypePageIndex += 1
                        self.isHypeLoadMore = false
                        self.getHypeTournaments()
                    }
                }
            }else
            {
                var endScrolling = 0.0
                var dimension = 0.0
                
                endScrolling = Double(scrollView.contentOffset.y) + Double(scrollView.frame.size.height)
                dimension = Double(scrollView.contentSize.height)
                
                if endScrolling >= dimension {
                    
                    if  self.isNotificationLoadMore {
                        self.notificationPageIndex += 1
                        self.isNotificationLoadMore = false
                        self.getNotifications()
                    }
                }
            }
        }
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int = 0
        if currentButtonIndex == 0 {
            count = notificationToShowArray.count
            
        }else if currentButtonIndex == 1
        {
            count = hypetoShowArray.count
            
        }else if currentButtonIndex == 2
        {
            count = tournamentsToShowArray.count
        }
        
        if count == 0{
            let noDataLabel:UILabel  = UILabel.init(frame: CGRect(x:0,y:0,width:tableView.bounds.size.width,height:tableView.bounds.size.height))
            if self.isResponseReceived {
                noDataLabel.text = "No data available"
            }else
            {
                noDataLabel.text = "Loading..."
            }
            noDataLabel.textColor = UIColor.lightGray
            noDataLabel.textAlignment = NSTextAlignment.center
            tableView.backgroundView = noDataLabel
        }
        else{
            tableView.backgroundView   = nil
        }
        return count
    }
    
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        
        let cell:UITableViewCell
        if currentButtonIndex == 0 {
            
            cell = self.configureNotificationCell(tableView: tableView, indexPath: indexPath)
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            
        }else if currentButtonIndex == 1
        {
            cell = self.configureHypeCell(tableView: tableView, indexPath: indexPath)
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            
        }else
        {
            cell = self.configureTournamentCell(tableView: tableView, indexPath: indexPath)
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        tableView.separatorColor = UIColor.darkGray
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (currentButtonIndex == 0) {
            return UITableViewAutomaticDimension
        }
        else{
            return 139.0
        }
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
        
        let notificationInfo:NSDictionary = self.parseResponse(responseObject: notificationToShowArray.object(at: indexPath.row))
        
        var message:String = notificationInfo.stringValueForKey(key: "notificationHeader")
        
        let receivedDate:Date = self.getLocaleDateFromString(dateString: notificationInfo.value(forKey: "date") as! String)
        let timeDifference:String = NSDate.getTimeDiff(since: receivedDate)
        if !timeDifference.isEmpty
        {
            message = message.appendingFormat("  %@", timeDifference)
        }
        
        var fontForHeader:UIFont = StyleGuide.fontFutaraRegular(withFontSize: 16)
        if IS_IPAD {
            fontForHeader = StyleGuide.fontFutaraRegular(withFontSize: 21)
        }
        
        let attributesForHeaderString:[String : Any] = [NSForegroundColorAttributeName : UIColor.white,NSFontAttributeName : fontForHeader]
        var attributedStringMessage = NSMutableAttributedString(string: message, attributes: attributesForHeaderString)
        
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
            
            attributedStringMessage = NSMutableAttributedString(string: message, attributes: attributesForHeaderString)
            attributedStringMessage.addAttribute(NSForegroundColorAttributeName, value: kLightBlueColor , range: range)
            attributedStringMessage.addAttribute(NSFontAttributeName, value: fontForHeighlight, range: range)
            attributedStringMessage.addAttribute("clickOnUser", value: true, range: range)
        }
        
        if !timeDifference.isEmpty {
            
            let range = (message as NSString).range(of:timeDifference)
            attributedStringMessage.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray , range: range)
            attributedStringMessage.addAttribute(NSFontAttributeName, value: StyleGuide.fontFutaraRegular(withFontSize: 10), range: range)
        }
        
        if !tournamentInfo.stringValueForKey(key: "name").isEmpty {
            let name = tournamentInfo.stringValueForKey(key: "name")
            let range = (message as NSString).range(of:name)
            attributedStringMessage.addAttribute(NSForegroundColorAttributeName, value: kLightBlueColor , range: range)
            attributedStringMessage.addAttribute(NSFontAttributeName, value: fontForHeighlight, range: range)
            attributedStringMessage.addAttribute("clickOnTournament", value: true, range: range)
        }
        
        if !seasonInfo.stringValueForKey(key: "name").isEmpty {
            let name = seasonInfo.stringValueForKey(key: "name")
            let range = (message as NSString).range(of:name)
            attributedStringMessage.addAttribute(NSForegroundColorAttributeName, value: kLightBlueColor , range: range)
            attributedStringMessage.addAttribute(NSFontAttributeName, value: fontForHeighlight, range: range)
            attributedStringMessage.addAttribute("clickOnSeason", value: true, range: range)
        }
        
        if !eventInfo.stringValueForKey(key: "name").isEmpty {
            let name = eventInfo.stringValueForKey(key: "name")
            let range = (message as NSString).range(of:name)
            attributedStringMessage.addAttribute(NSForegroundColorAttributeName, value: kLightBlueColor , range: range)
            attributedStringMessage.addAttribute(NSFontAttributeName, value: fontForHeighlight, range: range)
            attributedStringMessage.addAttribute("clickOnEvent", value: true, range: range)
        }
        
        cell.notificationTextView.text = nil
        cell.notificationTextView.attributedText = nil
        cell.notificationTextView.attributedText = attributedStringMessage
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(MyDashBoardViewController.textTapped(recognizer:)))
        cell.notificationTextView.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    func textTapped(recognizer:UITapGestureRecognizer) {
        
        let textView:UITextView = recognizer.view as! UITextView
        
        // Location of the tap in text-container coordinates
        let layoutManager:NSLayoutManager = textView.layoutManager
        var location:CGPoint = recognizer.location(in: textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top
        
        // Find the character that's been tapped on
        let characterIndex:Int = layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if characterIndex < textView.textStorage.length {
            
            var range:NSRange? = NSMakeRange(0, 1)
            if let value:Bool = textView.attributedText.attribute("clickOnUser", at: characterIndex, effectiveRange: &range!) as! Bool?
            {
                self.showAlert(title: kMessage, message: "Tapped on user")
            }
            if let value:Bool = textView.attributedText.attribute("clickOnTournament", at: characterIndex, effectiveRange: &range!) as! Bool?
            {
                self.showAlert(title: kMessage, message: "Tapped on Tournament")
            }
            if let value:Bool = textView.attributedText.attribute("clickOnSeason", at: characterIndex, effectiveRange: &range!) as! Bool?
            {
                self.showAlert(title: kMessage, message: "Tapped on Season")
            }
            if let value:Bool = textView.attributedText.attribute("clickOnEvent", at: characterIndex, effectiveRange: &range!) as! Bool?
            {
                self.showAlert(title: kMessage, message: "Tapped on Event")
            }
        }
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
