//
//  Constant.swift
//  Person
//
//  Created by Louie Je Decatoria on 08/11/2017.
//  Copyright © 2017 Louie Je Decatoria. All rights reserved.
//

import Foundation
import UIKit

#if PREVIEW
let PREVIEW_BUILD = true
#else
let PREVIEW_BUILD = false
#endif

#if DEBUG
let DEBUG_BUILD = true
#else
let DEBUG_BUILD = true
#endif

#if STAGING
let STAGING_BUILD = true
#else
let STAGING_BUILD = false
#endif

#if PRODUCTION
let PRODUCTION_BUILD = true
#else
let PRODUCTION_BUILD = true
#endif

struct PersistenceKeys {
    static let DEVICE_TOKEN = "DeviceToken"
}

struct APIDefaults {
    static let mServerURL           = "https://randomuser.me/"
}

struct System {
    static let BUNDLE_PATH = Bundle.main.resourcePath!
    static let DOCUMENTS_PATH = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    static let APP_DELEGATE = UIApplication.shared.delegate as? AppDelegate
    static let WINDOW = APP_DELEGATE?.window
    static let CURRENT_DEVICE = UIDevice().model
    static let IOS_VERSION = NSString(string: UIDevice.current.systemVersion).doubleValue
    static let IOS8 = IOS_VERSION >= 8
    static let IOS7 = IOS_VERSION >= 7 && IOS_VERSION < 8
    static let DATE_TIME_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
}

func debugLog(logMessage: String, functionName: String = #function, className: String = #file) {
    if (DEBUG_BUILD) {
        if (functionName == "") {
            print("\(logMessage)")
        } else {
            let fileName = ((className as NSString).lastPathComponent as NSString).deletingPathExtension
            print("[\(fileName)] \(functionName): \(logMessage)")
        }
    }
}
