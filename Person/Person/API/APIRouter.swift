//
//  APIRouter.swift
//  Person
//
//  Created by Louie Je Decatoria on 08/11/2017.
//  Copyright © 2017 Louie Je Decatoria. All rights reserved.
//

import Foundation

public enum APIRouter: URLRequestConvertible {
    
    case getPerson()
    
    public var URLRequest: NSMutableURLRequest {
        
        var path:String = {
            switch self {
            case .getPerson:
                return "api/?page=1&results=20&seed=abc&inc=name,gender,email,location,picture,dob,cell"
            }
        }()
        
        switch self {
        case .getPerson():
            return ParameterEncoding.encode(path: path, method:HTTPMethod.GET, parameters: nil).0
        }
    }
}

public protocol URLRequestConvertible {
    var URLRequest: NSMutableURLRequest { get }
}

public enum ParameterEncoding {
    
    static func encode(path: String, method: HTTPMethod, parameters: [String : AnyObject]?) -> (NSMutableURLRequest, NSError?) {
        
        var urlPath = ConfigManager.sharedInstance.baseUrl! + path
        //var queryString = ""
        
        if let param = parameters {
            let components = NSURLComponents(string: urlPath)!
            var queryItems: [NSURLQueryItem] = components.queryItems as [NSURLQueryItem]? ?? [NSURLQueryItem]()
            param.forEach { (key, val) in
                queryItems.append(NSURLQueryItem(name: key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!, value: "\(val)"))
            }
            components.queryItems = queryItems as [URLQueryItem]?
            //queryString = components.query!
            
            if (method == HTTPMethod.GET) {
                urlPath = components.string!
            }
        }
        
        let url = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = method.rawValue
        
        if (method == HTTPMethod.POST || method == HTTPMethod.PUT) {
            self.configureBody(request: request, parameters: parameters)
            //self.configureBody(request, query: queryString)
        }
        self.configureHeaders(request: request)
        return (request, nil) //\\//\\//\\//\\
    }
    
    static func configureHeaders(request: NSMutableURLRequest) {
        //application/x-www-form-urlencoded
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
//        if let accessToken = GlobalManager.getAccessToken() {
//            //request.setValue(accessToken, forHTTPHeaderField: "Authorization")
//        }
    }
    
    static func configureBody(request: NSMutableURLRequest, parameters: [String : AnyObject]?) {
        var postData: NSData?
        do {
            postData = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted) as NSData?
        } catch let err as NSError{
            debugLog(logMessage: err.description, functionName:"")
        }
        
        //let postData:NSData = query.dataUsingEncoding(NSUTF8StringEncoding)!
        let postLength = "\(postData!.length)"
        request.httpBody = postData! as Data
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
    }
    
    /*
     static func configureBody(request: NSMutableURLRequest, query: String) {
     let postData:NSData = query.dataUsingEncoding(NSUTF8StringEncoding)!
     let postLength = "\(postData.length)"
     request.HTTPBody = postData
     request.setValue(postLength, forHTTPHeaderField: "Content-Length")
     }*/
}

public enum HTTPMethod : String {
    case OPTIONS
    case GET
    case HEAD
    case POST
    case PUT
    case PATCH
    case DELETE
    case TRACE
    case CONNECT
}
