//
//  pinViewController.swift
//  OnTheMap
//
//  Created by pritesh kadiwala on 12/4/15.
//  Copyright © 2015 pritesh kadiwala. All rights reserved.
//
import MapKit
import UIKit

class pinViewController: UIViewController, MKMapViewDelegate{
    
    var uniqueKey = String()
    var firstName = String()
    var lastName = String()
    var mapString = String()
    var mediaURL = String()
    var latitude = Double()
    var longitude = Double()
    var userID = String()

    var findPlace: CLGeocoder = CLGeocoder()

    @IBOutlet weak var linkText: UITextField!
    @IBOutlet weak var acitivityController: UIActivityIndicatorView!
    
    var text = ""
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.acitivityController.startAnimating()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        findPlace.geocodeAddressString(text) { placemarks, error in
            if error == nil {
                if let placemark = placemarks![0] as? CLPlacemark {
                    let coordinates = placemark.location!.coordinate
                    
                    //Setup data for submission
                    self.latitude = coordinates.latitude as Double
                    self.longitude = coordinates.longitude as Double
                    self.mapString = self.text
                    
                    let region = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(0.5, 0.5))
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinates
                    self.mapView.addAnnotation(annotation)
                    
                    //Reconfigure display
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.mapView.alpha = 1.0
                        self.mapView.setRegion(region, animated: true)
                    }
                }
            } else {
                let alert = UIAlertController(title: "Can't get there from here.", message: "Sorry we couldn't find that location.", preferredStyle: .Alert)
                let dismissAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    self.acitivityController.stopAnimating()
                }
                alert.addAction(dismissAction)
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            }
        }
    
        
        
        
        
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func submit(sender: UIButton) {
        
        let postData = "{\"uniqueKey\": \"\(UdacityAPI.sharedInstance.userID!)\", \"firstName\": \"\((UdacityAPI.sharedInstance.name?.firstName)!)\", \"lastName\": \"\((UdacityAPI.sharedInstance.name?.lastName)!)\",\"mapString\": \"\(text)\", \"mediaURL\": \"\(linkText.text!)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        
        ParseClient.sharedInstance.postLocationData(postData){ success, error in
            if(success){
                print("did post")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                alert.addAction(dismissAction)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapView"{
            let detail = segue.destinationViewController as! UITabBarController
            let nav = detail.viewControllers![0] as! UINavigationController
            let detailVC = nav.topViewController as! MapViewController
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
