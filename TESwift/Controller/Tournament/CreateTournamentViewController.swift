//
//  CreateTournamentViewController.swift
//  TESwift
//
//  Created by Apple on 27/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class CreateTournamentViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

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
    
    @IBOutlet weak var tounamentNameTF: UITextField!
    @IBOutlet weak var chooseGameTF: UITextField!
    @IBOutlet weak var uploadPhotoBtn: UIButton!
    
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
    
    let imagePicker = UIImagePickerController()
    var pickerView = UIPickerView()
    var gameList = NSMutableArray()
    var rankByArray = NSMutableArray()
    var advanceTimerArray = NSMutableArray()
    var checkInTimeArray = NSMutableArray()
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setStyleGuide()
        self.setUpPickerView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utility
    
    func setUpPickerView() {
        pickerView = UIPickerView.init(frame: CGRect(x: 0, y: 467, width: 375, height: 200))
        pickerView.backgroundColor = UIColor.black
        pickerView.delegate = self
        self.chooseGameTF.inputView = pickerView
        self.rankByTF.inputView = pickerView
        self.advanceTimerTF.inputView = pickerView
        self.checkInTimeTF1.inputView = pickerView
        rankByArray = ["Match Wins", "Game Wins", "Points Scored", "Points Difference", "Custom"]
        gameList = ["Cricket", "Football", "Footsal", "Badminton", "Squash", "Rugby"]
        advanceTimerArray = ["None", "5 Min", "10 Min", "15 Min", "30 Min", "1 hour"]
        checkInTimeArray = ["Off", "15 min", "30 min", "1 hour", "2 hours", "3 hours", "6 hours", "1 day"]
    }
    
    func setStyleGuide() {
        
        self.addDismisskeyboardTapGesture()
        self.scoreViewHightCons.constant = 0.0
        self.rankByTfHeightCOns.constant = 0.0


        tounamentNameTF.attributedPlaceholder = NSAttributedString(string:"Tournament Name",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        chooseGameTF.attributedPlaceholder = NSAttributedString(string:"-Choose Game-",
                                                                   attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        rankByTF.attributedPlaceholder = NSAttributedString(string:"Rank By",
                                                                   attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        endDateTF.attributedPlaceholder = NSAttributedString(string:"End Date",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        locationTF.attributedPlaceholder = NSAttributedString(string:"Location",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        preRegistraionChargeTF.attributedPlaceholder = NSAttributedString(string:"0.00",
                                                              attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
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
    
    @IBAction func backButtonAction(_ sender: AnyObject) {
        
    }
    
    @IBAction func rightBtnAction(_ sender: AnyObject) {
        
    }

    @IBAction func locationAction(_ sender: AnyObject) {
    }
    
    @IBAction func singleAction(_ sender: AnyObject) {
    }
    
    @IBAction func doubleAction(_ sender: AnyObject) {
    }
    
    @IBAction func swissAction(_ sender: AnyObject) {
    }
    
    @IBAction func roundRobinAction(_ sender: AnyObject) {
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
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
