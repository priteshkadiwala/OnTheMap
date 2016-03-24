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

    @IBOutlet weak var linkText: UITextField!
    @IBOutlet weak var acitivityController: UIActivityIndicatorView!
    
    var text = ""
    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    

    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.acitivityController.startAnimating()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
        
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = self.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            self.acitivityController.stopAnimating()
            self.acitivityController.hidden = true
            
        }
    
        
        
        
        
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("UITabBarController") as! UITabBarController//to access the picture in a detailed view
        self.presentViewController(detailController, animated: true, completion: nil)
        
    }
    
    @IBAction func submit(sender: UIButton) {
        
        let postData = "{\"uniqueKey\": \"\(UdacityAPI.sharedInstance.userID!)\", \"firstName\": \"\((UdacityAPI.sharedInstance.name?.firstName)!)\", \"lastName\": \"\((UdacityAPI.sharedInstance.name?.lastName)!)\",\"mapString\": \"\(text)\", \"mediaURL\": \"\(linkText.text!)\",\"latitude\": \(self.pointAnnotation.coordinate.latitude), \"longitude\": \(self.pointAnnotation.coordinate.latitude)}"
        
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
            detailVC.coordi = self.pointAnnotation.coordinate
            detailVC.media = linkText.text!
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
