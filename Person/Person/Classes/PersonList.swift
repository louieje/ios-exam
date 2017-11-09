//
//  PersonList.swift
//  Person
//
//  Created by Louie Je Decatoria on 08/11/2017.
//  Copyright © 2017 Louie Je Decatoria. All rights reserved.
//

import UIKit

class PersonList: UIViewController {
    
    var apiRequest: APIRequest?
    var Persons = [PersonsModel]()

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getPersons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - Get Data
extension PersonList {
    func getPersons() {
        if (GlobalManager.isNetworkReachable() == false)
        {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.apiRequest?.cancel()
        self.apiRequest = APIRequest.execute(route: APIRouter.getPerson()){
            (data, _, _, error) in
            
            if (error != nil)
            {
                DispatchQueue.main.async
                    {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            else
            {
                let results = data?.value(forKeyPath: "results") as! [AnyObject]
                
                self.Persons.removeAll()
                results.forEach {
                    obj in
                    let person = PersonsModel(data: obj)
                    self.Persons.append(person!)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            
        }
    }
}

// MARK: - UITableViewDelegate and DataSource
extension PersonList: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PersonListCell
        
        let person = self.Persons[(indexPath as IndexPath).row]
        
        // Full Name
        if let title = person.nameTitle, let first = person.nameFirst, let last = person.nameLast {
            let fullName = "\(title.uppercased()) \(first.uppercased()) \(last.uppercased())"
            cell.fullName.text = fullName
        } else {
            cell.fullName.text = "MR. JOHN DOE"
        }
        
        // Gender
        cell.gender.text = person.gender
        
        // Email
        cell.email.text = person.email
        
        // Image / Picture
        cell.picture.imageFromServerURL(urlString: person.picture!, PlaceHolderImage: UIImage())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = self.Persons[(indexPath as IndexPath).row]
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PersonDetails") as! PersonDetails
        vc.person = person
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIImageView {
    
    public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {
        
        if self.image == nil{
            self.image = PlaceHolderImage
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}
