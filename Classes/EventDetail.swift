//
//  EventDetail.swift
//  Toronto 2015
//
//  Created by Xiaoli Wei on 2015-04-15.
//  Copyright (c) 2015 School of ICT, Seneca College. All rights reserved.
//

import UIKit

class EventDetail: UIViewController, EditItemDelegate {
    
    // MARK: - Properties
    
    var detailItem: Event!
    var model: Model!
    
    // MARK: - User interface
    
    @IBOutlet weak var eventDesc: UITextView!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var dateAdded: UILabel!
    @IBOutlet weak var photo: UIImageView!
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add an 'edit' button to the nav bar, right side
        let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "edit")
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // This code was copied from the viewDidLoad() method
        // It handles initial load, as well as reload (after the 'edit' scene)
        
        eventDesc.text = detailItem.eventDescription
        eventLocation.text = detailItem.location
        
        photo.image = UIImage(data: detailItem.photo)
        
        let date = NSDateFormatter.localizedStringFromDate(detailItem.dateAdded, dateStyle: NSDateFormatterStyle.LongStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        
        dateAdded.text = String(format: "Added: \(date)")
    }
    
    func edit() {
        
        // Create a controller
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AddEditEvent") as EventEdit
        
        // Configure its properties
        vc.title = "Edit"
        vc.model = self.model
        vc.event = self.detailItem
        vc.delegate = self
        
        // Present the controller, using the built-in 'push' navigation
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Delegate methods
    
    func editItemDelegate(controller: AnyObject, didEditItem item: AnyObject?) {
        
        self.model.saveChanges()
        
        // Was pushed on to the navigation stack, so pop it
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
