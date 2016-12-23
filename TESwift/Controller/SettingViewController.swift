//
//  SettingViewController.swift
//  TESwift
//
//  Created by V Group Inc. on 12/22/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit
import CoreLocation

class SettingViewController: BaseViewController,CLLocationManagerDelegate, UIPickerViewDelegate {
   
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var lblNotifySettingTitle: UILabel!
    @IBOutlet weak var lblSocialConnectTitle: UILabel!
    @IBOutlet weak var lblTeamPicturetitle: UILabel!
    @IBOutlet weak var lblBrainTreeAccTitle: UIButton!
    @IBOutlet weak var lblSubscriber: UILabel!
    @IBOutlet weak var lblTermsConditionTitle: UIButton!
    @IBOutlet weak var lblPrivacyPolicyTitle: UIButton!
    
    var locationManager = CLLocationManager()
    var aryAge:NSMutableArray = NSMutableArray()
    var aryGender:NSMutableArray = NSMutableArray()
    
    
    @IBAction func getUserLocation(_ sender: AnyObject) {
        self.showHUD()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }
    
    @IBAction func btnDoneClicked(_ sender: AnyObject) {
        if isValid() {
          
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.styleGuide()
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
        
        if (commonSetting.isEmptyStingOrWithBlankSpace(self.txtName.text!))
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
        
        
        let defaultButton = UIBarButtonItem(title: "Default", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SettingViewController.tappedToolBarBtn))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(SettingViewController.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Futura", size: 12)
        
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.white
        
        label.text = "Pick one number"
        
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        self.txtAge.inputAccessoryView = toolBar

    }
    
    func configurePickerViewDta() -> NSArray {
        if self.aryAge == nil {
            self.aryAge = NSMutableArray()
            for i in 10..<100 {
                self.aryAge.add(i)
            }
        }
        return self.aryAge
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
        return self.aryAge[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtAge.text = self.aryAge[row] as? String

    }



}
