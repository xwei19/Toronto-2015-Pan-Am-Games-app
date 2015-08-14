//
//  Launch.swift
//  Toronto 2015
//
//  Created by Peter McIntyre on 2015-03-03.
//  Copyright (c) 2015 School of ICT, Seneca College. All rights reserved.
//

import UIKit
import CoreData

class Launch: UIViewController {
    
    // MARK: - Properties
    
    var model: Model!
    
    // These will be filled by the results of the web service requests
    var sports = [AnyObject]()
    var venues = [AnyObject]()

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frc = model.frc_sport
        
        // This controller will be the frc delegate
        frc.delegate = nil
        // No predicate (which means the results will NOT be filtered)
        frc.fetchRequest.predicate = nil
        
        // Create an error object
        var error: NSError? = nil
        // Perform fetch, and if there's an error, log it
        if !frc.performFetch(&error) { println(error?.description) }

        // Finally, check for data on the device, and if not, load the data
        checkForDataOnDevice()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toSportList" {
            
            let vc = segue.destinationViewController as SportList
            vc.model = model
        }
        
        if segue.identifier == "toVenueList" {
            
            let vc = segue.destinationViewController as VenueList
            vc.model = model
        }
        
        if segue.identifier == "toNewsList" {
            
            let vc = segue.destinationViewController as NewsList
            vc.model = model
        }
        
        if segue.identifier == "toEventList" {
            
            let vc = segue.destinationViewController as EventList
            vc.model = model
        }
    }
    
    // MARK: - On first launch, fetch initial data from the web service
    
    func checkForDataOnDevice() {
        
        if model.frc_sport.fetchedObjects?.count == 0 {
            
            print("Device does not have data.\nWill fetch data from the network.\n")
            
            // First, listen for the notification (from the WebServiceRequest instance)
            // that indicates that the download is complete
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "fetchCompletedSports", name: "Toronto_2015.Launch_sports_fetch_completed", object: nil)
            
            // Next, cause the request to run
            // Create, configure, and execute a web service request

            // When complete, the runtime will save the results in the 'sports' array variable,
            // and call the 'fetchCompletedSports' method
            let request = WebServiceRequest()
            request.sendRequestToUrlPath("/sports", forDataKeyName: "Collection", from: self, propertyNamed: "sports")
            
            print("Request for sports has been sent.\nWaiting for results.\n\n")
        }
    }
    
    func fetchCompletedSports() {
        
        // This method is called when there's new/updated data from the network
        // It's the 'listener' method
        
        print("Results have returned.\n")
        print("\(sports.count) sport objects were fetched.\n")
        print("Next, the venues will be fetched.\n")
        
        // First, listen for the notification (from the WebServiceRequest instance)
        // that indicates that the download is complete
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fetchCompletedVenues", name: "Toronto_2015.Launch_venues_fetch_completed", object: nil)
        
        // Next, cause the request to run
        // Create, configure, and execute a web service request

        // When complete, the runtime will save the results in the 'venues' array variable,
        // and call the 'fetchCompletedVenues' method
        let request = WebServiceRequest()
        request.sendRequestToUrlPath("/venues/withsports", forDataKeyName: "Collection", from: self, propertyNamed: "venues")
        
        print("Request for venues has been sent.\nWaiting for results.\n\n")
    }
    
    func fetchCompletedVenues() {
        
        // This method is called when there's new/updated data from the network
        // It's the 'listener' method
        
        print("Results have returned.\n")
        print("\(venues.count) venue objects were fetched.\n")
        print("Data will be saved on this device.\n")

        // At this point in time, we have all the sports and venues
        
        // Process the sports first...
        // For each web service sport, create and configure a local sport object
        
        for s in sports {
            
            // Here, we use 'd' for the name of the new device-stored object

            let d = model.addNewSport()
            
            // The data type of the web service 'sport' is AnyObject
            // When reading a value from this AnyObject, 
            // we will use its key-value accessor, 'valueForKey'

            // The data type of the local 'sport' is Sport
            // When writing (setting) a value to this Sport,
            // we will use its property name
            
            d.sportName = s.valueForKey("Name") as String
            print("Adding \(d.sportName)...\n")
            d.sportDescription = s.valueForKey("Description") as String
            d.history = s.valueForKey("History") as String
            d.howItWorks = s.valueForKey("HowItWorks") as String
            d.hostId = s.valueForKey("Id") as Int
            
            // Get logo and photo
            
            let urlLogo = s.valueForKey("LogoUrl") as String
            if let logo = UIImage(data: NSData(contentsOfURL: NSURL(string: urlLogo)!)!) {
                d.logo = UIImagePNGRepresentation(logo)
            }
            
            let urlPhoto = s.valueForKey("PhotoUrl") as String
            if let photo = UIImage(data: NSData(contentsOfURL: NSURL(string: urlPhoto)!)!) {
                d.photo = UIImagePNGRepresentation(photo)
            }
            
            print("- logo and photo fetched.\n")
            
        }
        print("All sports have been added.\n\n")
        
        model.saveChanges()
        
        // Create and configure a fetch request object
        // We will need this to set the sport-venue relation
        let f = NSFetchRequest(entityName: "Sport")

        // Process the venues next...
        // For each web service venue, create and configure a local venue object
        
        // While doing this, use the fetch request object to get a local sport object,
        // so that it can be set in the 'sports' relation collection

        // This task uses an Venue 'extension', which you can find in the 
        // 'Extensions.swift' source code file
        // Use this 'best practice' technique to configure a many-to-many relationship
        
        for v in venues {
            
            // Here, we use 'd' for the name of the new device-stored object

            let d = model.addNewVenue()
            d.venueName = v.valueForKey("Name") as String
            print("Adding \(d.venueName)...\n")
            d.venueDescription = v.valueForKey("Description") as String
            d.location = v.valueForKey("Location") as String
            
            // Get photo and map
            
            let urlPhoto = v.valueForKey("PhotoUrl") as String
            if let photo = UIImage(data: NSData(contentsOfURL: NSURL(string: urlPhoto)!)!) {
                d.photo = UIImagePNGRepresentation(photo)
            }
            
            let urlMap = v.valueForKey("MapUrl") as String
            if let map = NSData(contentsOfURL: NSURL(string: urlMap)!) {
                d.map = map
            }
            
            print("- photo and map fetched.\n")
            
            model.saveChanges()
            
            // This code block will check if the web service 'venue'
            // has anything in its "Sports" collection
            // If yes, the code will fetch the 'sport' object from the device data store,
            // and use it to set the sport-venue relationship
            
            if let sportsInVenue = (v.valueForKey("Sports") as? [AnyObject]) {
                
                for s in sportsInVenue {

                    // We need a unique identifier, and the web service 'Id' value is unique
                    let sportId = s.valueForKey("Id") as Int

                    // We will use that value in the (lookup/search) predicate
                    f.predicate = NSPredicate(format: "hostId == %@", argumentArray: [sportId])

                    // Attempt to fetch the matching sport object from the device store
                    // The results from the 'executeFetchRequest' call is an array of AnyObject
                    // However, the array will contain exactly one object (if successful)
                    // That's why we get and use the first object found in the array
                    if let relatedSport = (model.executeFetchRequest(fetchRequest: f))[0] as? Sport {
                        
                        d.addSport(relatedSport)
                        print("- \(relatedSport.sportName) added to this venue\n")
                    }
                }
            }
            model.saveChanges()
        }
        print("All venues have been added.\n\n")
    }
    
}
