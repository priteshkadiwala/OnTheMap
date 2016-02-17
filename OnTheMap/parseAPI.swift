//
//  parseAPI.swift
//  OnTheMap
//
//  Created by pritesh kadiwala on 1/22/16.
//  Copyright © 2016 pritesh kadiwala. All rights reserved.
//

import Foundation

var Api = [parseApi]()

func hardCodedLocationData(completionHandler: ([[String : AnyObject]])-> Void) {
    
    
    let applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let restAPI = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    
    let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-createdAt")!)
    request.addValue(applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue(restAPI, forHTTPHeaderField: "X-Parse-REST-API-Key")
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
        if error != nil { // Handle error...
            return
        }
        
        //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        
        
        let Dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! [[String : AnyObject]]
        print(Dict)
        Api = parseApi.somethingElse(Dict)
        completionHandler(Dict)
        
        
    }
    task.resume()
    
    
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
    init(dictionary: [String : AnyObject]){
            
            createdAt = dictionary["createdAt"] as! String
            firstName = dictionary["firstName"] as! String
            lastName = dictionary["lastName"] as! String
            latitude = dictionary["latitude"] as! Double
            longitude = dictionary["longitude"] as! Double
            mapString = dictionary["mapString"] as! String
            mediaURL = dictionary["mediaURL"] as! String
            objectId = dictionary["objectId"] as! String
            uniqueKey = dictionary["uniqueKey"] as! String
            updatedAt = dictionary["updatedAt"] as! String
            
            
    }
    
    static func somethingElse(Dict: [[String : AnyObject]]) -> [parseApi] {
        var myAPIArray = [parseApi]()
        for item in Dict{
            myAPIArray.append(parseApi(dictionary: item))
        }
        //print(myAPIArray)
        return myAPIArray
    }
    
    
}