//
//  ConfigManager.swift
//  Person
//
//  Created by Louie Je Decatoria on 08/11/2017.
//  Copyright © 2017 Louie Je Decatoria. All rights reserved.
//

import Foundation

public enum Deployment: String {
    case Development = "development"
    case Demo = "demo"
    case QA = "qa"
}

class ConfigManager: NSObject {
    var baseUrl: String?
    
    var deployment: String?
    
    var DonorBuild: Bool?
    var RequestorBuild: Bool?
    
    deinit {
        // perform the deinitialization
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Shared Instance
    static let sharedInstance : ConfigManager = {
        let instance = ConfigManager()
        instance.configure()
        return instance
    }()
    
    func configure() {
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        
        if let dict = myDict {
            self.baseUrl = dict["BASE_URL"] as? String
        }
        
        if let dict = myDict {
            self.deployment = dict["Deployment"] as? String
        }
        
        if let dict = myDict {
            self.DonorBuild = dict["DonorBuild"] as? Bool
        }
        if let dict = myDict {
            self.RequestorBuild = dict["RequestorBuild"] as? Bool
        }
    }
}
