//
//  StoreInitializer.swift
//  Classes
//
//  Created by Peter McIntyre on 2015-02-01.
//  Copyright (c) 2015 School of ICT, Seneca College. All rights reserved.
//

import CoreData

class StoreInitializer {
    
    class func create(cdStack: CDStack) {
        
        // Add code to create data
        
        // For each object that you want to create...
        // Initialize an object
        // Set its properties
        // Save changes
        
        // This app will work with the "Example" entity that you can see in the object model
        
        // If you have not yet run the app (in the simulator), 
        // and you want to create your own object model, you can...
        // Comment out (or delete) the 'create data' code below
        // Delete the entity in the object model
        // Edit the Model class, and its fetched results controller
        // Comment out, delete, or edit the data access statements in the '...List' and '...Detail' controllers

        // If you have did run the app (in the simulator),
        // you will have to do the above, AND delete the app from the simulator
        
        //return
        
        
        let e1 = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: cdStack.managedObjectContext!) as Event
        
        e1.name = "One year to go"
        e1.eventDescription = "One-year countdown to the TORONTO 2015 Pan Am Games"
        e1.location = "Nathan Phillips Square, Toronto and in communities across the Greater Golden Horseshoe region"
        e1.dateAdded = NSDate()
        
        /*
        
        let object2 = NSEntityDescription.insertNewObjectForEntityForName("Example", inManagedObjectContext: cdStack.managedObjectContext!) as NSManagedObject
        
        object2.setValue("Danny", forKey: "attribute1")
        object2.setValue(29, forKey: "attribute2")
        */
        
        cdStack.saveContext()
        
        /*
        let archery = NSEntityDescription.insertNewObjectForEntityForName("Sport", inManagedObjectContext: cdStack.managedObjectContext!) as Sport
        archery.sportName = "Archery"

        let athletics = NSEntityDescription.insertNewObjectForEntityForName("Sport", inManagedObjectContext: cdStack.managedObjectContext!) as Sport
        athletics.sportName = "Athletics"

        let varsity = NSEntityDescription.insertNewObjectForEntityForName("Venue", inManagedObjectContext: cdStack.managedObjectContext!) as Venue
        varsity.venueName = "Varsity Stadium"
        
        cdStack.saveContext()
        */
    }
    
    // Create a new date object
    class func newDate(year: Int, month: Int, day: Int) -> NSDate {
        
        // Configure the objects we need to create the date
        var cal = NSCalendar(identifier: NSGregorianCalendar)!
        cal.timeZone = NSTimeZone(abbreviation: "GMT")!
        var dc = NSDateComponents()
        
        // Set the values of the date components
        dc.year = year
        dc.month = month
        dc.day = day
        dc.hour = 12
        dc.minute = 0
        dc.second = 0
        
        return cal.dateFromComponents(dc)!
    }
    
}
