//
//  CreateTournamentViewController.swift
//  TESwift
//
//  Created by Apple on 27/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit
import CoreLocation

class CreateTournamentViewController: SocialConnectViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource{

    // Navigation Outlet
    @IBOutlet weak var topNavLbl: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    //edit Tounrnament View
    @IBOutlet weak var editTournamentView: UIView!
    @IBOutlet weak var staffCollectionView: UICollectionView!
    @IBOutlet weak var tournaDicriptionTextView: UITextView!
    @IBOutlet weak var editTouenamentBG: UIImageView!
    
    @IBOutlet weak var uploadProfileView: UIView!
    
    @IBOutlet weak var singleBtnOutlet: UIButton!
    @IBOutlet weak var doubleBtnOutlet: UIButton!
    @IBOutlet weak var swissBtnOutlet: UIButton!
    @IBOutlet weak var roundRobinBtnOutlet: UIButton!
    @IBOutlet weak var rankByTFBotttomImg: UIImageView!
    
    @IBOutlet weak var tounamentNameTF: UITextField!
    @IBOutlet weak var chooseGameTF: UITextField!
    @IBOutlet weak var uploadPhotoBtn: UIButton!
    @IBOutlet weak var chooseGameTableView: UITableView!
    
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var matchPerWinTF: UITextField!
    @IBOutlet weak var matchPerTieTF: UITextField!
    @IBOutlet weak var gameSetWin: UITextField!
    @IBOutlet weak var gameSetTieTF: UITextField!
    @IBOutlet weak var perByeTf: UITextField!
    
    
    @IBOutlet weak var rankByTF: UITextField!
    @IBOutlet weak var tournamentUrl: UITextField!
    @IBOutlet weak var startDateTF: UITextField!
    @IBOutlet weak var endDateTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    
    @IBOutlet weak var tournamentDescTxtView: UITextView!
    @IBOutlet weak var twitterMesTextView: UITextView!
    @IBOutlet weak var notificationMsgtextView: UITextView!
    
    
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
    @IBOutlet weak var checkInTimeTF1: UITextField!
    
    // Constraints Outlet
    @IBOutlet weak var scoreViewHightCons: NSLayoutConstraint!
    @IBOutlet weak var rankByTfHeightCOns: NSLayoutConstraint!
    @IBOutlet weak var rankByTFBtmLineHightCons: NSLayoutConstraint!
    
    let imagePicker = UIImagePickerController()
    var pickerView = UIPickerView()
    var gameList = NSArray()
    var rankByArray = NSMutableArray()
    var advanceTimerArray = NSMutableArray()
    var checkInTimeArray = NSMutableArray()
    var activeTextField = UITextField()
    var locationManager = CLLocationManager()
    var toolBar = UIToolbar()
    var gameListArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setStyleGuide()
        self.setUpLayout()
        self.setUpPickerView()
        self.getGameList()
        // Do any additional setup after loading the view.
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
        advanceTimerArray = ["None", "5 Min", "10 Min", "15 Min", "30 Min", "1 hour"]
        checkInTimeArray = ["Off", "15 min", "30 min", "1 hour", "2 hours", "3 hours", "6 hours", "1 day"]
    }
    
    func setStyleGuide() {
        
        self.chooseGameTableView.isHidden = true
        
        tounamentNameTF.attributedPlaceholder = NSAttributedString(string:"Tournament Name",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        chooseGameTF.attributedPlaceholder = NSAttributedString(string:"-Choose Game-",
                                                                   attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        endDateTF.attributedPlaceholder = NSAttributedString(string:"End Date",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        locationTF.attributedPlaceholder = NSAttributedString(string:"Location",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        preRegistraionChargeTF.attributedPlaceholder = NSAttributedString(string:"0.00",
                                                              attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
    }
    
    func onClickedToolbeltButton(_ sender: Any) {
        self.activeTextField.resignFirstResponder()
    }
    

    func getGameList() {
        
        let success: successHandler = {responseObject, responseType in
            
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            print(responseDict)
            if let array:NSArray = responseDict.object(forKey: "list") as? NSArray
            {
              self.gameListArray = array
            }
        }
        let failure: falureHandler = {error, responseString, responseType in
            
            print(responseString)
        }
        
        // Service call for get user profile data (Hypes, upcomings, person, followers)
        ServiceCall.sharedInstance.sendRequest(parameters: NSMutableDictionary(), urlType: RequestedUrlType.GetGameList, method: "GET", successCall: success, falureCall: failure)

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
            self.swissBtnOutlet.alpha = 0.4
            self.singleBtnOutlet.alpha = 1.0
            self.doubleBtnOutlet.alpha = 0.4
            self.roundRobinBtnOutlet.alpha = 0.4
            
            self.rankByTF.isHidden = true
            self.rankByTfHeightCOns.constant = 0
            self.rankByTFBotttomImg.isHidden = true
            self.rankByTfHeightCOns.constant = 0.0
            
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            }, completion: {(isCompleted) -> Void in
                // self.isSwipedUp = true
        })

    }
    
    @IBAction func doubleAction(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            
            self.scoreView.isHidden = true
            self.scoreViewHightCons.constant = 0
            self.swissBtnOutlet.alpha = 0.4
            self.singleBtnOutlet.alpha = 0.4
            self.doubleBtnOutlet.alpha = 1.0
            self.roundRobinBtnOutlet.alpha = 0.4
            
            self.rankByTF.isHidden = true
            self.rankByTfHeightCOns.constant = 0
            self.rankByTFBotttomImg.isHidden = true
            self.rankByTfHeightCOns.constant = 0.0
            
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            }, completion: {(isCompleted) -> Void in
                // self.isSwipedUp = true
        })

    }
    
    @IBAction func swissAction(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            
            self.scoreView.isHidden = false
            self.scoreViewHightCons.constant = 150
            self.swissBtnOutlet.alpha = 1.0
            self.singleBtnOutlet.alpha = 0.4
            self.doubleBtnOutlet.alpha = 0.4
            self.roundRobinBtnOutlet.alpha = 0.4

            self.rankByTF.isHidden = true
            self.rankByTfHeightCOns.constant = 0
            self.rankByTFBotttomImg.isHidden = true
            self.rankByTfHeightCOns.constant = 0.0

            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            }, completion: {(isCompleted) -> Void in
               // self.isSwipedUp = true
        })

    }
    
    @IBAction func roundRobinAction(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            
            self.scoreView.isHidden = true
            self.scoreViewHightCons.constant = 0
            self.swissBtnOutlet.alpha = 0.4
            self.singleBtnOutlet.alpha = 0.4
            self.doubleBtnOutlet.alpha = 0.4
            self.roundRobinBtnOutlet.alpha = 1.0
            
            self.rankByTF.isHidden = false
            self.rankByTfHeightCOns.constant = 30
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

    }

    // MARK: - imagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any])
    {
        if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.uploadPhotoBtn.setBackgroundImage(pickerImage, for: UIControlState.normal)
            self.uploadPhotoBtn.layer.masksToBounds = true;
            //isImageAdded = true
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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
        
        if self.activeTextField == self.chooseGameTF {
            self.chooseGameTF.text = gameList[row] as? String
        }
        else if self.activeTextField == self.rankByTF
        {
            self.rankByTF.text = rankByArray[row] as? String
        }
        else if self.activeTextField == self.advanceTimerTF
        {
            self.advanceTimerTF.text = advanceTimerArray[row] as? String
        }
        else if self.activeTextField == self.checkInTimeTF1
        {
            self.checkInTimeTF1.text = checkInTimeArray[row] as? String
        }
        self.activeTextField.resignFirstResponder()
       // self.pickerView.isHidden = true
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var attributedString = NSAttributedString()
        if self.activeTextField == self.chooseGameTF {
             attributedString = NSAttributedString(string: gameList[row] as! String, attributes: [NSForegroundColorAttributeName : UIColor.white])
        }
        else if self.activeTextField == self.rankByTF
        {
             attributedString = NSAttributedString(string: rankByArray[row] as! String, attributes: [NSForegroundColorAttributeName : UIColor.white])
        }
        else if self.activeTextField == self.advanceTimerTF
        {
            attributedString = NSAttributedString(string: advanceTimerArray[row] as! String, attributes: [NSForegroundColorAttributeName : UIColor.white])
        }

        else if self.activeTextField == self.checkInTimeTF1
        {
            attributedString = NSAttributedString(string: checkInTimeArray[row] as! String, attributes: [NSForegroundColorAttributeName : UIColor.white])
        }

        return attributedString
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
        let dict:NSDictionary = self.gameList[indexPath.row] as! NSDictionary
        cell.gameLbl.text = dict.stringValueForKey(key: "name")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict:NSDictionary = self.gameList[indexPath.row] as! NSDictionary
        self.chooseGameTF.text = dict.stringValueForKey(key: "name")
        self.chooseGameTableView.isHidden = true
        self.addDismisskeyboardTapGesture()
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
                self.locationTF.text = addressString
                self.hideHUD()
            }
            
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error while updating location " + error.localizedDescription)
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
