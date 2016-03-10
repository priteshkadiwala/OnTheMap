//
//  LocationsOfStudents.swift
//  OnTheMap
//
//  Created by pritesh kadiwala on 2/24/16.
//  Copyright © 2016 pritesh kadiwala. All rights reserved.
//

import Foundation
import UIKit


var uniqueKey = String()
var firstName = String()
var lastName = String()
var mapString = String()
var mediaURL = String()
var latitude = String()
var longitude = String()
var userID = String()
var Api = [parseApi]()

func getLocationData(completionHandler: (success: Bool, error: String?) -> Void) {
        
    
    let applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let restAPI = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
   
    let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-createdAt")!)
    request.addValue(applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue(restAPI, forHTTPHeaderField: "X-Parse-REST-API-Key")
    request.HTTPMethod = "GET"
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
        if error == nil { // Handle error...
            let someData:AnyObject? = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
            if let results = someData!.valueForKey("results") as? [[String : AnyObject]] {
                // here somethingElse should get [[String : AnyObject]] as input parameter.
                Api = parseApi.downloadLocation(results)
                completionHandler(success: true, error: nil)
                
            } else{
                completionHandler(success: false, error: "Data download error!")
            }
        } else {
            completionHandler(success: false, error: "Network error!")
        }
            
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            
            
            //completionHandler(Dict)
            //print(Api)
            
    }
    task.resume()
        
        
}

func postLocationData(data: [String: AnyObject], completionHandler: (success: Bool, error: String?) -> Void) {
    
    
    let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
    request.HTTPMethod = "POST"
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
        if error != nil { // Handle error…
            return
        }
        //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
    }
    task.resume()
    
    
}



func getUserData(userID: String, completionHandler: (success: Bool, errorMessage: String?) -> Void ) {
    let id = userID
    let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(id)")!)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
        if error == nil { // Handle error...
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            //print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            let findName = try! NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
            //print(findName["user"]!["first_name"])
            firstName = (findName["user"]!["first_name"] as? String)!
            lastName = (findName["user"]!["last_name"] as? String)!
                
            completionHandler(success: true, errorMessage: nil)
            
        }
        else{
            completionHandler(success: false, errorMessage: "Network Error!")
        }
        
    }
    task.resume()
    
}

/*func getUserID(Email: String, Password: String, completionHandler: (success: Bool, error: String?) -> Void) {
    
    let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
    request.HTTPMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.HTTPBody = "{\"udacity\": {\"username\": \"\(Email)\", \"password\": \"\(Password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
        if error == nil {
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            let Dict = try! NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
            print(Dict)
            userID = Dict["account"]!["key"] as! String!
            completionHandler(success: true, error: nil)
        }
        else{
            completionHandler(success: false, error: "Network error!")
        }
        
        
        //println(NSString(data: newData, encoding: NSUTF8StringEncoding))
    }
    task.resume()
    
    
}*/



