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
        
        
     
        
        count = Api.count
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count//to show the number of memes stored
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ompCell")! as UITableViewCell
        

        
        for dictionary in Api{
            let first = dictionary.firstName 
            let last = dictionary.lastName 
            
            cell.textLabel?.text = "\(first) \(last)"
            return cell
        }
        
        return cell
    }
    
}