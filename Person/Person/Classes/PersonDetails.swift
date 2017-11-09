//
//  PersonDetails.swift
//  Person
//
//  Created by Louie Je Decatoria on 09/11/2017.
//  Copyright © 2017 Louie Je Decatoria. All rights reserved.
//

import UIKit

class PersonDetails: UIViewController {
    
    var person = PersonsModel()

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var mobileNo: UILabel!
    @IBOutlet weak var address: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setData()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setData () {
        
        // Full Name
        if let title = self.person.nameTitle, let first = self.person.nameFirst, let last = self.person.nameLast {
            let fullName = "\(title.uppercased()) \(first.uppercased()) \(last.uppercased())"
            self.fullname.text = fullName
        } else {
            self.fullname.text = "MR. JOHN DOE"
        }
        
        // Birthday
        let date = person.dob?.convertDate
        self.birthday.text = date
        
        // Age
        let dobComponents = person.dob?.components(separatedBy: "-")
        let dateDOB = Calendar.current.date(from: DateComponents(year:
            Int(dobComponents![0]), month: Int(dobComponents![1]), day:
            Int(dobComponents![2])))!
        let age = dateDOB.age
        self.age.text = "\(age)"
        
        // Email
        self.email.text = person.email
        
        // Address
        if let street = self.person.locationStreet, let city = self.person.locationCity, let state = self.person.locationState, let postCode = self.person.locationPostCode {
            let fullAddress = "\(street), \(city)\n\(state), \(postCode)"
            self.address.text = fullAddress
        } else {
            self.address.text = "Street No., City\nState\nPostal Code"
        }
        
        // Image / Picture
        self.picture.imageFromServerURL(urlString: person.picture!, PlaceHolderImage: UIImage())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension String {
    var convertDate: String {
        //JSON return is string, and format as yyyy-MM-dd HH:mm:ss. This method will convert from string (with format) to Date, then change the dateFormat to "MMM dd, yyyy" in string
        let date = self
        let dateAsDate = NSDate.dateForDateFormat(dateFormat: "yyyy-MM-dd HH:mm:ss", dateString: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        
        let strDate = formatter.string(from: dateAsDate! as Date)
        
        return strDate
    }
    
    func toDate( dateFormat format  : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: self)
        {
            return date
        }
        print("Invalid arguments ! Returning Current Date . ")
        return Date()
    }
}

extension NSDate {
    class func dateForDateFormat(dateFormat: String, dateString: String) -> NSDate? {
        let nDateFormatter = DateFormatter()
        nDateFormatter.dateFormat = dateFormat
        let date = nDateFormatter.date(from: dateString)
        return date as NSDate?
    }
}

extension Date {
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
    
}
