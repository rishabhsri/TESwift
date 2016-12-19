//
//  BaseViewController.swift
//  TESwift
//
//  Created by Apple on 08/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UITableViewDelegate,UITextFieldDelegate{
    
    var context:NSManagedObjectContext? = nil
    var dateFormatter:DateFormatter? = nil
    
    
    //MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    func manageObjectContext() -> NSManagedObjectContext {
        
        if context == nil {
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            context = appDelegate.persistentContainer.viewContext
        }
        return context!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Utility methods
    func addDismisskeyboardTapGesture()->Void{
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
        
    }
    
    func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    func showAlert(title: String, message: String,tag: NSInteger) -> Void {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in print("Youve pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showNoInternetAlert() -> Void {
        
        let alertController = UIAlertController(title: kError, message: kNoInternetConnect, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in print("Youve pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func parseResponse(responseObject:Any) -> NSDictionary {
        
        if let responseDict:NSDictionary = responseObject as? NSDictionary {
            return responseDict;
        }else if let responseString:String = responseObject as? String
        {
            return responseString.convertToDictionary(text: responseString)
        }
        return NSDictionary()
    }
    
    func setBlurImage(imageView:UIImageView) {
        
        let blurRadius:CGFloat = 80;
        let saturationDeltaFactor:CGFloat = 1.3;
        let tintColor:UIColor? = nil
        var tempimage:UIImage = imageView.image!
        
        let size:CGSize = CGSize(width:200, height:150)
        tempimage = tempimage.withImage(tempimage, scaledTo: size)
        let image:UIImage = UIImage.ty_imageByApplyingBlur(to: tempimage, withRadius: blurRadius, tintColor: tintColor, saturationDeltaFactor: saturationDeltaFactor, maskImage: nil)!
        imageView.image = image
        imageView.layer.backgroundColor = UIColor.black.cgColor
        imageView.layer.opacity = 0.45
    }
    
    func getLocaleDateFromString(dateString:String) -> Date {
        
        if self.dateFormatter == nil {
            self.dateFormatter = DateFormatter()
        }
        
        self.dateFormatter?.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        self.dateFormatter?.timeZone = NSTimeZone(name:"GMT") as TimeZone!
        var finalDate:Date? = self.dateFormatter?.date(from: dateString)
        if finalDate == nil {
            self.dateFormatter?.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            self.dateFormatter?.timeZone = NSTimeZone(name:"GMT") as TimeZone!
            finalDate = self.dateFormatter?.date(from: dateString)
        }
        return finalDate!
    }
    
    func getLocaleDateStringFromString(dateString:String) -> String {
        
        let receivedDate:Date = self.getLocaleDateFromString(dateString: dateString)
        let formatString:String = DateFormatter.dateFormat(fromTemplate: "ddMMy", options: 0, locale: NSLocale.current)!
        
        self.dateFormatter?.dateFormat = formatString
        self.dateFormatter?.locale = NSLocale.current
        self.dateFormatter?.timeZone = NSTimeZone.system
        
        if  let dateString:String = self.dateFormatter?.string(from: receivedDate)
        {
            return dateString
        }else
        {
            return " "
        }
    }
    
    func getFormattedDateString(info:NSDictionary,indexPath:IndexPath,format:String) -> String {
        
        var startKeyName:String = "startDateTime"
        var endKeyName:String = "endDateTime"
        
        
        if commonSetting.isEmptySting(info.stringValueForKey(key: startKeyName)) {
            startKeyName = "startDate"
        }
        if commonSetting.isEmptySting(info.stringValueForKey(key: endKeyName)) {
            endKeyName = "endDate"
        }
        
        let targetStartDate:String = String.dateStringFromString(sourceString: info.stringValueForKey(key: startKeyName),format: format)
        let targetEndDate:String = String.dateStringFromString(sourceString:info.stringValueForKey(key: startKeyName),format:format)
        if targetEndDate == targetStartDate
        {
            return targetStartDate
        }else
        {
            return String.init(format: "%@ - %@", targetStartDate,targetEndDate)
        }
    }
    
    // MARK: - TextFields Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTage=textField.tag+1;
        // Try to find next responder
        let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder!
        
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        return false // We do not want UITextField to insert line-breaks.
    }
    
    //MARK:- HUD
    func showHUD() {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
    }
    
    func hideHUD(){
        PKHUD.sharedHUD.hide()
    }
}
