//
//  Toronto_2015.swift
//  Toronto 2015
//
//  Created by Xiaoli Wei on 2015-04-16.
//  Copyright (c) 2015 School of ICT, Seneca College. All rights reserved.
//

import Foundation
import CoreData

class Event: NSManagedObject {

    @NSManaged var dateAdded: NSDate
    @NSManaged var eventDescription: String
    @NSManaged var location: String
    @NSManaged var name: String
    @NSManaged var photo: NSData

}
