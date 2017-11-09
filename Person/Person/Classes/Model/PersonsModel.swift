//
//  PersonsModel.swift
//  Person
//
//  Created by Louie Je Decatoria on 08/11/2017.
//  Copyright © 2017 Louie Je Decatoria. All rights reserved.
//

import Foundation

class PersonsModel: NSObject, NSCoding, ResponseObjectSerializable {
    
    var idValue: String?
    var nameTitle: String?
    var nameFirst: String?
    var nameLast: String?
    var locationStreet: String?
    var locationCity: String?
    var locationState: String?
    var locationPostCode: String?
    var email: String?
    var picture: String?
    var gender: String?
    var dob: String?
    var cell: String?
    
    override init() {
        self.idValue = ""
        self.nameTitle = ""
        self.nameFirst = ""
        self.nameLast = ""
        self.locationStreet = ""
        self.locationCity = ""
        self.locationState = ""
        self.locationPostCode = ""
        self.email = ""
        self.picture = ""
        self.gender = ""
        self.dob = ""
        self.cell = ""
    }
    
    @objc required init?(data: AnyObject) {
        super.init()
        
        var key = "name"
        if (isValidKeypath(data: data, keypath: key)) {
            let nameData = data.value(forKeyPath: key) as AnyObject
            var nameKey = "title"
            if (isValidKeypath(data: nameData, keypath: nameKey)) {
                self.nameTitle = nameData.value(forKeyPath: nameKey) as? String
            }
            
            nameKey = "first"
            if (isValidKeypath(data: nameData, keypath: nameKey)) {
                self.nameFirst = nameData.value(forKeyPath: nameKey) as? String
            }
            
            nameKey = "last"
            if (isValidKeypath(data: nameData, keypath: nameKey)) {
                self.nameLast = nameData.value(forKeyPath: nameKey) as? String
            }
        }
        
        key = "location"
        if (isValidKeypath(data: data, keypath: key)) {
            let locationData = data.value(forKeyPath: key) as AnyObject
            var locationKey = "street"
            if (isValidKeypath(data: locationData, keypath: locationKey)) {
                self.locationStreet = locationData.value(forKeyPath: locationKey) as? String
            }
            
            locationKey = "city"
            if (isValidKeypath(data: locationData, keypath: locationKey)) {
                self.locationCity = locationData.value(forKeyPath: locationKey) as? String
            }
            
            locationKey = "state"
            if (isValidKeypath(data: locationData, keypath: locationKey)) {
                self.locationState = locationData.value(forKeyPath: locationKey) as? String
            }
            
            locationKey = "postcode"
            if (isValidKeypath(data: locationData, keypath: locationKey)) {
                if let postcode = locationData.value(forKeyPath: locationKey) as? String {
                    self.locationPostCode = postcode
                } else {
                    let postcode = "\(locationData.value(forKeyPath: locationKey)!)"
                    self.locationPostCode = postcode
                }
                
            }
        }
        
        key = "gender"
        if (isValidKeypath(data: data, keypath: key)) {
            self.gender = data.value(forKeyPath: key) as? String
        }
        
        key = "email"
        if (isValidKeypath(data: data, keypath: key)) {
            self.email = data.value(forKeyPath: key) as? String
        }
        
        key = "picture"
        if (isValidKeypath(data: data, keypath: key)) {
            let pictureData = data.value(forKeyPath: key) as AnyObject
            let pictureKey = "large"
            if (isValidKeypath(data: pictureData, keypath: pictureKey)) {
                self.picture = pictureData.value(forKeyPath: pictureKey) as? String
            }
        }
        
        key = "id"
        if (isValidKeypath(data: data, keypath: key)) {
            let idData = data.value(forKeyPath: key) as AnyObject
            let idKey = "value"
            if (isValidKeypath(data: idData, keypath: idKey)) {
                self.idValue = idData.value(forKeyPath: idKey) as? String
            }
        }
        
        key = "dob"
        if (isValidKeypath(data: data, keypath: key)) {
            self.dob = data.value(forKeyPath: key) as? String
        }
        
        key = "cell"
        if (isValidKeypath(data: data, keypath: key)) {
            self.cell = data.value(forKeyPath: key) as? String
        }
    }
    
    init(idValue: String?, nameTitle: String?, nameFirst: String?, nameLast: String?, locationStreet: String?, locationCity: String?, locationState: String?, locationPostCode: String?, email: String?, picture: String?, gender: String?, dob: String?, cell: String?) {
        
        self.idValue = idValue
        self.nameTitle = nameTitle
        self.nameFirst = nameFirst
        self.nameLast = nameLast
        self.locationStreet = locationStreet
        self.locationCity = locationCity
        self.locationState = locationState
        self.locationPostCode = locationPostCode
        self.email = email
        self.picture = picture
        self.gender = gender
        self.dob = dob
        self.cell = cell
    }
    
    subscript() -> String? {
        return self.idValue
    }
    
    subscript(title: String) -> String {
        return title
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let idValue = aDecoder.decodeObject(forKey: "idValue") as? String
        let nameTitle = aDecoder.decodeObject(forKey: "nameTitle") as? String
        let nameFirst = aDecoder.decodeObject(forKey: "nameFirst") as? String
        let nameLast = aDecoder.decodeObject(forKey: "nameLast") as? String
        let locationStreet = aDecoder.decodeObject(forKey: "locationStreet") as? String
        let locationCity = aDecoder.decodeObject(forKey: "locationCity") as? String
        let locationState = aDecoder.decodeObject(forKey: "locationState") as? String
        let locationPostCode = aDecoder.decodeObject(forKey: "locationPostCode") as? String
        let email = aDecoder.decodeObject(forKey: "email") as? String
        let picture = aDecoder.decodeObject(forKey: "picture") as? String
        let gender = aDecoder.decodeObject(forKey: "gender") as? String
        let dob = aDecoder.decodeObject(forKey: "dob") as? String
        let cell = aDecoder.decodeObject(forKey: "cell") as? String
        
        self.init(idValue: idValue, nameTitle: nameTitle, nameFirst: nameFirst, nameLast: nameLast, locationStreet: locationStreet, locationCity: locationCity, locationState: locationState, locationPostCode: locationPostCode, email: email, picture: picture, gender: gender, dob: dob, cell: cell)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.idValue, forKey: "idValue")
        aCoder.encode(self.nameTitle, forKey: "nameTitle")
        aCoder.encode(self.nameFirst, forKey: "nameFirst")
        aCoder.encode(self.nameLast, forKey: "nameLast")
        aCoder.encode(self.locationStreet, forKey: "locationStreet")
        aCoder.encode(self.locationCity, forKey: "locationCity")
        aCoder.encode(self.locationState, forKey: "locationState")
        aCoder.encode(self.locationPostCode, forKey: "locationPostCode")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.picture, forKey: "picture")
        aCoder.encode(self.gender, forKey: "gender")
        aCoder.encode(self.dob, forKey: "dob")
        aCoder.encode(self.cell, forKey: "cell")
    }
}
