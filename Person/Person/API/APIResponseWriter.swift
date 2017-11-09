//
//  APIResponseWriter.swift
//  Person
//
//  Created by Louie Je Decatoria on 08/11/2017.
//  Copyright © 2017 Louie Je Decatoria. All rights reserved.
//

import Foundation

class APIResponseWriter {
    
    class func write(json: AnyObject?, request: NSMutableURLRequest?, response: URLResponse?, dataString: String?) {
        
        let httpResponse = response as! HTTPURLResponse
        var headers = "\(httpResponse.allHeaderFields)"
        headers = headers.replacingOccurrences(of: ", ", with: ",\n")
        headers = headers.replacingOccurrences(of: "[", with: "")
        headers = headers.replacingOccurrences(of: "]", with: "")
        let body = (request!.httpBody != nil) ? String(data: request!.httpBody!, encoding: String.Encoding.utf8) : "None"
        
        // var aToken = ""
        // if let accessToken = GlobalManager.getAccessToken() {
        //     aToken = accessToken
        //}
        
        var mDataString = ""
        if (dataString != nil) {
            mDataString = dataString!
        }
        
        var text = "HEADER: \n"
        text = text + "\(headers)\n\n"
        //text = text + "ACCESS TOKEN: \n"
        //text = text + "\(aToken)\n\n"
        text = text + "URL: \n"
        text = text + "\((request!.url?.absoluteString)!)\n\n"
        text = text + "BODY: \n"
        text = text + "\(body!)\n\n"
        text = text + "JSON: \n"
        text = text + "\(mDataString)\n\n"
        text = text + "DICTIONARY: \n"
        text = text + "\(json)"
        
        
        let path = (request!.url!.path)
        let filename = path.replacingOccurrences(of: "/", with: "-")
        APIResponseWriter.writeText(text: text, filename: "\(filename)")
        debugLog(logMessage: "\n[LOG FILE]: \n\(System.DOCUMENTS_PATH)/\(filename).txt", functionName:"")
        debugLog(logMessage: "", functionName:"")
    }
    
    private class func writeText(text: String?, filename: String?) {
        let file = "\(filename!).txt" // File name used in writing
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).appendingPathComponent(file)
            
            // Writing
            do {
                try text?.write(to: path!, atomically: false, encoding: String.Encoding.utf8)
            } catch {
                /* error handling here */
            }
        }
    }
}
