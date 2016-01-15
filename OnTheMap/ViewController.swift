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

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    

    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Password.secureTextEntry = true
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile","email","user_friends"]
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func accountButton(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/")!)
    }
    
    
    public func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        if(error != nil)
        {
            print(error.localizedDescription)
            return
        }
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("UITabBarController") as! UITabBarController//to access the picture in a detailed view
        self.presentViewController(detailController, animated: true, completion: nil)

        
    }
    
    public func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        
    }
    
    @IBAction func Login(sender: UIButton) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(Email.text!)\", \"password\": \"\(Password.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data
            */
            
            let Dict = try! NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
            
            let sessionId = Dict["account"]!["registered"] as! Bool!
            
            
            if(sessionId == true){
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("tabController", sender: self)
                
                })
            }
            
            
            
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            print(sessionId)
        }
        task.resume()
    }
    
    
}

