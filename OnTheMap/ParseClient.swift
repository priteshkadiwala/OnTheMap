//
//  ParseClient.swift
//  OnTheMap
//
//  Created by pritesh kadiwala on 3/20/16.
//  Copyright © 2016 pritesh kadiwala. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    static let sharedInstance = ParseClient()
    var Api = [StudentData]()
    
    override init() {
        Api = [StudentData]()
        super.init()
    }
    
    let applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let restAPI = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    
    func getLocationData(completionHandler: (success: Bool, error: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue(applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPI, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.HTTPMethod = "GET"
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error == nil {
                let someData:AnyObject? = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                if let results = someData!.valueForKey("results") as? [[String : AnyObject]] {
                    
                    self.Api = StudentData.downloadLocation(results)
                    completionHandler(success: true, error: nil)
                    
                } else{
                    completionHandler(success: false, error: "Data download error!")
                }
            } else {
                completionHandler(success: false, error: "Network error!")
            }

        }
        task.resume()
        
        
    }
    
    func postLocationData(data: String, completionHandler: (success: Bool, error: String?) -> Void) {
        
        
        let url:NSURL = NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!
        let postData:NSData = data.dataUsingEncoding(NSUTF8StringEncoding)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPI, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(success: false, error: "Error posting the data")
            } else{
                
                completionHandler(success: true, error: nil)
            }
            
        }
        task.resume()
        
        
    }
    
    func checkGetLocation(data: Bool, completionHandler: (success: Bool, error: String?) -> Void){
        if(data){
            completionHandler(success: true, error: nil)
        } else{
            completionHandler(success: false, error: "Error posting the pins")
        }
    }

    
}
