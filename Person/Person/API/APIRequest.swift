//
//  PersonList.swift
//  Person
//
//  Created by Louie Je Decatoria on 08/11/2017.
//  Copyright © 2017 Louie Je Decatoria. All rights reserved.
//

import Foundation

public protocol ResponseObjectSerializable {
    init?(data: AnyObject)
}

let APIREQUEST_ERROR_DOMAIN = "ZFrameworkAppHttpResponseErrorDomain"
typealias APIRequestResponseBlk = (AnyObject?, ResponseObjectSerializable?, [ResponseObjectSerializable]?, NSError?) -> ()

class APIRequest: NSObject, URLSessionDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {
    
    private var response: APIRequestResponseBlk?
    private var task: URLSessionDataTask?
    //private var session:URLSession?
    private var buffer: NSMutableData? = NSMutableData()
    private var expectedContentLength: Int?
    
    class func execute(route: URLRequestConvertible?, response: APIRequestResponseBlk?) -> APIRequest{
        let apiRequest = APIRequest.execute(route: route, responseObjectClass: nil, response: response)
        return apiRequest
    }
    
    class func execute(route: URLRequestConvertible?, responseObjectClass:AnyClass?, response: APIRequestResponseBlk?) -> APIRequest{
        let apiRequest = APIRequest()
        apiRequest.response = response
        apiRequest.processRequest(request: route!.URLRequest, responseObjectClass: responseObjectClass)
        return apiRequest
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    private func processRequest(request: NSMutableURLRequest?, responseObjectClass:AnyClass?) {
        
        let session = URLSession.shared
        self.task = session.dataTask(with: request! as URLRequest) { (data, response, error) in
            
            if (error != nil) {
                self.response?(nil, nil ,nil, error as NSError?)
                return
                /*
                // -999 is the error code for cancelled tasks
                if ((response as! HTTPURLResponse).statusCode != -999) {
                    debugLog(logMessage: "ERROR: \(error)", functionName:"")
                    self.response?(nil, nil ,nil, error as NSError?)
                    return
                } else {
                    debugLog(logMessage: "CANCELLED", functionName:"")
                    return
                }
                */
            }
            
            var json: AnyObject!
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as AnyObject
            } catch let err as NSError{
                debugLog(logMessage: err.description, functionName:"")
            }
            
            // Check if JSON = nil
            if (json == nil) {
                let userInfo: [String : String] = [
                    NSLocalizedDescriptionKey as String :  NSLocalizedString("JSON Error", value: "JSON response is empty", comment: "") as String]
                let err = NSError(domain: APIREQUEST_ERROR_DOMAIN, code: 401, userInfo: userInfo)
                
                if (DEBUG_BUILD) {
                    debugLog(logMessage: "URL: \((request!.url?.absoluteString)!)", functionName:"")
                    debugLog(logMessage: "JSON: \(err)", functionName:"")
                    
                    let dataString = String(data: data!, encoding: String.Encoding.utf8)
                    APIResponseWriter.write(json: json, request: request, response: response, dataString: dataString)
                }
                self.response?(nil, nil ,nil, err)
                return
            }
            
            // ey!, our JSON is an ARRAY!
            // For this case, make it a dictionary with key "data"
            if (json is [AnyObject]) {
                json = NSDictionary(object: json, forKey: "data" as NSCopying)
            }
            
            if (DEBUG_BUILD) {
                let dataString = String(data: data!, encoding: String.Encoding.utf8)
                APIResponseWriter.write(json: json, request: request, response: response, dataString: dataString)
            }
            
            // Check if there is an "error" key found JSON
            let errorExists = json.value(forKeyPath: "error") != nil
            if (errorExists) {
                let errorInfo = json.value(forKeyPath:"error")
                var errorMessage = json.value(forKeyPath:"error")! as AnyObject
                if (isValidKeypath(data: json, keypath: "error_description")){
                    errorMessage = json.value(forKeyPath:"error_description")! as AnyObject
                } else {
                    errorMessage = json.value(forKeyPath:"error")! as AnyObject
                }
                
                let userInfo: [NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey as NSObject :  NSLocalizedString("Error", value: "\(errorMessage)", comment: "") as AnyObject]
                let err = NSError(domain: APIREQUEST_ERROR_DOMAIN, code: 401, userInfo: userInfo as? [String : Any])
                self.response?(nil, nil ,nil, err)
                
            } else {
                
                if let rObject = responseObjectClass {
                    let array = json.value(forKeyPath:"data")
                    var objectArray = [ResponseObjectSerializable]()
                    
                    // if Array
                    if (array is [AnyObject]) {
                        let cclass = rObject as! ResponseObjectSerializable.Type
                        let mArray = array as! [AnyObject]
                        mArray.forEach({ objData in
                            let obj = cclass.init(data: objData)! as ResponseObjectSerializable
                            objectArray.append(obj)
                        })
                        self.response?(json, nil ,objectArray, nil)
                        
                        // if Dictionary
                    } else {
                        let cclass = rObject as! ResponseObjectSerializable.Type
                        let obj = cclass.init(data: json!)! as ResponseObjectSerializable
                        self.response?(json, obj ,nil, nil)
                    }
                } else {
                    self.response?(json, nil ,nil, nil)
                }
            }
        }
        self.task?.resume()
    }
    
    /*
     // MARK: Delegate
     func URLSession(session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void) {
     debugLog("willCacheResponse")
     }
     func URLSession(session: URLSession, dataTask: URLSessionDataTask, didReceiveResponse response: URLResponse, completionHandler: (URLSessionResponseDisposition) -> Void) {
     //here you can get full lenth of your content
     self.expectedContentLength = Int(response.expectedContentLength)
     debugLog("Expected Content Length: \(expectedContentLength!)")
     }
     func URLSession(session: URLSession, dataTask: URLSessionDataTask, didReceiveData data: NSData) {
     debugLog("")
     self.buffer?.appendData(data)
     
     let percentageDownloaded = Float(self.buffer!.length) / Float(self.expectedContentLength!)
     debugLog("Data Percent Downloaded: \(percentageDownloaded)")
     }
     func URLSession(session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?) {
     debugLog("Complete...")
     //use buffer here.Download is done
     // progress.progress = 1.0   // download 100% complete
     }*/
}

func isValidKeypath(data: AnyObject?, keypath: String?) -> Bool {
    guard let mData = data else {
        return false
    }
    guard let kPath = keypath else {
        return false
    }
    if (mData.value(forKeyPath:kPath) != nil && (mData.value(forKeyPath: kPath) as AnyObject).classForCoder != NSNull.classForCoder()) {
        return true
    }
    return false
}
