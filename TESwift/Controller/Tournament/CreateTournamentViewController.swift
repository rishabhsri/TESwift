//
//  CreateTournamentViewController.swift
//  TESwift
//
//  Created by Apple on 27/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit
import CoreLocation

class CreateTournamentViewController: SocialConnectViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    // Navigation Outlet
    @IBOutlet weak var topNavLbl: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    //edit Tounrnament View
    @IBOutlet weak var editTournamentView: UIView!
    @IBOutlet weak var staffCollectionView: UICollectionView!
    @IBOutlet weak var tournaDicriptionTextView: UITextView!
    @IBOutlet weak var editTouenamentBG: UIImageView!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var uploadProfileView: UIView!
    @IBOutlet weak var considerSwitchesView: UIView!
    
    @IBOutlet weak var tournamentnameLbl: UILabel!
    @IBOutlet weak var singleBtnOutlet: UIButton!
    @IBOutlet weak var doubleBtnOutlet: UIButton!
    @IBOutlet weak var swissBtnOutlet: UIButton!
    @IBOutlet weak var roundRobinBtnOutlet: UIButton!
    @IBOutlet weak var rankByTFBotttomImg: UIImageView!
    
    @IBOutlet weak var tounamentNameTF: UITextField!
    @IBOutlet weak var hypeBtn: UIButton!
    @IBOutlet weak var chooseGameTF: UITextField!
    @IBOutlet weak var uploadPhotoBtn: UIButton!
    @IBOutlet weak var chooseGameTableView: UITableView!
    @IBOutlet weak var hypetournamentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var matchPerWinTF: UITextField!
    @IBOutlet weak var matchPerTieTF: UITextField!
    @IBOutlet weak var gameSetWin: UITextField!
    @IBOutlet weak var gameSetTieTF: UITextField!
    @IBOutlet weak var perByeTf: UITextField!
    @IBOutlet weak var perByeLbl: UILabel!
    @IBOutlet weak var startEndTournabtn: UIButton!
    
    
    @IBOutlet weak var rankByTF: UITextField!
    @IBOutlet weak var tournamentUrl: UITextField!
    @IBOutlet weak var startDateTF: UITextField!
    @IBOutlet weak var endDateTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    
    @IBOutlet weak var tournamentDescTxtView: UITextView!
    @IBOutlet weak var twitterMesTextView: UITextView!
    @IBOutlet weak var notificationMsgtextView: UITextView!
    @IBOutlet weak var socilIfoImageSelected: UIImageView!
    
    
    @IBOutlet weak var registerSwitch: UISwitch!
    @IBOutlet weak var teamBasedSwitch: UISwitch!
    @IBOutlet weak var considerTeamSwitch: UISwitch!
    @IBOutlet weak var considerLocationSwitch: UISwitch!
    @IBOutlet weak var discordChannelSwitch: UISwitch!
    @IBOutlet weak var scoreSubmissionSwitch: UISwitch!
    @IBOutlet weak var paidTournamentSwitch: UISwitch!
    @IBOutlet weak var preRegistraionChargeTF: UITextField!
    @IBOutlet weak var advanceTimerTF: UITextField!
    @IBOutlet weak var checkInTimeTF: NSLayoutConstraint!
    @IBOutlet weak var rankByTfTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var checkInTimeTF1: UITextField!
    
    // Constraints Outlet
    @IBOutlet weak var scoreViewHightCons: NSLayoutConstraint!
    @IBOutlet weak var rankByTfHeightCOns: NSLayoutConstraint!
    @IBOutlet weak var rankByTFBtmLineHightCons: NSLayoutConstraint!
    @IBOutlet weak var hypeViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var hypeViewTopCons: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHieghtCon: NSLayoutConstraint!
    @IBOutlet weak var switchViewhieghtCons: NSLayoutConstraint!
    @IBOutlet weak var scrollViewTopCons:NSLayoutConstraint!
    
    @IBOutlet weak var navigationheghtCons: NSLayoutConstraint!
    let imagePicker = UIImagePickerController()
    var pickerView = UIPickerView()
    var datePicker  = UIDatePicker()
    var gameList = NSArray()
    var rankByArray = NSMutableArray()
    var advanceTimerArray = NSMutableArray()
    var checkInTimeArray = NSMutableArray()
    var activeTextField = UITextField()
    var locationManager = CLLocationManager()
    var toolBar = UIToolbar()
    var gameListArray = NSArray()
    var tournamentImageKey = String()
    var slectedGameType = String()
    var gameListObj:GameList?
    var strLattitude = String()
    var strLaongitude = String()
    var isTwitterLogIn:Bool = false
    var isImage:Bool = false
    var twitterkey = String()
    var startDate = String()
    var endDate = String()
    var selectedAutoAdvanceTimeIndex:Int = 0
    var selectedCheckInTimeIndex:Int = 0
    public var screenType:Screen_Type = Screen_Type.DEFAULT
    var scoreViewHieghtConsValue:CGFloat?
    var tournamentList:TETournamentList?
    var staffSet:NSArray = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setUpData()
        self.setUpLayout()
        self.setUpPickerView()
        self.getGameList()
        self.setUpDatePicker()
        // Do any additional setup after loading the view.
        if self.screenType == Screen_Type.EDIT_TOURNAMENT {
            self.setUpdataForEditTournament()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utility
    
    func setUpLayout() {
        
        self.addDismisskeyboardTapGesture()
        
        self.scoreViewHightCons.constant = 0.0
        self.rankByTfHeightCOns.constant = 0.0
        self.rankByTFBtmLineHightCons.constant = 0.0
        self.singleBtnOutlet.alpha = 1.0
        self.doubleBtnOutlet.alpha = 0.4
        self.swissBtnOutlet.alpha = 0.4
        self.roundRobinBtnOutlet.alpha = 0.4
        self.twitterMesTextView.text = kdefaultTwitterMsg
        self.notificationMsgtextView.text = kDefaultNotificationMsg
        self.advanceTimerTF.layer.cornerRadius = 12
        self.advanceTimerTF.layer.borderColor = UIColor.white.cgColor
        self.advanceTimerTF.layer.borderWidth = 1.0
        self.checkInTimeTF1.layer.cornerRadius = 12
        self.checkInTimeTF1.layer.borderColor = UIColor.white.cgColor
        self.checkInTimeTF1.layer.borderWidth = 1.0
        
        self.toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 375, height: 30))
        self.toolBar.backgroundColor = UIColor.black
        self.toolBar.barTintColor = UIColor.black
        self.toolBar.tintColor = UIColor.white
        var items = [UIBarButtonItem]()
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: #selector(CreateTournamentViewController.onClickedToolbeltButton(_:)))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: #selector(CreateTournamentViewController.onClickedToolbeltButton(_:)))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(CreateTournamentViewController.onClickedToolbeltButton(_:)))
        )
        self.toolBar.items = items
        
    }
    
    func setUpPickerView() {
        
        pickerView = UIPickerView.init(frame: CGRect(x: 0, y: 467, width: 375, height: 200))
        pickerView.backgroundColor = UIColor.black
        pickerView.delegate = self
        
        self.rankByTF.inputView = pickerView
        self.advanceTimerTF.inputView = pickerView
        self.checkInTimeTF1.inputView = pickerView
        self.rankByTF.inputAccessoryView = toolBar
        self.advanceTimerTF.inputAccessoryView = toolBar
        self.checkInTimeTF1.inputAccessoryView = toolBar
        
        rankByArray = ["Match Wins", "Game Wins", "Points Scored", "Points Difference", "Custom"]
        //gameList = ["Cricket", "Football", "Footsal", "Badminton", "Squash", "Rugby"]
        
        //   self.aryCheckInTime = [[NSMutableArray alloc ]init];
        
        self.advanceTimerArray.add(NSDictionary.init(object: "0", forKey: "None" as NSCopying))
        self.advanceTimerArray.add(NSDictionary.init(object: "5", forKey: "5 min" as NSCopying))
        self.advanceTimerArray.add(NSDictionary.init(object: "10", forKey: "10 min" as NSCopying))
        self.advanceTimerArray.add(NSDictionary.init(object: "15", forKey: "15 mins" as NSCopying))
        self.advanceTimerArray.add(NSDictionary.init(object: "30", forKey: "30 mins" as NSCopying))
        self.advanceTimerArray.add(NSDictionary.init(object: "60", forKey: "1 hours" as NSCopying))
        
        self.checkInTimeArray.add(NSDictionary.init(object: "0", forKey: "Off" as NSCopying))
        self.checkInTimeArray.add(NSDictionary.init(object: "15", forKey: "15 min" as NSCopying))
        self.checkInTimeArray.add(NSDictionary.init(object: "30", forKey: "30 min" as NSCopying))
        self.checkInTimeArray.add(NSDictionary.init(object: "60", forKey: "1 hour" as NSCopying))
        self.checkInTimeArray.add(NSDictionary.init(object: "120", forKey: "2 hours" as NSCopying))
        self.checkInTimeArray.add(NSDictionary.init(object: "180", forKey: "3 hours" as NSCopying))
        self.checkInTimeArray.add(NSDictionary.init(object: "360", forKey: "6 hours" as NSCopying))
        self.checkInTimeArray.add(NSDictionary.init(object: "1440", forKey: "1 day" as NSCopying))
        
    }
    
    func setUpDatePicker()
    {
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 467, width: 375, height: 200))
        //  datePicker.backgroundColor = UIColor.black
        //datePicker.tintColor = UIColor.white
        
        self.startDateTF.inputAccessoryView = toolBar
        self.endDateTF.inputAccessoryView = toolBar
        
        self.datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        datePicker.addTarget(self, action:#selector(CreateTournamentViewController.onClickedDatePicker(_:)) , for: UIControlEvents.valueChanged)
        self.startDateTF.inputView = datePicker
        self.endDateTF.inputView = datePicker
    }
    
    func setUpData() {
        
        self.chooseGameTableView.isHidden = true
        self.advanceTimerTF.isUserInteractionEnabled = false
        self.advanceTimerTF.alpha = 0.6
        self.preRegistraionChargeTF.isUserInteractionEnabled = false
        self.startEndTournabtn.isHidden = true
        self.slectedGameType = "SINGLE_ELIMINATION"
        self.hypeViewHeightCons.constant = 0
        self.hypeViewTopCons.constant = 0
        self.rankByTfTopCons.constant = 0
        self.hypetournamentView.isHidden = true
        self.tounamentNameTF.text = ""
        self.chooseGameTF.text = ""
        self.tournamentUrl.text = ""
        self.startDateTF.text = ""
        self.endDateTF.text = ""
        self.locationTF.text = ""
        self.tournamentDescTxtView.text = ""
        self.twitterMesTextView.text = kdefaultTwitterMsg
        self.notificationMsgtextView.text = kDefaultNotificationMsg
        self.uploadPhotoBtn.setBackgroundImage(UIImage(named: "UploadImage"), for: UIControlState.normal)
        self.tournamentUrl.text = kDefalutUrl
        self.socilIfoImageSelected.isHidden = true
        
        
        tounamentNameTF.attributedPlaceholder = NSAttributedString(string:"Tournament Name",
                                                                   attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        chooseGameTF.attributedPlaceholder = NSAttributedString(string:"-Choose Game-",
                                                                attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        startDateTF.attributedPlaceholder = NSAttributedString(string:"Start Date",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        endDateTF.attributedPlaceholder = NSAttributedString(string:"End Date",
                                                             attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        locationTF.attributedPlaceholder = NSAttributedString(string:"Location",
                                                              attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        preRegistraionChargeTF.attributedPlaceholder = NSAttributedString(string:"0.00",
                                                                          attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        self.registerSwitch.isOn = true
        self.teamBasedSwitch.isOn = false
        self.considerTeamSwitch.isOn = false
        self.considerLocationSwitch.isOn = false
        self.discordChannelSwitch.isOn = false
        self.scoreSubmissionSwitch.isOn = true
        self.paidTournamentSwitch.isOn = false
        
        self.selectedCheckInTimeIndex = 0
        self.selectedAutoAdvanceTimeIndex = 0
        self.scoreViewHieghtConsValue = self.scoreViewHightCons.constant
        self.scrollViewHieghtCon.constant = self.scrollViewHieghtCon.constant - self.scoreViewHieghtConsValue!
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
    }
    
    func setUpdataForEditTournament() {
        self.uploadProfileView.isHidden = true
        self.editTournamentView.isHidden = false
        self.topNavLbl.text = "Edit Tournament"
        self.infoButton.isHidden = false
        self.hypetournamentView.isHidden = false
        self.uploadProfileView.isHidden = true
        self.hypeViewHeightCons.constant = 32
        self.hypeViewTopCons.constant = 24
        self.navigationheghtCons.constant = 0
        self.scrollViewTopCons.constant = 0
        self.navigationView.isHidden = true
        self.scrollViewHieghtCon.constant = self.scrollViewHieghtCon.constant + self.hypeViewHeightCons.constant + 30
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(uploadProfileBtnAction(_ :)))
        self.editTouenamentBG.isUserInteractionEnabled = true
        self.editTouenamentBG.addGestureRecognizer(tapGestureRecognizer)
        //  self.considerSwitchesView.isHidden = true
        // self.switchViewhieghtCons.constant = 0
        //   self.scrollViewHieghtCon.constant = self.scrollViewHieghtCon.constant - self.switchViewhieghtCons.constant
        if let imageKey:String = tournamentList?.imageKay
        {
            let sucess:downloadImageSuccess = {image, imageKey in
                self.editTouenamentBG.image = image
            }
            let failure:downloadImageFailed = {error, responseString in
                print(responseString)
            }
            if !COMMON_SETTING.isEmptySting(imageKey) {
                ServiceCall.sharedInstance.downloadImage(imageKey: imageKey, urlType: RequestedUrlType.DownloadImage, successCall: sucess, falureCall: failure)
            }
        }
        self.tournamentnameLbl.text = self.tournamentList?.tournamentName?.uppercased()
        self.tournamentDescTxtView.text = self.tournamentList?.tournamentDesciption
        self.tournaDicriptionTextView.text = self.tournamentList?.tournamentDesciption
        self.tournaDicriptionTextView.isUserInteractionEnabled = false
        self.tounamentNameTF.text = self.tournamentList?.tournamentName
        
        self.chooseGameTF.text = self.tournamentList?.gameName
        self.gameListObj?.name = self.tournamentList?.gameName
        self.gameListObj?.gameID = self.tournamentList?.gameId
        self.gameListObj?.gameDescripton = self.tournamentList?.gameDiscription
        
        self.slectedGameType = (self.tournamentList?.tournamentTypeName)!
        
        if self.slectedGameType == Single_Elimination {
            self.singleAction(self)
        }
        else if self.slectedGameType == Double_Elimination
        {
            self.doubleAction(self)
        }
        else if self.slectedGameType == Swiss
        {
            self.swissAction(self)
            self.matchPerWinTF.text = self.tournamentList?.rrPtsForMatchWin
            self.matchPerTieTF.text = self.tournamentList?.rrPtsForMatchTie
            self.gameSetWin.text = self.tournamentList?.rrPtsForGameWin
            self.gameSetTieTF.text = self.tournamentList?.rrPtsForGameTie
            self.perByeTf.text = self.tournamentList?.rrPtsForGamebye
        }
        else if self.slectedGameType == Round_Robin
        {
            self.roundRobinAction(self)
            self.rankByTF.text = self.tournamentList?.rankedBy
            if self.rankByTF.text == "CUSTOM" {
                self.matchPerWinTF.text = self.tournamentList?.rrPtsForMatchWin
                self.matchPerTieTF.text = self.tournamentList?.rrPtsForMatchTie
                self.gameSetWin.text = self.tournamentList?.rrPtsForGameWin
                self.gameSetTieTF.text = self.tournamentList?.rrPtsForGameTie
                
                self.scoreView.isHidden = false
                self.scoreViewHightCons.constant = self.scoreViewHieghtConsValue! - 30
                self.perByeTf.isHidden = true
                self.perByeLbl.isHidden = true
            }
        }
        
        // Set the start and end date
        let targetStartDate:String = String.dateStringFromString(sourceString: tournamentList!.startDateTime!,format: "dd-MM-yyyy")
        self.startDate  = (self.tournamentList?.startDateTime)!
        let targetEndDate:String = String.dateStringFromString(sourceString:tournamentList!.endDateTime!,format:"dd-MM-yyyy")
        self.endDate  = (self.tournamentList?.endDateTime)!
        self.startDateTF.text = targetStartDate
        self.endDateTF.text = targetEndDate
        
        // Fill the data
        self.locationTF.text = tournamentList?.venue
        self.tournamentUrl.text = self.tournamentUrl.text?.appending((tournamentList?.webURL)!)
        self.registerSwitch.isOn = (self.tournamentList?.preRegister)!
        self.teamBasedSwitch.isOn = (self.tournamentList?.teamBasedTE)!
        self.considerTeamSwitch.isOn = self.boolValueFromString(value: (self.tournamentList?.considerTeam)!)
        self.considerLocationSwitch.isOn = self.boolValueFromString(value: (self.tournamentList?.considerLocation)!)
        self.scoreSubmissionSwitch.isOn = (self.tournamentList?.allowUserScoreSubmission)!
        
        self.paidTournamentSwitch.isOn = (self.tournamentList?.paidTournament)!
        if self.paidTournamentSwitch.isOn == true {
            self.preRegistraionChargeTF.isUserInteractionEnabled = true
        }
        if self.tournamentList?.hype == true {
            self.hypeBtn.setBackgroundImage(UIImage(named: "hype_completed"), for: UIControlState.normal)
        }
        
        //Configure Staff Array
        self.staffSet = (self.tournamentList?.staff?.allObjects as NSArray?)!
        
        //Set Bottom button title
        self.startEndTournabtn.isHidden = false
        if self.tournamentList?.started == true {
            self.startEndTournabtn.setTitle("End Tournament", for: UIControlState.normal)
        }
        else
        {
            self.startEndTournabtn.setTitle("Start Tournament", for: UIControlState.normal)
        }
        
        // Save the cuurent autoAdvance and Approval time.
        var count = 0
        for item in self.checkInTimeArray {
            let dict = item as! NSDictionary
            let key:[String] = dict.allKeys as! [String]
            let str:String = dict.value(forKey: key.first!) as! String
            if str == self.tournamentList?.checkInTime {
                self.selectedCheckInTimeIndex = count
                self.checkInTimeTF1.text = key.first!
                count = 0
                break
            }
            count += 1
        }
        for item in self.advanceTimerArray {
            let dict = item as! NSDictionary
            let key:[String] = dict.allKeys as! [String]
            let str:String = dict.value(forKey: key.first!) as! String
            if str == self.tournamentList?.autoApprovalTime {
                self.selectedAutoAdvanceTimeIndex = count
                self.advanceTimerTF.text = key.first!
                count = 0
                break
            }
            count += 1
        }
        
        //Save the location
        let ary:[String] = (self.tournamentList?.latLong?.components(separatedBy: ","))!
        if ary.count>1 {
            self.strLattitude = ary[0]
            self.strLaongitude = ary[1]
        }
        
        if !((self.tournamentList?.twitterHandle!)! == "") {
            self.isTwitterLogIn = true
            self.socilIfoImageSelected.isHidden = false
        }else
        {
            self.isTwitterLogIn = false
            self.socilIfoImageSelected.isHidden = true
        }
        
        //Reload Staff Collection
        self.staffCollectionView.reloadData()
    }
    
    func onClickedToolbeltButton(_ sender: Any) {
        self.activeTextField.resignFirstResponder()
    }
    
    func  onClickedDatePicker(_ sender: Any){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if self.activeTextField == self.startDateTF {
            self.startDateTF.text = dateFormatter.string(from: datePicker.date)
        }
        else
        {
            self.endDateTF.text = dateFormatter.string(from: self.datePicker.date)
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone.init(identifier: "GMT")
        
        if activeTextField == self.startDateTF{
            self.startDate = dateFormatter.string(from: datePicker.date)
        }else
        {
            self.endDate = dateFormatter.string(from: datePicker.date)
        }
    }
    
    func getGameList() {
        
        let success: successHandler = {responseObject, responseType in
            
            let responseDict = serviceCall.parseResponse(responseObject: responseObject as Any)
            print(responseDict)
            if let array:NSArray = responseDict.object(forKey: "list") as? NSArray
            {
                GameList.deleteAllFromEntity(inManage: self.manageObjectContext())
                self.gameListArray = GameList.insertGameList(list: array, context: self.manageObjectContext())
            }
        }
        let failure: falureHandler = {error, responseString, responseType in
            
            print(responseString)
        }
        
        // Service call for get user profile data (Hypes, upcomings, person, followers)
        ServiceCall.sharedInstance.sendRequest(parameters: NSMutableDictionary(), urlType: RequestedUrlType.GetGameList, method: "GET", successCall: success, falureCall: failure)
        
    }
    
    func validateInfo() -> Bool
    {
        if self.tounamentNameTF.text == "" || (self.tounamentNameTF.text?.characters.count)!<3{
            self.showAlert(title: kMessage, message: "Tournament name is mandatory with atleast 3 characters")
            return false
        }else if self.chooseGameTF.text == ""
        {
            self.showAlert(title: kMessage, message: "Please Choose game")
            return false
        }else if self.startDateTF.text == "" || self.endDateTF.text == ""
        {
            self.showAlert(title: kMessage, message: "Please Start and End date both")
            return false
        }
        return true
    }
    
    func createTournamentRequst(imageKey:NSString) -> NSMutableDictionary {
        
        let dicCreateTournament = NSMutableDictionary()
        
        if self.slectedGameType != "" {
            let dicGame:NSMutableDictionary = NSMutableDictionary()
            dicGame.setCustomObject(object:self.gameListObj?.name, key: "name")
            dicGame.setCustomObject(object:self.gameListObj?.gameID, key: "gameID")
            dicGame.setCustomObject(object:self.gameListObj?.gameDescripton, key: "description")
            dicCreateTournament.setObject(dicGame, forKey: "game" as NSCopying)
        }else{
            let dicGame:NSMutableDictionary = NSMutableDictionary()
            dicGame.setCustomObject(object:self.chooseGameTF.text, key: "name")
            dicCreateTournament.setObject(dicGame, forKey: "game" as NSCopying)
        }
        
        let dicTournamentType = NSMutableDictionary()
        dicTournamentType.setCustomObject(object:self.slectedGameType, key: "tournamentTypeName")
        dicTournamentType.setCustomObject(object:self.slectedGameType, key: "tournamentTypeDescription")
        
        if self.slectedGameType == "ROUND_ROBIN" {
            dicTournamentType.setCustomObject(object:self.rankByTF.text, key: "rankedBy")
            
            if self.rankByTF.text == "CUSTOM" {
                dicTournamentType.setCustomObject(object:self.matchPerWinTF.text, key: "rrPtsForMatchWin")
                dicTournamentType.setCustomObject(object:self.matchPerTieTF.text, key: "rrPtsForMatchTie")
                dicTournamentType.setCustomObject(object:self.gameSetWin.text, key: "rrPtsForGameWin")
                dicTournamentType.setCustomObject(object:self.gameSetTieTF.text, key: "rrPtsForGameTie")
                
            }
        }else if self.slectedGameType == "SWISS"
        {
            dicTournamentType.setCustomObject(object:self.matchPerWinTF.text, key: "rrPtsForMatchWin")
            dicTournamentType.setCustomObject(object:self.matchPerTieTF.text, key: "rrPtsForMatchTie")
            dicTournamentType.setCustomObject(object:self.gameSetWin.text, key: "rrPtsForGameWin")
            dicTournamentType.setCustomObject(object:self.gameSetTieTF.text, key: "rrPtsForGameTie")
            dicTournamentType.setCustomObject(object:self.perByeTf.text, key: "rrPtsForGameBye")
        }
        dicCreateTournament.setObject(dicTournamentType, forKey: "tournamentType" as NSCopying)
        
        if imageKey != "" {
            dicCreateTournament.setCustomObject(object:imageKey, key: "imageKey")
        }else{
            dicCreateTournament.setValue(imageKey, forKey: "imageKey")
        }
        
        // Start and end date
        dicCreateTournament.setCustomObject(object:self.startDate, key: "startDate")
        dicCreateTournament.setCustomObject(object:self.endDate, key: "endDate")
        
        dicCreateTournament.setCustomObject(object:"false", key: "acceptAttachments")
        dicCreateTournament.setCustomObject(object:"false", key: "sequentialPairings")
        // dicCreateTournament.setCustomObject(object:registerSwitch.isOn as NSNumber, key: "preRegister")
        dicCreateTournament.setCustomObject(object: NSNumber.init(value: self.registerSwitch.isOn) , key: "preRegister")
        dicCreateTournament.setCustomObject(object: NSNumber.init(value: self.discordChannelSwitch.isOn), key: "createDiscordChannel")
        dicCreateTournament.setCustomObject(object: NSNumber.init(value: self.considerLocationSwitch.isOn), key: "considerLocation")
        dicCreateTournament.setCustomObject(object: NSNumber.init(value: self.considerTeamSwitch.isOn), key: "considerTeam")
        dicCreateTournament.setCustomObject(object: NSNumber.init(value: self.teamBasedSwitch.isOn), key: "teamBased")
        dicCreateTournament.setCustomObject(object: NSNumber.init(value: self.scoreSubmissionSwitch.isOn), key: "allowUserScoreSubmission")
        
        dicCreateTournament.setCustomObject(object:"true", key: "openSignup")
        dicCreateTournament.setCustomObject(object:"false", key: "started")
        dicCreateTournament.setCustomObject(object:"false", key: "completed")
        dicCreateTournament.setValue("", forKey: "remarks")
        dicCreateTournament.setCustomObject(object:self.tournamentDescTxtView.text, key: "description")
        dicCreateTournament.setCustomObject(object:self.tounamentNameTF.text, key: "name")
        
        if self.screenType == .EDIT_TOURNAMENT {
            dicCreateTournament.setCustomObject(object: self.tournamentList?.tournamentID, key: "tournamentID")
        }
        
        var str = self.tournamentUrl.text
        str = str?.replacingOccurrences(of: kDefalutUrl, with: "")
        dicCreateTournament.setCustomObject(object:str, key: "webURL")
        dicCreateTournament.setCustomObject(object:self.twitterMesTextView.text, key: "twitterMessage")
        dicCreateTournament.setCustomObject(object:self.locationTF.text, key: "venue")
        dicCreateTournament.setCustomObject(object:COMMON_SETTING.myProfile?.username, key: "createdBy")
        
        let dictCheckIn:NSDictionary = self.checkInTimeArray.object(at: selectedCheckInTimeIndex) as! NSDictionary
        let CheckInkey:String = dictCheckIn.allKeys.first as! String
        dicCreateTournament.setCustomObject(object:dictCheckIn.value(forKey: CheckInkey), key: "checkinTime")
        
        let dictAdvance:NSDictionary = self.advanceTimerArray.object(at: selectedAutoAdvanceTimeIndex) as! NSDictionary
        let advanceKey:String = dictAdvance.allKeys.first as! String
        dicCreateTournament.setCustomObject(object:dictAdvance.value(forKey: advanceKey), key: "autoApprovalTime")
        dicCreateTournament.setCustomObject(object:self.notificationMsgtextView.text, key: "notificationMessage")
        
        if isTwitterLogIn {
            let dict = NSDictionary()
            dicCreateTournament.setCustomObject(object:twitterkey, key: "recordId")
            dicCreateTournament.setObject(dict, forKey: "twitter" as NSCopying)
        }
        
        if !self.strLaongitude.isEmpty || !self.strLaongitude.isEmpty {
            dicCreateTournament.setCustomObject(object:"\(strLattitude),\(strLaongitude)", key: "latLong")
        }
        
        dicCreateTournament.setValue(self.preRegistraionChargeTF.text, forKey: "price")
        dicCreateTournament.setCustomObject(object:NSNumber.init(value: self.paidTournamentSwitch.isOn), key: "paid")
        
        return dicCreateTournament
    }
    
    func sendCreateTournamentRequest(dict:NSMutableDictionary) {
        
        let success:successHandler = {responseObject,requestType in
            // Success call implementation
            let responseDict = serviceCall.parseResponse(responseObject: responseObject as Any)
            print(responseDict)
            self.hideHUD()
            if requestType == RequestedUrlType.CreateNewTournament {
                self.successfullyDone(response: responseDict,actionFor: "CREATE")
            }
            else if requestType == RequestedUrlType.UpdateTournament
            {
                self.successfullyDone(response: responseDict,actionFor: "UPDATE")
            }
        }
        
        //On Failure Call
        let falure:falureHandler = {error,responseMessage,requestType in
            self.hideHUD()
            print(responseMessage)
        }
        
        if self.screenType == Screen_Type.EDIT_TOURNAMENT {
            ServiceCall.sharedInstance.sendRequest(parameters: dict, urlType: RequestedUrlType.UpdateTournament, method: "PUT", successCall: success, falureCall: falure)
        }
        else if self.screenType == Screen_Type.CREATE_TOURNAMENT
        {
            ServiceCall.sharedInstance.sendRequest(parameters: dict, urlType: RequestedUrlType.CreateNewTournament, method: "POST", successCall: success, falureCall: falure)
        }
    }
    
    func successfullyDone(response:NSDictionary, actionFor:String){
        var alertMessage = "Tournament successfully "
        if actionFor == "CREATE" {
            alertMessage.append("Created")
            _ = TETournamentList.insertTournamentDetails(info: response, context: self.manageObjectContext(), isDummy: false, isUserHype: false)
        }
        else if actionFor == "UPDATE" {
            alertMessage.append("Updated")
            _ = TETournamentList.updateTournamentDetails(info: response, tournamentList: self.tournamentList!, context: self.manageObjectContext())
        }
        self.showAlert(title: kMessage, message: alertMessage, actionHandler: {
            self.setUpData()
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    // MARK: - IBactions
    
    @IBAction func uploadProfileBtnAction(_ sender: AnyObject) {
        
        let optionMenu = UIAlertController(title: nil, message: "Add Photo", preferredStyle: .actionSheet)
        
        let addAction = UIAlertAction(title: "Take a photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
            {
                self.imagePicker.delegate = self;
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
            
            self.imagePicker.delegate = self;
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
    
    @IBAction func actionOnTwitter(_ sender: AnyObject) {
        
        self.showAlert(title: "", message: kTwitterHelp)
    }
    
    @IBAction func backButtonAction(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rightBtnAction(_ sender: AnyObject) {
        
        if COMMON_SETTING.isInternetAvailable {
            if self.validateInfo() {
                if isImage {
                    self.showHUD()
                    self.uploadTournamentmage()
                }
                else{
                    self.showHUD()
                    self.sendCreateTournamentRequest(dict: self.createTournamentRequst(imageKey: ""))
                }
            }
        }
        
    }
    
    @IBAction func locationAction(_ sender: AnyObject) {
        
        locationTF.resignFirstResponder()
        self.showHUD()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func singleAction(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            
            self.scoreView.isHidden = true
            self.scoreViewHightCons.constant = 0
            if self.swissBtnOutlet.alpha == 1.0 {
                self.scrollViewHieghtCon.constant = self.scrollViewHieghtCon.constant - self.scoreViewHieghtConsValue!
            }
            self.swissBtnOutlet.alpha = 0.4
            self.singleBtnOutlet.alpha = 1.0
            self.doubleBtnOutlet.alpha = 0.4
            self.roundRobinBtnOutlet.alpha = 0.4
            
            self.rankByTF.isHidden = true
            self.rankByTfHeightCOns.constant = 0
            self.rankByTfTopCons.constant = 0
            self.rankByTFBotttomImg.isHidden = true
            self.rankByTfHeightCOns.constant = 0.0
            
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: {(isCompleted) -> Void in
            // self.isSwipedUp = true
        })
        self.slectedGameType = "SINGLE_ELIMINATION"
        
    }
    
    @IBAction func doubleAction(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            
            self.scoreView.isHidden = true
            self.scoreViewHightCons.constant = 0
            if self.swissBtnOutlet.alpha == 1.0 {
                self.scrollViewHieghtCon.constant = self.scrollViewHieghtCon.constant - self.scoreViewHieghtConsValue!
            }
            self.swissBtnOutlet.alpha = 0.4
            self.singleBtnOutlet.alpha = 0.4
            self.doubleBtnOutlet.alpha = 1.0
            self.roundRobinBtnOutlet.alpha = 0.4
            
            self.rankByTF.isHidden = true
            self.rankByTfHeightCOns.constant = 0
            self.rankByTfTopCons.constant = 0
            self.rankByTFBotttomImg.isHidden = true
            self.rankByTfHeightCOns.constant = 0.0
            
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: {(isCompleted) -> Void in
            // self.isSwipedUp = true
        })
        self.slectedGameType = "DOUBLE_ELIMINATION"
    }
    
    @IBAction func swissAction(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            
            self.scoreView.isHidden = false
            self.scoreViewHightCons.constant = 150
            self.scrollViewHieghtCon.constant = self.scrollViewHieghtCon.constant + self.scoreViewHieghtConsValue!
            self.swissBtnOutlet.alpha = 1.0
            self.singleBtnOutlet.alpha = 0.4
            self.doubleBtnOutlet.alpha = 0.4
            self.roundRobinBtnOutlet.alpha = 0.4
            
            self.rankByTF.isHidden = true
            self.rankByTfHeightCOns.constant = 0
            self.rankByTfTopCons.constant = 0
            self.rankByTFBotttomImg.isHidden = true
            self.rankByTfHeightCOns.constant = 0.0
            self.perByeTf.isHidden = false
            self.perByeLbl.isHidden = false
            
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: {(isCompleted) -> Void in
            // self.isSwipedUp = true
        })
        self.slectedGameType = "SWISS"
    }
    
    @IBAction func roundRobinAction(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            
            self.scoreView.isHidden = true
            self.scoreViewHightCons.constant = 0
            if self.swissBtnOutlet.alpha == 1.0 {
                self.scrollViewHieghtCon.constant = self.scrollViewHieghtCon.constant - self.scoreViewHieghtConsValue!
            }
            self.swissBtnOutlet.alpha = 0.4
            self.singleBtnOutlet.alpha = 0.4
            self.doubleBtnOutlet.alpha = 0.4
            self.roundRobinBtnOutlet.alpha = 1.0
            
            self.rankByTF.isHidden = false
            self.rankByTfHeightCOns.constant = 30
            self.rankByTfTopCons.constant = 15
            self.rankByTFBotttomImg.isHidden = false
            self.rankByTFBtmLineHightCons.constant = 1.0
            self.rankByTF.text = ""
            self.rankByTF.attributedPlaceholder = NSAttributedString(string:"Rank By",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: {(isCompleted) -> Void in
            // self.isSwipedUp = true
        })
        self.slectedGameType = "ROUND_ROBIN"
    }
    
    @IBAction func hypeTournamentBnAction(_ sender: AnyObject) {
        
    }
    
    
    @IBAction func teamBasedSwitchAction(_ sender: AnyObject) {
        
        if self.teamBasedSwitch.isOn {
            self.checkInTimeTF1.isUserInteractionEnabled = false
            self.checkInTimeTF1.alpha = 0.6
            self.scoreSubmissionSwitch.isOn = false
            self.advanceTimerTF.isUserInteractionEnabled = false
            self.advanceTimerTF.alpha = 0.6
        }else
        {
            self.checkInTimeTF1.isUserInteractionEnabled = true
            self.checkInTimeTF1.alpha = 1.0
        }
        
        if self.considerTeamSwitch.isOn
        {
            self.considerTeamSwitch.isOn = false
        }
    }
    
    @IBAction func considerTeamSwichAction(_ sender: AnyObject) {
        if self.teamBasedSwitch.isOn
        {
            self.teamBasedSwitch.isOn = false
        }
    }
    
    @IBAction func scoreSumissionSwitchAction(_ sender: AnyObject) {
        
        if self.scoreSubmissionSwitch.isOn {
            self.advanceTimerTF.isUserInteractionEnabled = true
            self.advanceTimerTF.alpha = 1.0
            self.teamBasedSwitch.isOn = false
            
        }else
        {
            self.advanceTimerTF.isUserInteractionEnabled = false
            self.advanceTimerTF.alpha = 0.6
        }
    }
    
    @IBAction func paidTournamentSwitch(_ sender: AnyObject) {
        if self.paidTournamentSwitch.isOn
        {
            self.preRegistraionChargeTF.isUserInteractionEnabled = true
        }
        else
        {
            self.preRegistraionChargeTF.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func startEndTournaAction(_ sender: Any) {
    }
    
    
    // MARK: - imagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any])
    {
        if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            if self.screenType == Screen_Type.EDIT_TOURNAMENT {
                self.editTouenamentBG.image = pickerImage
                self.isImage = true
            }else{
                self.uploadPhotoBtn.setBackgroundImage(pickerImage, for: UIControlState.normal)
                self.isImage = true
                self.uploadPhotoBtn.layer.masksToBounds = true;
            }
            //isImageAdded = true
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - CollectionView Delegate.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let staffCount:Int = self.staffSet.count {
            return staffCount + 1
        }
        else {
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:StaffCollectionViewCell = self.staffCollectionView.dequeueReusableCell(withReuseIdentifier: "StaffCollectionViewCell", for: indexPath) as! StaffCollectionViewCell
        
        if self.staffSet.count > 0 && self.staffSet.count > indexPath.row{
            
            let staffDict:TEStaffDetail = self.staffSet.object(at: indexPath.row) as! TEStaffDetail
            cell.staffUserName.text = staffDict.name
            cell.staffImage.layer.cornerRadius = cell.staffImage.frame.height/2
            cell.staffImage.clipsToBounds = true
            cell.staffImage.setBackgroundImage(nil, for: UIControlState.normal)
            cell.staffImage.setBackgroundImage(UIImage(named: "UserDefaultImage"), for: UIControlState.normal)
            
            weak var weakCell:StaffCollectionViewCell? = cell
            if let imageKey:String = staffDict.imageKey
            {
                let sucess:downloadImageSuccess = {image, imageKey in
                    weakCell!.staffImage.setBackgroundImage(image, for: UIControlState.normal)
                }
                let failure:downloadImageFailed = {error, responseString in
                    print(responseString)
                }
                if !COMMON_SETTING.isEmptySting(imageKey) {
                    ServiceCall.sharedInstance.downloadImage(imageKey: imageKey, urlType: RequestedUrlType.DownloadImage, successCall: sucess, falureCall: failure)
                }
            }

        }else
        {
            cell.staffImage.setBackgroundImage(UIImage(named: "addMore"), for: UIControlState.normal)
            cell.staffUserName.text = "Add Staff"
        }
        
        return cell
    }
    // MARK: - PickerView Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if self.activeTextField == self.chooseGameTF {
            return gameList.count
        }else if self.activeTextField == self.rankByTF
        {
            return rankByArray.count
        }
        else if self.activeTextField == self.advanceTimerTF
        {
            return advanceTimerArray.count
        }
        else if self.activeTextField == self.checkInTimeTF1
        {
            return checkInTimeArray.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if self.activeTextField == self.chooseGameTF {
            return gameList[row] as? String
        }
        else if self.activeTextField == self.rankByTF
        {
            return rankByArray[row] as? String
        }
        else if self.activeTextField == self.advanceTimerTF
        {
            return advanceTimerArray[row] as? String
        }
            
        else if self.activeTextField == self.checkInTimeTF1
        {
            return checkInTimeArray[row] as? String
        }
        
        return ""
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.activeTextField == self.rankByTF
        {
            if row == rankByArray.count - 1 {
                self.scoreView.isHidden = false
                self.scoreViewHightCons.constant = self.scoreViewHieghtConsValue! - 30
                self.scrollViewHieghtCon.constant = self.scrollViewHieghtCon.constant + self.scoreViewHightCons.constant
                self.perByeTf.isHidden = true
                self.perByeLbl.isHidden = true
            }else
            {
                self.scoreView.isHidden = true
                self.scrollViewHieghtCon.constant = self.scrollViewHieghtCon.constant - self.scoreViewHightCons.constant
                self.scoreViewHightCons.constant = 0
                self.perByeTf.isHidden = false
                self.perByeLbl.isHidden = false
            }
            
            self.rankByTF.text = rankByArray[row] as? String
        }
        else if self.activeTextField == self.advanceTimerTF
        {
            let dict:NSDictionary = advanceTimerArray[row] as! NSDictionary
            self.advanceTimerTF.text = dict.allKeys.first as? String
            self.selectedAutoAdvanceTimeIndex = row
        }
        else if self.activeTextField == self.checkInTimeTF1
        {
            let dict:NSDictionary = checkInTimeArray[row] as! NSDictionary
            self.checkInTimeTF1.text = dict.allKeys.first as? String
            self.selectedCheckInTimeIndex = row
        }
        self.activeTextField.resignFirstResponder()
        // self.pickerView.isHidden = true
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var attributedString = NSAttributedString()
        if self.activeTextField == self.rankByTF
        {
            attributedString = NSAttributedString(string: rankByArray[row] as! String, attributes: [NSForegroundColorAttributeName : UIColor.white])
        }
        else if self.activeTextField == self.advanceTimerTF
        {
            let dict:NSDictionary = advanceTimerArray[row] as! NSDictionary
            
            attributedString = NSAttributedString(string: dict.allKeys.first as! String, attributes: [NSForegroundColorAttributeName : UIColor.white])
        }
            
        else if self.activeTextField == self.checkInTimeTF1
        {
            let dict:NSDictionary = checkInTimeArray[row] as! NSDictionary
            
            attributedString = NSAttributedString(string: dict.allKeys.first as! String, attributes: [NSForegroundColorAttributeName : UIColor.white])
        }
        
        return attributedString
    }
    
    // MARK: - TextView Delegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == twitterMesTextView || textView == notificationMsgtextView{
            
            if textView.text.characters.count > TWITTER_MAX_CHAR {
                self.showAlert(title: kMessage, message: "You have reached max characters limit.")
                return false
            }
        }
        return true
    }
    
    // MARK: - TextFields Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        self.activeTextField = textField
        if self.activeTextField == self.chooseGameTF || self.activeTextField == self.rankByTF || self.activeTextField == self.advanceTimerTF || self.activeTextField == self.checkInTimeTF1{
            self.pickerView.isHidden = false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.chooseGameTF {
            self.chooseGameTableView.isHidden = true
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.tounamentNameTF {
            self.chooseGameTF.becomeFirstResponder()
        }
        else if textField == self.chooseGameTF
        {
            self.chooseGameTF.resignFirstResponder()
        }
        else if textField == self.locationTF
        {
            self.locationTF.resignFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.chooseGameTF {
            if (self.chooseGameTF.text?.characters.count)!>1 {
                let predi = NSPredicate(format: "name contains[c] %@", textField.text!)
                self.gameList =  self.gameListArray.filtered(using: predi) as NSArray
                self.chooseGameTableView.isHidden = false
                self.chooseGameTableView.reloadData()
                self.removeDismisskeyboardTapGesture()
            } else{
                self.chooseGameTableView.isHidden = true
                self.addDismisskeyboardTapGesture()
            }
        }else if textField == self.tounamentNameTF || (textField.text?.characters.count)! > NAME_MAX_CHAR
        {
            self.showAlert(title: kMessage, message: "You have reached max characters limit.")
            return false
        }else if textField == self.tournamentUrl
        {
            if kDefalutUrl.characters.count > range.location  {
                return false
            }
        }
        return true
    }
    
    // MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameList.count
    }
    
    // create a cell for each table view row
    func  tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:GameListTableViewCell = chooseGameTableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameListTableViewCell
        let dict:GameList = self.gameList[indexPath.row] as! GameList
        cell.gameLbl.text = dict.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        gameListObj = self.gameList[indexPath.row] as? GameList
        self.chooseGameTF.text = gameListObj?.name
        self.chooseGameTableView.isHidden = true
        self.addDismisskeyboardTapGesture()
    }
    
    //MARK:- Social Login response
    func onLogInSuccess(_ userInfo: NSDictionary) -> Void {
        
        isTwitterLogIn = true
        self.socilIfoImageSelected.isHidden = false
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
        
        
        self.strLattitude = "\(userLocation.coordinate.latitude)"
        self.strLaongitude = "\(userLocation.coordinate.longitude)"
        
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
                self.locationTF.text = addressString
                self.hideHUD()
            }
            
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error while updating location " + error.localizedDescription)
    }
    
    // MARK: - Upload Image
    
    func uploadTournamentmage() -> Void {
        let success:uploadImageSuccess = {imageKey in
            // Success call implementation
            print(imageKey)
            self.tournamentImageKey = imageKey
            let dict:NSMutableDictionary = self.createTournamentRequst(imageKey: self.tournamentImageKey as NSString)
            self.sendCreateTournamentRequest(dict: dict)
        }
        
        //On Falure Call
        let falure:uploadImageFailed = {error,responseMessage in
            
            // Falure call implementation
            self.hideHUD()
            self.showAlert(title: kError, message: "Image not uploaded.")
            print(responseMessage)
        }
        
        if self.screenType == Screen_Type.EDIT_TOURNAMENT {
            ServiceCall.sharedInstance.uploadImage(image: self.editTouenamentBG.image, urlType: RequestedUrlType.UploadImage, successCall: success, falureCall: falure)
        }
        else
        {
            ServiceCall.sharedInstance.uploadImage(image: self.uploadPhotoBtn.currentBackgroundImage, urlType: RequestedUrlType.UploadImage, successCall: success, falureCall: falure)
        }
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
