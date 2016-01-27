//
//  parseAPI.swift
//  OnTheMap
//
//  Created by pritesh kadiwala on 1/22/16.
//  Copyright © 2016 pritesh kadiwala. All rights reserved.
//

import Foundation


func hardCodedLocationData(completionHandler: ([parseApi])->()) {
    
    let applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let restAPI = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    
    let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-createdAt")!)
    request.addValue(applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue(restAPI, forHTTPHeaderField: "X-Parse-REST-API-Key")
    let session = NSURLSession.sharedSession()
    var myAPIArray: [parseApi] = []
    var arr = NSArray()
    let task = session.dataTaskWithRequest(request) { data, response, error in
        if error != nil { // Handle error...
            return
        }
        
        //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        
        
        let Dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
        //print(Dict["results"])
        arr = Dict["results"] as! NSArray
        
        for i in arr{
            //print(i)
            let myObject: parseApi = parseApi(createdAt: i["createdAt"] as! String, firstName: i["firstName"] as! String, lastName: i["lastName"] as! String, latitude: i["latitude"] as! Double, longitude: i["longitude"] as! Double, mapString: i["mapString"] as! String, mediaURL: i["mediaURL"] as! String, objectId: i["objectId"] as! String, uniqueKey: i["uniqueKey"] as! String, updatedAt: i["updatedAt"] as! String)
            
            myAPIArray.append(myObject)
            
            
        }
        
        completionHandler(myAPIArray)
        
        
    }
    task.resume()
    
    
}


func somethingElse() -> [parseApi] {
    var myAPIArray: [parseApi] = []
    hardCodedLocationData { (arr) -> () in
        myAPIArray = arr
    }
    //print(myAPIArray)
    return myAPIArray
}

struct parseApi{
    
    var createdAt : String
    var firstName : String
    var lastName : String
    var latitude : Double
    var longitude : Double
    var mapString : String
    var mediaURL : String
    var objectId : String
    var uniqueKey : String
    var updatedAt : String
    
    init(createdAt : String,
        firstName : String,
        lastName : String,
        latitude : Double,
        longitude : Double,
        mapString : String,
        mediaURL : String,
        objectId : String,
        uniqueKey : String,
        updatedAt : String){
            
            self.createdAt = createdAt
            self.firstName = firstName
            self.lastName = lastName
            self.latitude = latitude
            self.longitude = longitude
            self.mapString = mapString
            self.mediaURL = mediaURL
            self.objectId = objectId
            self.uniqueKey = uniqueKey
            self.updatedAt = updatedAt
            
            
    }
    
    
    
}