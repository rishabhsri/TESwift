//
//  Constant.swift
//  TESwift
//
//  Created by V Group Inc. on 12/9/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import Foundation


//MARK: - Screens size---

let IS_IPHONE = (UI_USER_INTERFACE_IDIOM() == .phone)

let SCREEN_WIDTH = (UIScreen.main.bounds.size.width)

let SCREEN_HEIGHT = (UIScreen.main.bounds.size.height)

let SCREEN_MAX_LENGTH = (max(SCREEN_WIDTH, SCREEN_HEIGHT))

let IS_IPHONE_5 = (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)


//MARK: - Error messages

let UserName_Pwd_ErrorMsg = "Username or password either null or consist blanks."
