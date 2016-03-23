//
//  ListViewController.swift
//  OnTheMap
//
//  Created by pritesh kadiwala on 11/16/15.
//  Copyright © 2015 pritesh kadiwala. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UITableViewController{
    
    var count = 0
    
    var name: String = ""
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        count = ParseClient.sharedInstance.Api.count
        tableView.reloadData()
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
        
        let app = UIApplication.sharedApplication()
        if let url = NSURL(string: showURL.mediaURL) {
            app.openURL( url )
        } else {
            print("ERROR: Invalid url")
        }
    }
    
}