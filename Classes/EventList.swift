//
//  EventList.swift
//  Toronto 2015
//
//  Created by Xiaoli Wei on 2015-04-15.
//  Copyright (c) 2015 School of ICT, Seneca College. All rights reserved.
//

import UIKit
import CoreData

// Notice the protocol conformance
class EventList: UITableViewController, NSFetchedResultsControllerDelegate, EditItemDelegate {
    
    // MARK: - Private properties
    
    var frc: NSFetchedResultsController!
    
    // MARK: - Properties
    
    // Passed in by the app delegate during app initialization
    var model: Model!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure and load the fetched results controller (frc)
        
        frc = model.frc_event
        
        // This controller will be the frc delegate
        frc.delegate = self;
        // No predicate (which means the results will NOT be filtered)
        frc.fetchRequest.predicate = nil;
        
        // Create an error object
        var error: NSError? = nil
        // Perform fetch, and if there's an error, log it
        if !frc.performFetch(&error) { println(error?.description) }
    }
    
    // MARK: - Table view methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.frc.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.frc.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        self.configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        // Get the item for the selected index path
        let item = frc.objectAtIndexPath(indexPath) as Event
        // Configure the cell contents
        cell.textLabel!.text = item.name
    }
    
    // This 'brute force' method will reload the table view
    // The method gets called by the Cocoa runtime,
    // when it notices that the fetched results controller's
    // 'fetchedObjects' (results) collection has changed
    // (because a new item was added)
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toEventDetail" {
            
            // Get a reference to the destination view controller
            let vc = segue.destinationViewController as EventDetail
            
            // From the data source (the fetched results controller)...
            // Get a reference to the object for the tapped/selected table view row
            let item = frc.objectAtIndexPath(self.tableView.indexPathForSelectedRow()!) as Event
            
            // Pass on the objects
            vc.model = self.model
            vc.detailItem = item
            
            // Configure the view if you wish
            vc.title = item.name
        }
        
        if segue.identifier == "toEventEdit" {
            
            // Get a reference to the destination view controller
            let nav = segue.destinationViewController as UINavigationController
            let vc = nav.topViewController as EventEdit
            
            // Configure the view
            vc.delegate = self
            vc.model = self.model
            vc.title = "Add"
        }
        
    }
    
    // MARK: - Delegate methods
    
    func editItemDelegate(controller: AnyObject, didEditItem item: AnyObject?) {
        
        self.model.saveChanges()
        
        // Was presented modally, so dismiss it
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

