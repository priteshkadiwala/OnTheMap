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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("UITabBarController") as! UITabBarController//to access the picture in a detailed view
        self.presentViewController(detailController, animated: true, completion: nil)
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
