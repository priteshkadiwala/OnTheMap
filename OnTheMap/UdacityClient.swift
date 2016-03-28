//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by pritesh kadiwala on 3/20/16.
//  Copyright © 2016 pritesh kadiwala. All rights reserved.
//

import Foundation

class UdacityAPI: NSObject {
    
    static let sharedInstance = UdacityAPI()
    
    var userID: String?
    var name: nameStruct?
    
    func checkLogin(email: String, password: String, completionHandler: (success: Bool, error: String?) -> Void){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error == nil { // Handle error…
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                let Dict = try! NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
                print(Dict)
                    if let account = Dict.valueForKey("account") as? NSDictionary {
                        if let userID = account.valueForKey("key") as? String {
                            self.userID = userID
                            self.getUserData( userID ) { success, error in
                                if(success){
                                    print("\(self.name?.firstName) \(self.name?.lastName)")
                                }
                            }
                                
                            completionHandler(success: true, error: nil)
                        } else{
                            
                            completionHandler(success: false, error: "Login Error")
                        }
                        
                    } else{
                        
                        completionHandler(success: false, error: "Login Error")
                    }
                
                
                
            } else{
                
                completionHandler(success: false, error: "Network Error")
            }
        }
        task.resume()
        
    }
    
    func getUserData(userID: String, completionHandler: (success: Bool, errorMessage: String?) -> Void ) {
        
        let id = userID
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(id)")!)
        request.HTTPMethod = "GET"
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error == nil { // Handle error...
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
                
                let findName = try! NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
                
                if let user = findName.valueForKey("user") as? NSDictionary {
                    self.name = nameStruct()
                    
                    if let last_name = user.valueForKey("last_name") as? String{
                        self.name?.lastName = last_name
                    }
                    
                    if let first_name = user.valueForKey("first_name") as? String{
                        self.name?.firstName = first_name
                    }
                    completionHandler(success: true, errorMessage: nil)
                }
                
            }
            else{
                completionHandler(success: false, errorMessage: "Network Error!")
            }
            
        }
        task.resume()
        
    }
    
    func logout(completionHandler: (success: Bool, errorMessage: String?) -> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error == nil {
                self.userID = nil
                completionHandler(success: true, errorMessage: nil)
            } else{
                completionHandler(success: true, errorMessage: "Network Error.")
            }
            
        }
        task.resume()
    }
    
}