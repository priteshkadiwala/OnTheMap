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
        UdacityAPI.sharedInstance.checkLogin(Email.text!, password: Password.text!){ success, error in
            if(success){
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("tabController", sender: self)
                    
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: "Invalid Login", message: error, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    }
                    alertController.addAction(OKAction)
                
                    self.presentViewController(alertController, animated: true) {
                    }
                })
            }
        }
        
        
        
    }
    
    
}



