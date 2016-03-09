//
//  ViewController.swift
//  OnTheMap
//
//  Created by pritesh kadiwala on 11/2/15.
//  Copyright © 2015 pritesh kadiwala. All rights reserved.
//


import UIKit
import FBSDKShareKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    

    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Password.secureTextEntry = true
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile","email","user_friends"]
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func accountButton(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/")!)
    }
    
    
    internal func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        if(error != nil)
        {
            print(error.localizedDescription)
            return
        }
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("UITabBarController") as! UITabBarController//to access the picture in a detailed view
        self.presentViewController(detailController, animated: true, completion: nil)

        
    }
    
    internal func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        
    }
    
    @IBAction func Login(sender: UIButton) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(Email.text!)\", \"password\": \"\(Password.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
        } catch let error as NSError {
            reponseError = error
            urlData = nil
        }
        if(urlData == nil){
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Connection Failure"
            if let error = reponseError {
                alertView.message = (error.localizedDescription)
            }
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        else{
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data
            */
            
            let Dict = try! NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
        
            //print(Dict["error"])
            
            if(Dict["error"] != nil){
                dispatch_async(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: "Invalid Login", message: "Wrong Credentials", preferredStyle: .Alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        // ...
                    }
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true) {
                        // ...
                    }
                    
                })
                
            } else{
               
                let sessionId = Dict["account"]!["registered"] as! Bool!
                if(sessionId == true){
                    dispatch_async(dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("tabController", sender: self)
                        
                    })
                }
              
                //print(Dict["account"])
            }
            
            //print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
        }
        task.resume()
      
        }
    }
    
    
    func getUserID(completionHandler: (success: Bool, error: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(Email.text)\", \"password\": \"\(Password.text)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
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
        
        
    }
    
}



