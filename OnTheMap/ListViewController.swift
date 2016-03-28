//
//  ListViewController.swift
//  OnTheMap
//
//  Created by pritesh kadiwala on 11/16/15.
//  Copyright © 2015 pritesh kadiwala. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import UIKit

class ListViewController: UITableViewController{
    
    var count = 0
    
    var name: String = ""
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        count = ParseClient.sharedInstance.Api.count
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        ParseClient.sharedInstance.getLocationData(){ success, error in
            dispatch_async(dispatch_get_main_queue()) {
                if (success){
                    
                    self.tableView.reloadData()
                    
                } else{
                    
                    let alertController = UIAlertController(title: "Invalid Login", message: error, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    }
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true) {
                    }
                    
                }
            }
            
            
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        UdacityAPI.sharedInstance.logout(){ success, error in
            if(success){
                
                dispatch_async(dispatch_get_main_queue()) {
                    FBSDKLoginManager().logOut()
                    let loginController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                    self.presentViewController(loginController, animated: true, completion: nil)
                }
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count//to show the number of memes stored
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ompCell")! as UITableViewCell
        
        let showLocation = ParseClient.sharedInstance.Api[indexPath.row]
        
        cell.textLabel?.text = "\(showLocation.firstName) \(showLocation.lastName)"
        cell.detailTextLabel?.text = showLocation.mediaURL
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let showURL = ParseClient.sharedInstance.Api[indexPath.row]
        print(showURL.mediaURL)
        let app = UIApplication.sharedApplication()
        if let url = NSURL(string: showURL.mediaURL) {
            app.openURL( url )
        } else {
            print("ERROR: Invalid url")
        }
    }
    
}