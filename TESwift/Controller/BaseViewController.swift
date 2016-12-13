//
//  BaseViewController.swift
//  TESwift
//
//  Created by Apple on 08/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UITextFieldDelegate {
    
    var userDataDict:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    func addDismisskeyboardTapGesture()->Void{
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
        
    }
    
    func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    func isEmptySting(_ text: String) -> Bool {
        
        if text.isEmpty{
            return true
        }
        if (text.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines) != nil) {
            return true
        }
        return false
    }
    
    func showAlert(title: String, message: String,tag: NSInteger) -> Void {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
    
}
