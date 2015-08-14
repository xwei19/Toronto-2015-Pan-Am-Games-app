//
//  VenueDetail.swift
//  Toronto 2015
//
//  Created by Peter McIntyre on 2015-03-14.
//  Copyright (c) 2015 School of ICT, Seneca College. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class VenueDetail: UIViewController,CLLocationManagerDelegate {
    
    var detailItem: Venue!
    var lm: CLLocationManager!
    
    @IBOutlet weak var venueLocation: UILabel!
    @IBOutlet weak var venueDetails: UITextView!
    @IBOutlet weak var venueTitle: UILabel!
    @IBOutlet weak var venueSelector: UISegmentedControl!
    @IBOutlet weak var venuePhoto: UIImageView!
    @IBOutlet weak var theMap: MKMapView!
    @IBAction func venueChanged(sender: AnyObject) {
        if(venueSelector.selectedSegmentIndex==0){
            venueTitle.text = "Description"
            venueDetails.text = detailItem.venueDescription
        }
        if(venueSelector.selectedSegmentIndex==1){
            venueTitle.text = "Sports at this venue"
            var sports: [String] = []
            
            for vn in detailItem.sports {
                
                let sport = vn as Sport
                //let sportsName = sportsName + ", " + sport.sportName
                sports.append("\(sport.sportName)")
            }
            if sports.isEmpty {
                venueDetails.text="N/A"
            }
            else{
                venueDetails.text = "\(sports)"
            }
            
        }

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        venueTitle.text = "Description"
        venueDetails.text = detailItem.venueDescription
        
        // Display the photo, sized to fit
        venuePhoto.contentMode = UIViewContentMode.ScaleAspectFit
        venuePhoto.image = UIImage(data: detailItem.photo)
        
        venueLocation.text = detailItem.location
        let address = detailItem.location
        
        // Create a geocoder object
        let geocoder = CLGeocoder()
        
        // Use the Apple Maps web service to fetch a 'placemark' object
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            
            // Work with the first placemark that is returned
            if let pm = placemarks?[0] as? CLPlacemark {
                
                // Configure the map to be centered on the placemark's location coordinate
                self.theMap.region = MKCoordinateRegionMakeWithDistance(pm.location.coordinate, 2000, 2000)
                
                // Drop a red pin on the map
                self.theMap.addAnnotation(MKPlacemark(placemark: pm))
            }
        })

        
        //self.configureLocationObjects()
        
     }

    private func configureLocationObjects() {
        
        // Initialize and configure the location manager
        lm = CLLocationManager()
        lm.delegate = self
        
        // Change these values to affect the update frequency
        lm.distanceFilter = 100
        lm.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // Set location to run only when the app is in the foreground
        lm.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("Location services enabled\n")
        }
    }
    
    // MARK: - Delegate methods
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
            
        case .Restricted:
            print("restricted\n")
            
        case .NotDetermined:
            print("not determined\n")
            
        case .Denied:
            println("denied")
            
        case .Authorized:
            println("authorized always")
            
        case .AuthorizedWhenInUse:
            println("authorized when in use")
            theMap.showsUserLocation = true
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        // Most recent location is the last item in the 'locations' array
        // The array has CLLocation objects
        // 'coordinate' property has lat and long
        // Other properties are 'altitude' and 'timestamp'
        
        print("location update\n")
        
        if let l = locations.last as? CLLocation {
            
            // Display the latitude and longitude
            
            // Set the display region of the map
            theMap.region = MKCoordinateRegionMakeWithDistance(l.coordinate, 2000, 2000)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        print("Error: \(error.description)")
    }

}
