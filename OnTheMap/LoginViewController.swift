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
    @IBOutlet weak var accSignup: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Password.secureTextEntry = true
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile","email","user_friends"]
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
         self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if Email.editing {//to pull up the screen height once the bottom text editing begins
            self.view.frame.origin.y = -getKeyboardHeight(notification)
            accSignup.hidden = true
            
        }
        if Password.editing {//to pull up the screen height once the bottom text editing begins
            self.view.frame.origin.y = -getKeyboardHeight(notification)
            accSignup.hidden = true
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if Email.editing{//level back the text editing.
            self.view.frame.origin.y = 0
            accSignup.hidden = false
        }
        if Password.editing{//level back the text editing.
            self.view.frame.origin.y = 0
            accSignup.hidden = false
        }
        
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
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
            dispatch_async(dispatch_get_main_queue(), {
                let alertController = UIAlertController(title: "Invalid Login", message: "Not able to log in through Facebook", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                }
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("tabController", sender: self)
                
            })
        }
    
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



