//
//  placeViewController.swift
//  OnTheMap
//
//  Created by pritesh kadiwala on 12/4/15.
//  Copyright © 2015 pritesh kadiwala. All rights reserved.
//

import UIKit

class placeViewController: UIViewController {

    @IBOutlet weak var location: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "linkView" {
            let detailVC = segue.destinationViewController as! pinViewController
            detailVC.text = location.text!
        }
    }
    
    
    @IBAction func findName(sender: AnyObject) {
        performSegueWithIdentifier("linkView", sender: self)
    }

}
