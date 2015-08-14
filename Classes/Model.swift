//
//  Model.swift
//  Classes
//
//  Created by Peter McIntyre on 2015-02-26.
//  Copyright (c) 2015 School of ICT, Seneca College. All rights reserved.
//

import CoreData
import UIKit

class Model {

    // MARK: - Private properties
    
    private var cdStack: CDStack!
    
    lazy private var applicationDocumentsDirectory: NSURL = {
        
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
        }()
    
    // MARK: - Public properties
    
    var venueImageCache = [String : UIImage]()
    // Can probably make more caches for thumbnails etc.
    
    lazy var venueIconEmpty: UIImage = {
    
        // Use this to create an empty white image, 80 points wide, 40 points tall
        let rect = CGRectMake(0, 0, 80, 40)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContextRef = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, (UIColor.whiteColor()).CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }()
    /*
    lazy var frc_example: NSFetchedResultsController = {
        
        // Use this as a template to create other fetched results controllers
        let frc = self.cdStack.frcForEntityNamed("Example", withPredicateFormat: nil, predicateObject: nil, sortDescriptors: "attribute1,true", andSectionNameKeyPath: nil)
        
        return frc
    }()
    */
    
    lazy var frc_event: NSFetchedResultsController = {
        
        // Use this as a template to create other fetched results controllers
        let frc = self.cdStack.frcForEntityNamed("Event", withPredicateFormat: nil, predicateObject: nil, sortDescriptors: "name,true", andSectionNameKeyPath: nil)
        
        return frc
        }()

    lazy var frc_sport: NSFetchedResultsController = {
        
        // Use this as a template to create other fetched results controllers
        let frc = self.cdStack.frcForEntityNamed("Sport", withPredicateFormat: nil, predicateObject: nil, sortDescriptors: "sportName,true", andSectionNameKeyPath: nil)
        
        return frc
        }()

    lazy var frc_venue: NSFetchedResultsController = {
        
        // Use this as a template to create other fetched results controllers
        let frc = self.cdStack.frcForEntityNamed("Venue", withPredicateFormat: nil, predicateObject: nil, sortDescriptors: "venueName,true", andSectionNameKeyPath: nil)
        
        return frc
        }()

    // Network usage settings
    var authToken: String = ""

    // MARK: - Data from the network
    
    // Property to hold/store the fetched collection
    var collection = [AnyObject]()
    
    // Method to fetch the collection
    func collectionGet() -> [AnyObject] {
        
        // Create, configure, and execute a web service request
        let request = WebServiceRequest()
        request.sendRequestToUrlPath("/path/to/resource", forDataKeyName: "Collection", from: self, propertyNamed: "collection")
        
        // Return an empty array; when the request completes, a notification will be sent
        return [AnyObject]()
    }
    
    // Property to hold/store a fetched item
    var item = Dictionary<String, AnyObject>()
    
    func itemGet() -> AnyObject {
        
        // Create, configure, and execute a web service request
        let request = WebServiceRequest()
        request.sendRequestToUrlPath("/path/to/resource", forDataKeyName: "Item", from: self, propertyNamed: "item")
        
        // Return an empty array; when the request completes, a notification will be sent
        return Dictionary<String, AnyObject>()
    }

    // MARK: - Public methods
    
    // Generic 'add new' method
    func addNew(entityName: String) -> AnyObject {
        
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: cdStack.managedObjectContext!) as NSManagedObject
    }
    
    // Sport 'add new' method
    func addNewSport() -> Sport {
        
        return NSEntityDescription.insertNewObjectForEntityForName("Sport", inManagedObjectContext: cdStack.managedObjectContext!) as Sport
    }

    // Sport 'add new' method
    func addNewVenue() -> Venue {
        
        return NSEntityDescription.insertNewObjectForEntityForName("Venue", inManagedObjectContext: cdStack.managedObjectContext!) as Venue
    }
    
    
    // Specific 'add new province' method
    func addNewEvent() -> Event {
        
        return NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: cdStack.managedObjectContext!) as Event
    }
    


    
    // General-purpose fetch request
    func executeFetchRequest(fetchRequest fr: NSFetchRequest) -> [AnyObject] {
        
        // Prepare an error object
        var error: NSError? = nil

        var results = cdStack.managedObjectContext?.executeFetchRequest(fr, error: &error)
        
        if let error = error {
            print("Fetch request error")
            results = []
        }
        
        return results!
    }

    func saveChanges() { cdStack.saveContext() }
    
    init() {
        
        // Check whether the app is being launched for the first time
        // If yes, check if there's an object store file in the app bundle
        // If yes, copy the object store file to the Documents directory
        // If no, create some new data if you need to
        
        // URL to the object store file in the app bundle
        let storeFileInBundle: NSURL? = NSBundle.mainBundle().URLForResource("ObjectStore", withExtension: "sqlite")
        
        // URL to the object store file in the Documents directory
        let storeFileInDocumentsDirectory: NSURL = applicationDocumentsDirectory.URLByAppendingPathComponent("ObjectStore.sqlite")
        
        // System file manager
        let fs: NSFileManager = NSFileManager()
        
        // Check whether this is the first launch of the app
        let isFirstLaunch: Bool = !fs.fileExistsAtPath(storeFileInDocumentsDirectory.path!)
        
        // Check whether the app is supplied with starter data in the app bundle
        let hasStarterData: Bool = storeFileInBundle != nil
        
        if isFirstLaunch {
            
            if hasStarterData {
                
                // Use the supplied starter data
                fs.copyItemAtURL(storeFileInBundle!, toURL: storeFileInDocumentsDirectory, error: nil)
                // Initialize the Core Data stack
                cdStack = CDStack()
                
            } else {
                
                // Initialize the Core Data stack before creating new data
                cdStack = CDStack()
                // Create some new data
                StoreInitializer.create(cdStack)
            }
            
        } else {
            
            // This app has been used/started before, so initialize the Core Data stack
            cdStack = CDStack()
        }
    }
}
