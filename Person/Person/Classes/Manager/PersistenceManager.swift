//
//  PersistenceManager.swift
//  Person
//
//  Created by Louie Je Decatoria on 08/11/2017.
//  Copyright © 2017 Louie Je Decatoria. All rights reserved.
//

import Foundation

let PERSISTENCE_FILENAME = "PersistedData.data"
let PERSISTENCE_ROOT_INDEX = "root_index"

class PersistenceManager: NSObject {
    
    var isActive: Bool = true
    
    //MARK: Shared Instance
    static let sharedInstance : PersistenceManager = {
        let instance = PersistenceManager()
        return instance
    }()
    
    override init() {
        super.init()
        
        self.isActive = true
        
        let path = self.filePath()
        let fileManager = FileManager.default
        if (fileManager.fileExists(atPath: path!) == false) {
            let root = NSMutableDictionary()
            root.setObject(NSMutableDictionary(), forKey: PERSISTENCE_ROOT_INDEX as NSCopying)
            if (NSKeyedArchiver.archiveRootObject(root, toFile: path!) == false) {
                print("PersistenceManager failed to save \(PERSISTENCE_ROOT_INDEX)")
            }
        }
    }
    
    func filePath() -> String! {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = documentsPath as NSString
        
        return path.appendingPathComponent(PERSISTENCE_FILENAME)
    }
    
    func saveData(data: NSMutableDictionary) {
        let path = self.filePath()
        let root = NSMutableDictionary()
        root.setObject(data, forKey: PERSISTENCE_ROOT_INDEX as NSCopying)
        if (NSKeyedArchiver.archiveRootObject(root, toFile: path!) == false) {
            print("PersistenceManager failed to save \(PERSISTENCE_ROOT_INDEX)")
        }
    }
    
    func loadData() -> NSMutableDictionary {
        let path = self.filePath()
        let root = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! NSMutableDictionary
        let data = root.object(forKey: PERSISTENCE_ROOT_INDEX) as! NSMutableDictionary
        return data
    }
    
    func storeSerializedObject(object: AnyObject!, key: String!) {
        let data = self.loadData()
        data.setObject(object, forKey: key as NSCopying)
        self.saveData(data: data)
    }
    
    func loadDeserializedObjectForKey(key: String!) -> NSObject? {
        let data = self.loadData()
        return data.object(forKey: key) as? NSObject
    }
    
    func clear() {
        let rootData = NSMutableDictionary()
        self.saveData(data: rootData)
    }
}
