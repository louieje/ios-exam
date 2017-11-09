//
//  GlobalManager.swift
//  Person
//
//  Created by Louie Je Decatoria on 08/11/2017.
//  Copyright © 2017 Louie Je Decatoria. All rights reserved.
//

import Foundation

class GlobalManager: NSObject {
    
    deinit {
        // perform the deinitialization
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Shared Instance
    static let sharedInstance : GlobalManager = {
        let instance = GlobalManager()
        return instance
    }()
    
    class func setUserCountry(country: String!) {
        PersistenceManager.sharedInstance.storeSerializedObject(object: country as AnyObject!, key: "UserCountry")
    }
    
    class func getUserCountry() -> String? {
        guard let UserCountry = PersistenceManager.sharedInstance.loadDeserializedObjectForKey(key: "UserCountry") else {
            return nil
        }
        return UserCountry as? String
    }
    
    // MARK: - Reachability
    static func isNetworkReachable() -> Bool {
        let reachability = Reachability()!
        if reachability.isReachable {
            return true
        }
        return false
    }
}

