//
//  LogInViewController.swift
//  TESwift
//
//  Created by Apple on 09/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class LogInViewController: BaseViewController , UITextFieldDelegate {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    @IBAction func loginAction(_ sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addDismisskeyboardTapGesture()
        self.styleGuide()

        // Do any additional setup after loading the view.
    }

    
    func styleGuide()->Void {
    
        txtUsername.attributedPlaceholder = NSAttributedString(string:"Username or Email-Id",
                                                                attributes:[NSForegroundColorAttributeName: UIColor.lightGray,])
        txtPassword.attributedPlaceholder = NSAttributedString(string:"Password",
                                                                attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
    }
    
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
