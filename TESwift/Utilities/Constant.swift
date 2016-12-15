//
//  Constant.swift
//  TESwift
//
//  Created by V Group Inc. on 12/9/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import Foundation


enum SocialConnectType{
   case FACEBOOK
   case GOOGLEPLUS
   case TWITCH
}

//MARK: - Screens size---

let IS_IPHONE = (UI_USER_INTERFACE_IDIOM() == .phone)

let IS_IPAD = (UI_USER_INTERFACE_IDIOM() == .pad)

let SCREEN_WIDTH = (UIScreen.main.bounds.size.width)

let SCREEN_HEIGHT = (UIScreen.main.bounds.size.height)

let SCREEN_MAX_LENGTH = (max(SCREEN_WIDTH, SCREEN_HEIGHT))

let IS_IPHONE_5 = (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)

let kPasswordRegex = "^.{6,}$"

let ProfileImageBorder:CGFloat = 3.5

let commonSetting:CommonSetting = CommonSetting.sharedInstance

//MARK: - Error messages

let UserName_Pwd_ErrorMsg = "Username or password either null or consist blanks."

//MARK:- Sign Up Messages
let kEnterConfirmPassword = "Please enter Confirm Password."
let kEnterLocation = "Please enter a location."
let kEnterEmail = "Please enter a valid email."
let kEnterSex = "Please enter a gender."
let kEnterAge = "Please enter age."
let kEnterValidsAge = "Please select valid age."
let kEnterValidsGender = "Please select valid gender."
let kUserExists = "The Username already exists."
let kEnterValidPhone = "Please enter a valid phone number."

let kEnterUsername = "Please enter a username, without spaces."
let kEnterDisplayname = "Please enter a display Name."
let kEnterPassword = "Please enter a password."
let kInvalidUsernamePassword = "Username or Password is incorrect."
let kUnableToLogin = "Unable to login\nPlease try later"
let kOfflineIncorrectUsernamePassword = "Connect to internet for login."
let kInvalidEmail = "Please enter valid email"
let kPasswordRulesMessage  = "Password must contain at least 6 characters"
let kEnterSamePassword = "Password and Confirm Password should be the same"

//MARK:- Titles

let kOK = "OK"
let kError = "Error"
let kWarning = "Warning"
let kCancel = "Cancel"
let kMessage = "Message"
let kYes = "Yes"
let kNo = "No"


//Import class

//import PKHUD


